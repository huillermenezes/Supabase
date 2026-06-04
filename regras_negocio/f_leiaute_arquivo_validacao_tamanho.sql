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
			, o.name AS caminho_origem
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
			) AS lista_id_leiaute_arquivo
		FROM public.registro_arquivo ra
		INNER JOIN storage.objects o ON CAST(o.metadata ->> 'id' AS BIGINT) = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registrado
		AND ra.conteudo_jsonb IS NULL  -- ainda não processado
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_id_leiaute_arquivo), 0) = 0 THEN
			-- Registra o erro na linha 1 do arquivo
			UPDATE	public.registro_arquivo
			SET	mensagem_erro = 'Nenhum leiaute encontrado para tamanho ' || VRecord.tamanho_linha || '.'
			WHERE	id_registro_arquivo = VRecord.id_registro_arquivo;

			-- Registra o erro nos metadados do storage
			UPDATE storage.objects
			SET metadata = metadata
				|| jsonb_build_object('mensagem_erro', 'Nenhum leiaute encontrado para tamanho ' || VRecord.tamanho_linha || '.')
			WHERE CAST(metadata ->> 'id' AS BIGINT) = VRecord.id_arquivo;

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
		ELSE 
			-- Registra a lista de leiautes encontrados e limpa mensagens de erro
			UPDATE public.registro_arquivo
			SET conteudo_jsonb = jsonb_build_object('lista_id_leiaute_arquivo', VRecord.lista_id_leiaute_arquivo)
				, mensagem_erro =  NULL
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;
		END IF;
	END LOOP;
END;
$$;
