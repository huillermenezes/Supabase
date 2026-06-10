DROP FUNCTION IF EXISTS public.f_processar_header_arquivo() CASCADE;

CREATE OR REPLACE FUNCTION public.f_processar_header_arquivo()
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
			ra.id_arquivo, 
			CAST(ra.conteudo_jsonb ->> 'id_leiaute_arquivo' AS BIGINT) AS id_leiaute_arquivo,
			pla.id_empresa
		FROM public.registro_arquivo ra
		LEFT JOIN public.parametro_leiaute_arquivo pla 
			ON pla.id = CAST(ra.conteudo_jsonb ->> 'id_parametro_leiaute_arquivo' AS BIGINT)
		WHERE ra.numero_linha = 1
		  AND ra.mensagem_erro IS NULL
		  AND ra.conteudo_jsonb ->> 'id_leiaute_arquivo' IS NOT NULL
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM public.header_arquivo ha 
			  WHERE ha.id_arquivo = ra.id_arquivo
		  )
		ORDER BY ra.id_arquivo ASC
		LIMIT 300
	LOOP
		V_id_arquivo := VRecord.id_arquivo;
		VLeiauteID := VRecord.id_leiaute_arquivo;
		V_id_empresa := VRecord.id_empresa;

		-- 2. Atualiza o conteudo_jsonb de registro_arquivo (linha_arquivo = 1) com os campos do header extraídos dinamicamente
		WITH header_json AS (
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
			  AND ra.numero_linha = 1
			  AND ra.mensagem_erro IS NULL
			  AND lca.tipo_campo = 1 -- Header Arquivo
			  AND lca.nome_coluna IS NOT NULL
			GROUP BY ra.id
		)
		UPDATE public.registro_arquivo ra
		SET conteudo_jsonb = ra.conteudo_jsonb || hj.parsed_fields
		FROM header_json hj
		WHERE ra.id = hj.id_registro_arquivo;

		-- 3. Monta a query dinâmica e executa a inserção do header para este arquivo
		SELECT 
			'id_arquivo, id_empresa, id_leiaute_arquivo, tipo_campo, ' || string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
			'ra.id_arquivo, ' || COALESCE(V_id_empresa::TEXT, 'NULL') || ', ' || VLeiauteID || ', 1, ' || string_agg('jpr.' || quote_ident(lca.nome_coluna), ', ') AS select_fields
		INTO V_colunas, V_select
		FROM public.leiaute_campo_arquivo lca
		WHERE lca.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 1 -- Header
		  AND lca.nome_coluna IS NOT NULL
		  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL;

		IF V_colunas IS NOT NULL THEN
			V_sql := format(
				'INSERT INTO public.header_arquivo (%s) ' ||
				'SELECT %s ' ||
				'FROM public.registro_arquivo ra ' ||
				'INNER JOIN jsonb_populate_record(NULL::public.header_arquivo, ra.conteudo_jsonb) jpr ON TRUE ' ||
				'WHERE ra.id_arquivo = %L ' ||
				'  AND ra.numero_linha = 1 ' ||
				'  AND ra.mensagem_erro IS NULL ' ||
				'  AND NOT EXISTS ( ' ||
				'      SELECT 1 FROM public.header_arquivo ha WHERE ha.id_arquivo = ra.id_arquivo ' ||
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
