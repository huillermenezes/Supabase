DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao_tamanho() CASCADE;

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao_tamanho()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	-- Identifica leiautes cujo quantidade_caracteres bate com o tamanho da linha do header.
	-- Lista vazia = nenhum leiaute compatível → erro, arquivo movido para erro/.
	-- Filtro: mensagem_erro IS NULL AND conteudo_jsonb IS NULL = ainda não processado.
	FOR VRecord IN
		SELECT
			ra.id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, LENGTH(ra.linha_arquivo) AS tamanho_linha
			, sod.caminho_origem
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
			, (
				SELECT ARRAY_AGG(la.id_leiaute_arquivo)
				FROM public.leiaute_arquivo la
				WHERE la.registro_ativo = TRUE
				AND la.quantidade_caracteres = LENGTH(ra.linha_arquivo)
			) AS lista_leiaute_tamanho
		FROM public.registro_arquivo ra
		INNER JOIN public.storage_objects_download sod ON sod.id_arquivo = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registado
		AND ra.conteudo_jsonb IS NULL  -- ainda não processado
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_leiaute_tamanho), 0) = 0 THEN
			-- Registra o erro na linha 1 do arquivo
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Nenhum leiaute encontrado para tamanho ' || VRecord.tamanho_linha || '.'
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;

			-- Move o arquivo para a pasta de erro no storage (assíncrono via pg_net)
			PERFORM net.http_post(
				url := VRecord.url_move
				, headers := jsonb_build_object(
					'Authorization', 'Bearer ' || VRecord.auth_key
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'srcKey', VRecord.caminho_origem
					, 'destKey', 'erro/' || VRecord.nome_arquivo
				)
			);
		END IF;
	END LOOP;
END;
$$;
