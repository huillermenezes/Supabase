DROP FUNCTION IF EXISTS public.f_processar_trailer_arquivo();

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
	-- 1. Obtém arquivos pendentes de processamento de trailer (com header e movimento já processados), limitando a 200 por vez
	FOR VRecord IN
		SELECT DISTINCT 
			ra_h.id_arquivo, 
			CAST(ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT) AS id_leiaute_arquivo,
			pla.id_empresa,
			(ra_h.nome_arquivo LIKE 'BV%') AS is_bv
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
		  AND (
			  EXISTS (SELECT 1 FROM public.movimento_arquivo ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_folha_pagamento_240_segmento_a ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_folha_pagamento_240_segmento_b ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_1 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_2 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_3 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_4 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_5 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_adquirente_400_tipo_6 ma WHERE ma.id_arquivo = ra_h.id_arquivo) OR
			  EXISTS (SELECT 1 FROM public.movimento_cartao_retorno_bradesco ma WHERE ma.id_arquivo = ra_h.id_arquivo)
		  )
		  -- O trailer ainda não deve estar processado
		  AND NOT EXISTS (
			  SELECT 1 FROM public.trailer_arquivo ta WHERE ta.id_arquivo = ra_h.id_arquivo
		  )
		ORDER BY is_bv DESC, ra_h.id_arquivo ASC
		LIMIT 300
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

	END LOOP;
END;
$$;
