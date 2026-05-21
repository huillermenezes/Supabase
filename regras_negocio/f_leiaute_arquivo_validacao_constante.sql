DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao_constante() CASCADE;

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao_constante()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	-- Dentre os que passaram na validação de tamanho, mantém apenas os leiautes cujos
	-- campos de valor_padrao do header (tipo_campo = 1) batem com a posição na linha.
	-- Lista vazia = nenhum leiaute reconheceu o header → erro.
	-- Mais de um = ambiguidade (remessa e retorno têm literais distintos, deve sobrar 1) → erro.
	-- Filtro: mensagem_erro IS NULL AND conteudo_jsonb IS NULL = ainda não processado.
	FOR VRecord IN
		SELECT
			ra.id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, sod.caminho_origem
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
			, (
				SELECT ARRAY_AGG(DISTINCT lca.id_leiaute_arquivo)
				FROM public.leiaute_campo_arquivo lca
				WHERE lca.id_leiaute_arquivo = ANY (
					SELECT la.id_leiaute_arquivo
					FROM public.leiaute_arquivo la
					WHERE la.registro_ativo = TRUE
					AND la.quantidade_caracteres = LENGTH(ra.linha_arquivo)
				)
				AND lca.tipo_campo = 1 -- Header Arquivo
				AND lca.valor_padrao IS NOT NULL
				AND lca.valor_padrao = SUBSTRING(ra.linha_arquivo, lca.posicao_inicial, lca.tamanho)
			) AS lista_leiaute_constante
		FROM public.registro_arquivo ra
		INNER JOIN public.storage_objects_download sod ON sod.id_arquivo = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registado
		AND ra.conteudo_jsonb IS NULL  -- ainda não processado
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) = 0 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Nenhum leiaute identificado pelos campos constantes do header.'
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;

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

		ELSIF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) > 1 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Multiplos leiautes identificados pelos campos constantes do header.'
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;

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
