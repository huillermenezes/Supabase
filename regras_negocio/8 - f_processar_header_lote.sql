DROP FUNCTION IF EXISTS public.f_processar_header_lote();

CREATE OR REPLACE FUNCTION public.f_processar_header_lote()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VRecord RECORD;
	V_id_arquivo BIGINT;
	VLeiauteID BIGINT;
	V_id_empresa BIGINT;
	V_colunas TEXT;
	V_select TEXT;
	V_sql TEXT;
BEGIN
	-- 1. Loop para processar arquivos com header do lote pendente
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
		  -- O header do lote ainda não deve estar processado para este arquivo
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM public.header_lote hl 
			  WHERE hl.id_arquivo = ra_h.id_arquivo
		  )
		  -- Mas o layout deve ter campos de tipo_campo = 2 (Header Lote)
		  AND EXISTS (
			  SELECT 1 
			  FROM public.leiaute_campo_arquivo lca 
			  WHERE lca.id_leiaute_arquivo = CAST(ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT)
			    AND lca.tipo_campo = 2
		  )
		ORDER BY ra_h.id_arquivo ASC
		LIMIT 300
	LOOP
		V_id_arquivo := VRecord.id_arquivo;
		VLeiauteID := VRecord.id_leiaute_arquivo;
		V_id_empresa := VRecord.id_empresa;

		-- 2. Atualiza o conteudo_jsonb de registro_arquivo (linhas > 1) que combinem com as constantes do header de lote
		WITH hl_json AS (
			SELECT 
				ra.id AS id_registro_arquivo
				, jsonb_object_agg(
					lca.nome_coluna, 
					SUBSTRING(ra.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER)
				) AS parsed_fields
			FROM public.registro_arquivo ra
			INNER JOIN public.leiaute_campo_arquivo lca 
				ON lca.id_leiaute_arquivo = VLeiauteID
			WHERE ra.id_arquivo = V_id_arquivo
			  AND ra.numero_linha > 1
			  AND ra.mensagem_erro IS NULL
			  AND lca.tipo_campo = 2 -- Header Lote
			  AND lca.nome_coluna IS NOT NULL
			  -- Garante que a linha atende as constantes do Header Lote
			  AND NOT EXISTS (
				  SELECT 1 
				  FROM public.leiaute_campo_arquivo lca2
				  WHERE lca2.id_leiaute_arquivo = VLeiauteID
				    AND lca2.tipo_campo = 2
				    AND lca2.valor_padrao IS NOT NULL
				    AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER)
			  )
			GROUP BY ra.id
		)
		UPDATE public.registro_arquivo ra
		SET conteudo_jsonb = COALESCE(ra.conteudo_jsonb, '{}'::jsonb) || hj.parsed_fields
		FROM hl_json hj
		WHERE ra.id = hj.id_registro_arquivo;

		-- 3. Monta a query dinâmica e executa a inserção do header de lote
		SELECT 
			'id_arquivo, id_empresa, id_leiaute_arquivo, tipo_campo, numero_linha, ' || string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
			'ra.id_arquivo, ' || COALESCE(V_id_empresa::TEXT, 'NULL') || ', ' || VLeiauteID || ', 2, ra.numero_linha, ' || string_agg('jpr.' || quote_ident(lca.nome_coluna), ', ') AS select_fields
		INTO V_colunas, V_select
		FROM public.leiaute_campo_arquivo lca
		WHERE lca.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 2 -- Header Lote
		  AND lca.nome_coluna IS NOT NULL
		  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL;

		IF V_colunas IS NOT NULL THEN
			V_sql := format(
				'INSERT INTO public.header_lote (%s) ' ||
				'SELECT %s ' ||
				'FROM public.registro_arquivo ra ' ||
				'INNER JOIN jsonb_populate_record(NULL::public.header_lote, ra.conteudo_jsonb) jpr ON TRUE ' ||
				'WHERE ra.id_arquivo = %L ' ||
				'  AND ra.numero_linha > 1 ' ||
				'  AND ra.mensagem_erro IS NULL ' ||
				'  AND ra.conteudo_jsonb ->> ''tipo_registro'' = ''1'' ' || -- Garante que é registro tipo 1
				'  AND NOT EXISTS ( ' ||
				'      SELECT 1 FROM public.header_lote hl WHERE hl.id_arquivo = ra.id_arquivo AND hl.numero_linha = ra.numero_linha' ||
				'  )',
				V_colunas,
				V_select,
				V_id_arquivo
			);

			EXECUTE V_sql;
		END IF;
	END LOOP;
END;
$$;
