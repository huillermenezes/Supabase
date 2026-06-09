DROP FUNCTION IF EXISTS public.f_processar_trailer_arquivo() CASCADE;

CREATE OR REPLACE FUNCTION public.f_processar_trailer_arquivo()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_id_arquivo BIGINT;
	VLeiauteID BIGINT;
	V_id_empresa BIGINT;
	V_colunas TEXT;
	V_select TEXT;
	V_sql TEXT;
	V_caminho_origem TEXT;
	V_nome_arquivo TEXT;
	V_url_move TEXT;
	V_auth_key TEXT;
	VRecord RECORD;
BEGIN
	-- 1. Obtém arquivos pendentes de processamento de trailer (com header e movimento já processados), limitando a 30 por vez
	FOR VRecord IN
		SELECT DISTINCT 
			ra_h.id_arquivo, 
			CAST(ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT) AS id_leiaute_arquivo,
			pla.id_empresa
		FROM public.registro_arquivo ra_h
		LEFT JOIN public.parametro_leiaute_arquivo pla 
			ON pla.id = CAST(ra_h.conteudo_jsonb ->> 'id_parametro_leiaute_arquivo' AS BIGINT)
		WHERE ra_h.numero_linha = 1
		  AND ra_h.mensagem_erro IS NULL
		  AND ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' IS NOT NULL
		  -- O header do arquivo já deve estar processado
		  AND EXISTS (
			  SELECT 1 FROM public.header_arquivo ha WHERE ha.id_arquivo = ra_h.id_arquivo
		  )
		  -- Os movimentos já devem estar processados
		  AND EXISTS (
			  SELECT 1 FROM public.movimento_arquivo ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  -- O trailer ainda não deve estar processado
		  AND NOT EXISTS (
			  SELECT 1 FROM public.trailer_arquivo ta WHERE ta.id_arquivo = ra_h.id_arquivo
		  )
		LIMIT 30
	LOOP
		V_id_arquivo := VRecord.id_arquivo;
		VLeiauteID := VRecord.id_leiaute_arquivo;
		V_id_empresa := VRecord.id_empresa;

		-- 2. Atualiza o conteudo_jsonb da linha do trailer (linhas > 1) com os campos extraídos
		WITH trailer_json AS (
			SELECT 
				ra.id AS id_registro_arquivo
				, jsonb_object_agg(
					lca.nome_coluna, 
					SUBSTRING(ra.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER)
				) || jsonb_build_object('_is_trailer', true) AS parsed_fields
			FROM public.registro_arquivo ra
			INNER JOIN public.leiaute_campo_arquivo lca 
				ON lca.id_leiaute_arquivo = VLeiauteID
			WHERE ra.id_arquivo = V_id_arquivo
			  AND ra.numero_linha > 1 -- A linha do trailer nunca é a primeira linha (header)
			  AND ra.mensagem_erro IS NULL
			  AND lca.tipo_campo = 5 -- Trailer Arquivo
			  AND lca.nome_coluna IS NOT NULL
			  -- Filtra para garantir que a linha corresponde de fato ao layout de trailer (não viola nenhuma constante e bate com pelo menos uma constante)
			  AND NOT EXISTS (
				  SELECT 1 
				  FROM public.leiaute_campo_arquivo lca2
				  WHERE lca2.id_leiaute_arquivo = VLeiauteID
				    AND lca2.tipo_campo = 5
				    AND lca2.valor_padrao IS NOT NULL
				    AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER)
			  )
			  AND EXISTS (
				  SELECT 1 
				  FROM public.leiaute_campo_arquivo lca2
				  WHERE lca2.id_leiaute_arquivo = VLeiauteID
				    AND lca2.tipo_campo = 5
				    AND lca2.valor_padrao IS NOT NULL
				    AND lca2.valor_padrao = SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER)
			  )
			GROUP BY ra.id, ra.numero_linha
			ORDER BY ra.numero_linha DESC
			LIMIT 1
		)
		UPDATE public.registro_arquivo ra
		SET conteudo_jsonb = COALESCE(ra.conteudo_jsonb, '{}'::jsonb) || tj.parsed_fields
		FROM trailer_json tj
		WHERE ra.id = tj.id_registro_arquivo;

		-- 3. Monta a query dinâmica e executa a inserção do trailer
		SELECT 
			'id_arquivo, id_empresa, id_leiaute_arquivo, tipo_campo, numero_linha, ' || string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
			'ra.id_arquivo, ' || COALESCE(V_id_empresa::TEXT, 'NULL') || ', ' || VLeiauteID || ', 5, ra.numero_linha, ' || string_agg('jpr.' || quote_ident(lca.nome_coluna), ', ') AS select_fields
		INTO V_colunas, V_select
		FROM public.leiaute_campo_arquivo lca
		WHERE lca.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 5 -- Trailer Arquivo
		  AND lca.nome_coluna IS NOT NULL
		  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL;

		IF V_colunas IS NOT NULL THEN
			V_sql := format(
				'INSERT INTO public.trailer_arquivo (%s) ' ||
				'SELECT %s ' ||
				'FROM public.registro_arquivo ra ' ||
				'INNER JOIN jsonb_populate_record(NULL::public.trailer_arquivo, ra.conteudo_jsonb) jpr ON TRUE ' ||
				'WHERE ra.id_arquivo = %L ' ||
				'  AND ra.numero_linha > 1 ' ||
				'  AND ra.mensagem_erro IS NULL ' ||
				'  AND (ra.conteudo_jsonb ->> ''_is_trailer'')::BOOLEAN = TRUE',
				V_colunas,
				V_select,
				V_id_arquivo
			);

			EXECUTE V_sql;
		END IF;

		-- 4. Ao final do processamento com sucesso de todas as etapas (trailer inserido), move o arquivo para backup/
		SELECT
			o.name AS caminho_origem
			, ra_h.nome_arquivo
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
		INTO V_caminho_origem, V_nome_arquivo, V_url_move, V_auth_key
		FROM public.registro_arquivo ra_h
		INNER JOIN storage.objects o ON o.name IN (CONCAT('processamento/', ra_h.nome_arquivo), CONCAT('input/', ra_h.nome_arquivo)) AND o.bucket_id = 'hetzner_files'
		WHERE ra_h.id_arquivo = V_id_arquivo
		  AND ra_h.numero_linha = 1;

		IF V_url_move IS NOT NULL AND V_auth_key IS NOT NULL AND V_caminho_origem IS NOT NULL THEN
			PERFORM net.http_post(
				url := V_url_move
				, headers := jsonb_build_object(
					'apikey', TRIM(BOTH E' \r\n\t' FROM V_auth_key)
					, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM V_auth_key))
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'sourceKey', V_caminho_origem
					, 'destinationKey', CONCAT('backup/', V_nome_arquivo)
				)
			);
		END IF;

	END LOOP;
END;
$$;
