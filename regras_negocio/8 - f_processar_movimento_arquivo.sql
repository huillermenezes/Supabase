DROP FUNCTION IF EXISTS public.f_processar_movimento_arquivo() CASCADE;

CREATE OR REPLACE FUNCTION public.f_processar_movimento_arquivo()
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
	-- 1. Loop para processar até 200 arquivos por vez
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
			  SELECT 1 
			  FROM public.header_arquivo ha 
			  WHERE ha.id_arquivo = ra_h.id_arquivo
		  )
		  -- O movimento ainda não deve estar processado
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM public.movimento_arquivo ma 
			  WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		ORDER BY ra_h.id_arquivo ASC
		LIMIT 300
	LOOP
		V_id_arquivo := VRecord.id_arquivo;
		VLeiauteID := VRecord.id_leiaute_arquivo;
		V_id_empresa := VRecord.id_empresa;

		-- SE FOR SICOOB CNAB 240 RETORNO, PROCESSA PELAS FUNÇÕES ESPECÍFICAS
		IF VLeiauteID = (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1) THEN
			PERFORM public.f_processar_movimento_sicoob_240_t(V_id_arquivo, V_id_empresa, VLeiauteID);
			PERFORM public.f_processar_movimento_sicoob_240_u(V_id_arquivo, V_id_empresa, VLeiauteID);
			CONTINUE;
		END IF;

		-- 2. Atualiza o conteudo_jsonb de registro_arquivo (linhas > 1) com os campos do movimento extraídos dinamicamente
		WITH mov_json AS (
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
			  AND lca.tipo_campo = 3 -- Movimento
			  AND lca.nome_coluna IS NOT NULL
			  -- Filtra as linhas que pertencem de fato ao layout de movimento
			  AND NOT EXISTS (
				  SELECT 1 
				  FROM public.leiaute_campo_arquivo lca2
				  WHERE lca2.id_leiaute_arquivo = VLeiauteID
				    AND lca2.tipo_campo = 3
				    AND lca2.valor_padrao IS NOT NULL
				    AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER)
			  )
			GROUP BY ra.id
		)
		UPDATE public.registro_arquivo ra
		SET conteudo_jsonb = COALESCE(ra.conteudo_jsonb, '{}'::jsonb) || mj.parsed_fields
		FROM mov_json mj
		WHERE ra.id = mj.id_registro_arquivo;

		-- 3. Monta a query dinâmica e executa a inserção dos movimentos para este arquivo
		SELECT 
			'id_arquivo, id_empresa, id_leiaute_arquivo, tipo_campo, numero_linha, ' || string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
			'ra.id_arquivo, ' || COALESCE(V_id_empresa::TEXT, 'NULL') || ', ' || VLeiauteID || ', 3, ra.numero_linha, ' || string_agg('jpr.' || quote_ident(lca.nome_coluna), ', ') AS select_fields
		INTO V_colunas, V_select
		FROM public.leiaute_campo_arquivo lca
		WHERE lca.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 3 -- Movimento
		  AND lca.nome_coluna IS NOT NULL
		  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL;

		IF V_colunas IS NOT NULL THEN
			V_sql := format(
				'INSERT INTO public.movimento_arquivo (%s) ' ||
				'SELECT %s ' ||
				'FROM public.registro_arquivo ra ' ||
				'INNER JOIN jsonb_populate_record(NULL::public.movimento_arquivo, ra.conteudo_jsonb) jpr ON TRUE ' ||
				'WHERE ra.id_arquivo = %L ' ||
				'  AND ra.numero_linha > 1 ' ||
				'  AND ra.mensagem_erro IS NULL ' ||
				'  AND NOT EXISTS ( ' ||
				'      SELECT 1 FROM public.movimento_arquivo ma WHERE ma.id_arquivo = ra.id_arquivo ' ||
				'  ) ' ||
				'  AND NOT EXISTS ( ' ||
				'      SELECT 1 ' ||
				'      FROM public.leiaute_campo_arquivo lca2 ' ||
				'      WHERE lca2.id_leiaute_arquivo = %L ' ||
				'        AND lca2.tipo_campo = 3 ' ||
				'        AND lca2.valor_padrao IS NOT NULL ' ||
				'        AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER) ' ||
				'  )',
				V_colunas,
				V_select,
				V_id_arquivo,
				VLeiauteID
			);

			EXECUTE V_sql;
		END IF;
	END LOOP;
END;
$$;
