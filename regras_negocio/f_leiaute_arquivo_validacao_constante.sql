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
	-- Filtro: mensagem_erro IS NULL AND conteudo_jsonb IS NOT NULL = passou no tamanho.
	FOR VRecord IN
		SELECT
			ra.id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, o.name AS caminho_origem
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
			, (
				SELECT ARRAY_AGG(id_leiaute_arquivo)
				FROM (
					-- Leiautes cujos campos constantes do header batem com a linha do arquivo
					SELECT lca.id_leiaute_arquivo
					FROM public.leiaute_campo_arquivo lca
					WHERE lca.id_leiaute_arquivo = ANY(
						ARRAY(SELECT jsonb_array_elements_text(ra.conteudo_jsonb -> 'lista_id_leiaute_arquivo')::BIGINT)
					)
					AND lca.tipo_campo = 1 -- Header Arquivo
					AND lca.valor_padrao IS NOT NULL
					GROUP BY lca.id_leiaute_arquivo
					HAVING bool_and(lca.valor_padrao = SUBSTRING(ra.linha_arquivo, lca.posicao_inicial, lca.tamanho))

					UNION

					-- Leiautes do tamanho compatível que não possuem nenhum campo constante cadastrado no Header
					SELECT la_id
					FROM unnest(ARRAY(SELECT jsonb_array_elements_text(ra.conteudo_jsonb -> 'lista_id_leiaute_arquivo')::BIGINT)) la_id
					WHERE NOT EXISTS (
						SELECT 1 
						FROM public.leiaute_campo_arquivo lca
						WHERE lca.id_leiaute_arquivo = la_id
						AND lca.tipo_campo = 1 -- Header Arquivo
						AND lca.valor_padrao IS NOT NULL
					)
				) candidates
			) AS lista_leiaute_constante
		FROM public.registro_arquivo ra
		INNER JOIN storage.objects o ON CAST(o.metadata ->> 'id' AS BIGINT) = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registrado
		AND NOT NULLIF(TRIM(ra.conteudo_jsonb ->> 'lista_id_leiaute_arquivo'), '') IS NULL  -- já tem candidatos de tamanho
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) = 0 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Nenhum leiaute identificado pelos campos constantes do header.'
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;

			-- Registra o erro nos metadados do storage
			UPDATE storage.objects
			SET metadata = metadata
				|| jsonb_build_object('mensagem_erro', 'Nenhum leiaute identificado pelos campos constantes do header.')
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

		ELSIF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) > 1 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Multiplos leiautes identificados pelos campos constantes do header.'
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;

			-- Registra o erro nos metadados do storage
			UPDATE storage.objects
			SET metadata = metadata
				|| jsonb_build_object('mensagem_erro', 'Multiplos leiautes identificados pelos campos constantes do header.')
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
			-- Registra a lista de leiautes atualizada com o único candidato sobrevivente
			UPDATE public.registro_arquivo
			SET conteudo_jsonb = jsonb_build_object('lista_id_leiaute_arquivo', VRecord.lista_leiaute_constante)
				, mensagem_erro =  NULL
			WHERE id_registro_arquivo = VRecord.id_registro_arquivo;
		END IF;
	END LOOP;
END;
$$;
