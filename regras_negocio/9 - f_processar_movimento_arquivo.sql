DROP FUNCTION IF EXISTS public.f_processar_movimento_arquivo() CASCADE;

CREATE OR REPLACE FUNCTION public.f_processar_movimento_arquivo()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VLeiauteID BIGINT;
	V_colunas TEXT;
	V_select TEXT;
	V_sql TEXT;
BEGIN
	-- 1. Atualiza o conteudo_jsonb de registro_arquivo (linhas > 1) com os campos do movimento extraídos dinamicamente sem loops
	WITH mov_json AS (
		SELECT 
			ra.id AS id_registro_arquivo
			, jsonb_object_agg(
				lca.nome_coluna, 
				SUBSTRING(ra.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER)
			) AS parsed_fields
		FROM public.registro_arquivo ra
		INNER JOIN public.registro_arquivo ra_h
			ON ra_h.id_arquivo = ra.id_arquivo AND ra_h.numero_linha = 1
		INNER JOIN public.leiaute_campo_arquivo lca 
			ON lca.id_leiaute_arquivo = CAST(ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT)
		WHERE ra.numero_linha > 1
		  AND ra.mensagem_erro IS NULL
		  AND ra_h.mensagem_erro IS NULL
		  AND ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' IS NOT NULL
		  AND lca.tipo_campo = 3 -- Movimento
		  AND lca.nome_coluna IS NOT NULL
		  -- O header do arquivo já deve estar processado
		  AND EXISTS (
			  SELECT 1 
			  FROM public.header_arquivo ha 
			  WHERE ha.id_arquivo = ra.id_arquivo
		  )
		  -- Evita processar se os movimentos desse arquivo já foram gravados na tabela final
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM public.movimento_arquivo ma 
			  WHERE ma.id_arquivo = ra.id_arquivo
		  )
		  -- Filtra as linhas que pertencem de fato ao layout de movimento
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM public.leiaute_campo_arquivo lca2
			  WHERE lca2.id_leiaute_arquivo = lca.id_leiaute_arquivo
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

	-- 2. Obtém o ID do leiaute a ser processado (um de cada vez para geração de SQL dinâmico em lote)
	SELECT DISTINCT CAST(ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT) INTO VLeiauteID
	FROM public.registro_arquivo ra_h
	WHERE ra_h.numero_linha = 1
	  AND ra_h.mensagem_erro IS NULL
	  AND ra_h.conteudo_jsonb ->> 'id_leiaute_arquivo' IS NOT NULL
	  AND EXISTS (
		  SELECT 1 
		  FROM public.header_arquivo ha 
		  WHERE ha.id_arquivo = ra_h.id_arquivo
	  )
	  AND NOT EXISTS (
		  SELECT 1 
		  FROM public.movimento_arquivo ma 
		  WHERE ma.id_arquivo = ra_h.id_arquivo
	  )
	LIMIT 1;

	-- 3. Se houver um layout identificado, monta a query dinâmica e executa a inserção em lote dos movimentos
	IF VLeiauteID IS NOT NULL THEN
		-- Descobre as colunas configuradas na tabela leiaute_campo_arquivo para o layout atual
		SELECT 
			'id_arquivo, id_leiaute_arquivo, tipo_campo, numero_linha, ' || string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
			'ra.id_arquivo, (ra_h.conteudo_jsonb ->> ''id_leiaute_arquivo'')::BIGINT, 3, ra.numero_linha, ' || string_agg('jpr.' || quote_ident(lca.nome_coluna), ', ') AS select_fields
		INTO V_colunas, V_select
		FROM public.leiaute_campo_arquivo lca
		WHERE lca.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 3 -- Movimento
		  AND lca.nome_coluna IS NOT NULL
		  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL;

		-- Executa a inserção em lote para este layout de forma genérica
		IF V_colunas IS NOT NULL THEN
			V_sql := format(
				'INSERT INTO public.movimento_arquivo (%s) ' ||
				'SELECT %s ' ||
				'FROM public.registro_arquivo ra ' ||
				'INNER JOIN public.registro_arquivo ra_h ON ra_h.id_arquivo = ra.id_arquivo AND ra_h.numero_linha = 1 ' ||
				'INNER JOIN jsonb_populate_record(NULL::public.movimento_arquivo, ra.conteudo_jsonb) jpr ON TRUE ' ||
				'WHERE ra.numero_linha > 1 ' ||
				'  AND ra.mensagem_erro IS NULL ' ||
				'  AND ra_h.mensagem_erro IS NULL ' ||
				'  AND CAST(ra_h.conteudo_jsonb ->> ''id_leiaute_arquivo'' AS BIGINT) = %L ' ||
				'  AND EXISTS ( ' ||
				'      SELECT 1 FROM public.header_arquivo ha WHERE ha.id_arquivo = ra.id_arquivo ' ||
				'  ) ' ||
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
				VLeiauteID,
				VLeiauteID
			);

			EXECUTE V_sql;
		END IF;
	END IF;
END;
$$;
