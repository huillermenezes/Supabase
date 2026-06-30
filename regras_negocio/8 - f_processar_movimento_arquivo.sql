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
	V_tabela_destino TEXT;
	V_denominacao TEXT;
	VGroupRecord RECORD;
BEGIN
	-- 1. Loop para processar até 200 arquivos por vez
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
			  SELECT 1 
			  FROM public.header_arquivo ha 
			  WHERE ha.id_arquivo = ra_h.id_arquivo
		  )
		  -- O movimento ainda não deve estar processado
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_arquivo ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_folha_pagamento_240_segmento_a ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_folha_pagamento_240_segmento_b ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_1 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_2 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_3 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_4 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_5 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_adquirente_400_tipo_6 ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		  AND NOT EXISTS (
			  SELECT 1 FROM public.movimento_cartao_retorno_bradesco ma WHERE ma.id_arquivo = ra_h.id_arquivo
		  )
		ORDER BY is_bv DESC, ra_h.id_arquivo ASC
		LIMIT 300
	LOOP
		V_id_arquivo := VRecord.id_arquivo;
		VLeiauteID := VRecord.id_leiaute_arquivo;
		V_id_empresa := VRecord.id_empresa;


		-- 2. Atualiza o conteudo_jsonb de registro_arquivo (linhas > 1) com os campos do movimento extraídos dinamicamente
		WITH line_groups AS (
			SELECT 
				ra.id AS id_registro_arquivo,
				ra.linha_arquivo,
				ra.numero_linha,
				ra.conteudo_jsonb,
				g.grupo,
				NOT EXISTS (
					SELECT 1
					FROM public.leiaute_campo_arquivo lca2
					WHERE lca2.id_leiaute_arquivo = VLeiauteID
					  AND lca2.tipo_campo = 3
					  AND lca2.grupo = g.grupo
					  AND lca2.valor_padrao IS NOT NULL
					  AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER)
				) AS group_matches
			FROM public.registro_arquivo ra
			CROSS JOIN (
				SELECT DISTINCT lca3.grupo AS grupo
				FROM public.leiaute_campo_arquivo lca3
				WHERE lca3.id_leiaute_arquivo = VLeiauteID
				  AND lca3.tipo_campo = 3
				  AND lca3.nome_coluna IS NOT NULL
			) g
			WHERE ra.id_arquivo = V_id_arquivo
			  AND ra.numero_linha > 1
			  AND ra.mensagem_erro IS NULL
		),
		matching_lines AS (
			SELECT 
				id_registro_arquivo,
				linha_arquivo,
				numero_linha,
				conteudo_jsonb,
				ARRAY_AGG(grupo) FILTER (WHERE group_matches) AS matched_groups
			FROM line_groups
			GROUP BY id_registro_arquivo, linha_arquivo, numero_linha, conteudo_jsonb
			HAVING 
				(
					NOT EXISTS (
						SELECT 1 
						FROM public.leiaute_campo_arquivo lca4
						WHERE lca4.id_leiaute_arquivo = VLeiauteID
						  AND lca4.tipo_campo = 3
						  AND lca4.nome_coluna IS NOT NULL
						  AND lca4.grupo = 'geral'
					)
					OR BOOL_OR(grupo = 'geral' AND group_matches)
				)
				AND (
					NOT EXISTS (
						SELECT 1 
						FROM public.leiaute_campo_arquivo lca4
						WHERE lca4.id_leiaute_arquivo = VLeiauteID
						  AND lca4.tipo_campo = 3
						  AND lca4.nome_coluna IS NOT NULL
						  AND lca4.grupo <> 'geral'
					)
					OR BOOL_OR(grupo <> 'geral' AND group_matches)
				)
		),
		mov_json AS (
			SELECT 
				ml.id_registro_arquivo
				, jsonb_object_agg(
					lca.nome_coluna, 
					SUBSTRING(ml.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER)
				) AS parsed_fields
			FROM matching_lines ml
			INNER JOIN public.leiaute_campo_arquivo lca 
				ON lca.id_leiaute_arquivo = VLeiauteID
				AND lca.tipo_campo = 3
				AND lca.nome_coluna IS NOT NULL
				AND lca.grupo = ANY(ml.matched_groups)
			GROUP BY ml.id_registro_arquivo
		)
		UPDATE public.registro_arquivo ra
		SET conteudo_jsonb = COALESCE(ra.conteudo_jsonb, '{}'::jsonb) || mj.parsed_fields
		FROM mov_json mj
		WHERE ra.id = mj.id_registro_arquivo;

		-- 3. Monta a query dinâmica e executa a inserção dos movimentos para cada grupo do layout
		FOR VGroupRecord IN
			SELECT DISTINCT lca3.grupo AS grupo
			FROM public.leiaute_campo_arquivo lca3
			WHERE lca3.id_leiaute_arquivo = VLeiauteID
			  AND lca3.tipo_campo = 3 -- Movimento
			  AND lca3.nome_coluna IS NOT NULL
		LOOP
			-- Mapeia o grupo para a respectiva tabela destino
			IF VGroupRecord.grupo = 'sega' THEN
				V_tabela_destino := 'public.movimento_folha_pagamento_240_segmento_a';
			ELSIF VGroupRecord.grupo = 'segb' THEN
				V_tabela_destino := 'public.movimento_folha_pagamento_240_segmento_b';
			ELSIF VGroupRecord.grupo = 'segt' THEN
				V_tabela_destino := 'public.movimento_240_segmento_t';
			ELSIF VGroupRecord.grupo = 'segu' THEN
				V_tabela_destino := 'public.movimento_240_segmento_u';
			ELSIF VGroupRecord.grupo = 'cartao_bradesco' THEN
				V_tabela_destino := 'public.movimento_cartao_retorno_bradesco';
			ELSIF VGroupRecord.grupo LIKE 'getnet%' THEN
				V_tabela_destino := 'public.movimento_adquirente_400_tipo_' || SUBSTRING(VGroupRecord.grupo FROM 'getnet([0-9]+)');
			ELSE
				V_tabela_destino := 'public.movimento_arquivo';
			END IF;

			-- Seleciona somente as colunas do grupo atual que de fato existem na tabela final
			SELECT 
				'id_arquivo, id_empresa, id_leiaute_arquivo, tipo_campo, numero_linha, ' || 
				string_agg(quote_ident(lca.nome_coluna), ', ') AS colunas,
				
				'ra.id_arquivo, ' || COALESCE(V_id_empresa::TEXT, 'NULL') || ', ' || VLeiauteID || ', 3, ra.numero_linha, ' || 
				string_agg('NULLIF(TRIM(ra.conteudo_jsonb ->> ' || quote_literal(lca.nome_coluna) || '), '''')', ', ') AS select_fields
			INTO V_colunas, V_select
			FROM public.leiaute_campo_arquivo lca
			WHERE lca.id_leiaute_arquivo = VLeiauteID
			  AND lca.tipo_campo = 3 -- Movimento
			  AND lca.nome_coluna IS NOT NULL
			  AND NULLIF(TRIM(lca.nome_coluna), '') IS NOT NULL
			  AND lca.grupo = VGroupRecord.grupo
			  -- Apenas colunas que realmente existem na tabela destino (ignora metadados de controle/segmento)
			  AND EXISTS (
				  SELECT 1 
				  FROM information_schema.columns 
				  WHERE table_schema = split_part(V_tabela_destino, '.', 1)
				    AND table_name = split_part(V_tabela_destino, '.', 2)
				    AND column_name = lca.nome_coluna
			  );

			IF V_colunas IS NOT NULL THEN
				V_sql := format(
					'INSERT INTO ' || V_tabela_destino || ' (%1$s) ' ||
					'SELECT %2$s ' ||
					'FROM public.registro_arquivo ra ' ||
					'WHERE ra.id_arquivo = %3$L ' ||
					'  AND ra.numero_linha > 1 ' ||
					'  AND ra.mensagem_erro IS NULL ' ||
					'  AND NOT EXISTS ( ' ||
					'      SELECT 1 FROM ' || V_tabela_destino || ' ma WHERE ma.id_arquivo = ra.id_arquivo AND ma.numero_linha = ra.numero_linha ' ||
					'  ) ' ||
					'  AND NOT EXISTS ( ' ||
					'      SELECT 1 FROM public.leiaute_campo_arquivo lca2 ' ||
					'      WHERE lca2.id_leiaute_arquivo = %4$L ' ||
					'        AND lca2.tipo_campo = 3 ' ||
					'        AND lca2.grupo = ''geral'' ' ||
					'        AND lca2.valor_padrao IS NOT NULL ' ||
					'        AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER) ' ||
					'  ) ' ||
					CASE 
						WHEN VGroupRecord.grupo <> 'geral' THEN
							format(
								'  AND NOT EXISTS ( ' ||
								'      SELECT 1 FROM public.leiaute_campo_arquivo lca2 ' ||
								'      WHERE lca2.id_leiaute_arquivo = %1$L ' ||
								'        AND lca2.tipo_campo = 3 ' ||
								'        AND lca2.grupo = %2$L ' ||
								'        AND lca2.valor_padrao IS NOT NULL ' ||
								'        AND lca2.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca2.posicao_inicial::INTEGER, lca2.tamanho::INTEGER) ' ||
								'  ) ',
								VLeiauteID, VGroupRecord.grupo
							)
						ELSE ''
					END,
					V_colunas,
					V_select,
					V_id_arquivo,
					VLeiauteID
				);

				EXECUTE V_sql;
			END IF;
		END LOOP;
	END LOOP;
END;
$$;
