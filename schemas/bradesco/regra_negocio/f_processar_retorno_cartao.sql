DROP FUNCTION IF EXISTS bradesco.f_processar_retorno_cartao(BIGINT);

CREATE OR REPLACE FUNCTION bradesco.f_processar_retorno_cartao(
	p_id_arquivo BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_rec RECORD;
	V_parts TEXT[];
	V_id_empresa BIGINT := 1;
BEGIN
	-- 0. Validação de Segurança: Garante que o arquivo é de Retorno de Cartão Bradesco (começa com 'BVXB')
	IF NOT EXISTS (
		SELECT 1 
		FROM public.registro_arquivo ra
		WHERE ra.id_arquivo = p_id_arquivo
		  AND (ra.nome_arquivo LIKE 'BVXB%' OR ra.linha_arquivo LIKE '0|%')
	) THEN
		RAISE NOTICE 'O arquivo % não é um retorno de cartão de crédito Bradesco.', p_id_arquivo;
		RETURN;
	END IF;

	-- 1. Tenta recuperar id_empresa caso já esteja parametrizado por CNPJ em parametro_leiaute_arquivo
	SELECT COALESCE(
		CAST(ra.conteudo_jsonb ->> 'id_empresa' AS BIGINT),
		pla.id_empresa,
		1
	)
	INTO V_id_empresa
	FROM public.registro_arquivo ra
	LEFT JOIN bradesco.parametro_leiaute_arquivo pla 
		ON pla.codigo = REGEXP_REPLACE(SPLIT_PART(ra.linha_arquivo, '|', 11), '\D', '', 'g')
	WHERE ra.id_arquivo = p_id_arquivo
	  AND ra.numero_linha = 1;

	-- 2. Loop pelas linhas do arquivo armazenadas em registro_arquivo
	FOR V_rec IN
		SELECT 
			ra.id AS id_registro_arquivo,
			ra.numero_linha,
			ra.linha_arquivo
		FROM public.registro_arquivo ra
		WHERE ra.id_arquivo = p_id_arquivo
		  AND ra.mensagem_erro IS NULL
		ORDER BY ra.numero_linha ASC
	LOOP
		-- Separa a linha pelo delimitador pipe (|)
		V_parts := string_to_array(V_rec.linha_arquivo, '|');

		IF array_length(V_parts, 1) > 0 THEN
			-- TIPO 0: HEADER DO ARQUIVO
			IF TRIM(V_parts[1]) = '0' THEN
				INSERT INTO bradesco.cartao_credito_header_arquivo (
					id_arquivo
					, id_empresa
					, numero_linha
					, codigo_registro
					, codigo_estabelecimento_centralizador
					, nome_estabelecimento
					, data_geracao
					, data_processamento
					, cnpj_estabelecimento
				) VALUES (
					p_id_arquivo
					, V_id_empresa
					, V_rec.numero_linha
					, NULLIF(TRIM(V_parts[1]), '')
					, NULLIF(TRIM(V_parts[2]), '')
					, CASE WHEN array_length(V_parts, 1) >= 6 THEN NULLIF(TRIM(V_parts[6]), '') ELSE NULL END
					-- Converte Data Geração (DD/MM/YYYY ou YYYY/MM/DD)
					, CASE 
						WHEN array_length(V_parts, 1) >= 7 AND NULLIF(TRIM(V_parts[7]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[7]) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(V_parts[7]), 'DD/MM/YYYY')
								WHEN TRIM(V_parts[7]) ~ '^\d{4}/\d{2}/\d{2}$' THEN TO_DATE(TRIM(V_parts[7]), 'YYYY/MM/DD')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Converte Data Processamento (DD/MM/YYYY ou YYYY/MM/DD)
					, CASE 
						WHEN array_length(V_parts, 1) >= 8 AND NULLIF(TRIM(V_parts[8]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[8]) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(V_parts[8]), 'DD/MM/YYYY')
								WHEN TRIM(V_parts[8]) ~ '^\d{4}/\d{2}/\d{2}$' THEN TO_DATE(TRIM(V_parts[8]), 'YYYY/MM/DD')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					, CASE WHEN array_length(V_parts, 1) >= 11 THEN NULLIF(TRIM(V_parts[11]), '') ELSE NULL END
				)
				ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

			-- TIPO 1: DETALHE DO PORTADOR / CARTÃO
			ELSIF TRIM(V_parts[1]) = '1' THEN
				INSERT INTO bradesco.cartao_credito_detalhe_portador (
					id_arquivo
					, id_empresa
					, numero_linha
					, codigo_registro
					, codigo_estabelecimento
					, numero_cartao
					, nome_portador
					, endereco_portador
					, numero_endereco
					, bairro_portador
					, cidade_portador
					, uf_portador
					, cep_portador
					, cpf_cnpj_portador
				) VALUES (
					p_id_arquivo
					, V_id_empresa
					, V_rec.numero_linha
					, NULLIF(TRIM(V_parts[1]), '')
					, NULLIF(TRIM(V_parts[2]), '')
					, CASE WHEN array_length(V_parts, 1) >= 4 THEN NULLIF(TRIM(V_parts[4]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 8 THEN NULLIF(TRIM(V_parts[8]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 9 THEN NULLIF(TRIM(V_parts[9]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 10 THEN NULLIF(TRIM(V_parts[10]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 11 THEN NULLIF(TRIM(V_parts[11]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 12 THEN NULLIF(TRIM(V_parts[12]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 13 THEN NULLIF(TRIM(V_parts[13]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 14 THEN NULLIF(TRIM(V_parts[14]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 16 THEN NULLIF(TRIM(V_parts[16]), '') ELSE NULL END
				)
				ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

			-- TIPO 2: TRANSAÇÕES / MOVIMENTO
			ELSIF TRIM(V_parts[1]) = '2' THEN
				INSERT INTO bradesco.cartao_credito_movimento_arquivo (
					id_arquivo
					, id_empresa
					, numero_linha
					, codigo_registro
					, codigo_estabelecimento
					, numero_cartao
					, numero_parcelas
					, numero_parcela_relacionada
					, nsu_adquirente
					, data_transacao
					, valor_transacao
					, valor_faturado
					, data_pagamento
					, moeda
					, cidade_estabelecimento
					, nome_estabelecimento
					, mcc
					, categoria_mcc
					, simbolo_moeda
					, sinal_transacao
					, data_cotacao
					, taxa_conversao
					, valor_reais
					, pais_transacao
					, registro_postagem
				) VALUES (
					p_id_arquivo
					, V_id_empresa
					, V_rec.numero_linha
					, NULLIF(TRIM(V_parts[1]), '')
					, NULLIF(TRIM(V_parts[2]), '')
					, CASE WHEN array_length(V_parts, 1) >= 4 THEN NULLIF(TRIM(V_parts[4]), '') ELSE NULL END
					-- Número de parcelas como Integer
					, CASE WHEN array_length(V_parts, 1) >= 5 AND NULLIF(TRIM(V_parts[5]), '') IS NOT NULL THEN CAST(TRIM(V_parts[5]) AS INTEGER) ELSE NULL END
					-- Número da parcela relacionada como Integer
					, CASE WHEN array_length(V_parts, 1) >= 6 AND NULLIF(TRIM(V_parts[6]), '') IS NOT NULL THEN CAST(TRIM(V_parts[6]) AS INTEGER) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 7 THEN NULLIF(TRIM(V_parts[7]), '') ELSE NULL END
					-- Data Transação (DDMMYYYYHH24MI ou DD/MM/YYYY)
					, CASE 
						WHEN array_length(V_parts, 1) >= 7 AND NULLIF(TRIM(V_parts[7]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[7]) ~ '^\d{12}' THEN TO_DATE(SUBSTRING(TRIM(V_parts[7]) FROM 1 FOR 8), 'DDMMYYYY')
								WHEN TRIM(V_parts[7]) ~ '^\d{8}' THEN TO_DATE(TRIM(V_parts[7]), 'DDMMYYYY')
								WHEN TRIM(V_parts[7]) ~ '^\d{2}/\d{2}/\d{4}' THEN TO_DATE(TRIM(V_parts[7]), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Valor Transação (NUMERIC 15,2 - sem zeros à esquerda)
					, CASE 
						WHEN array_length(V_parts, 1) >= 8 AND NULLIF(TRIM(V_parts[8]), '') IS NOT NULL THEN
							CAST(REPLACE(TRIM(V_parts[8]), ',', '.') AS NUMERIC(15,2))
						ELSE NULL 
					  END
					-- Valor Faturado (NUMERIC 15,2 - sem zeros à esquerda)
					, CASE 
						WHEN array_length(V_parts, 1) >= 9 AND NULLIF(TRIM(V_parts[9]), '') IS NOT NULL THEN
							CAST(REPLACE(TRIM(V_parts[9]), ',', '.') AS NUMERIC(15,2))
						ELSE NULL 
					  END
					-- Data Pagamento (YYYY/MM/DD ou DD/MM/YYYY)
					, CASE 
						WHEN array_length(V_parts, 1) >= 10 AND NULLIF(TRIM(V_parts[10]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[10]) ~ '^\d{4}/\d{2}/\d{2}$' THEN TO_DATE(TRIM(V_parts[10]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[10]) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(V_parts[10]), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					, CASE WHEN array_length(V_parts, 1) >= 11 THEN NULLIF(TRIM(V_parts[11]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 12 THEN NULLIF(TRIM(V_parts[12]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 13 THEN NULLIF(TRIM(V_parts[13]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 14 THEN NULLIF(TRIM(V_parts[14]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 15 THEN NULLIF(TRIM(V_parts[15]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 16 THEN NULLIF(TRIM(V_parts[16]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 17 THEN NULLIF(TRIM(V_parts[17]), '') ELSE NULL END
					-- Data Cotação (opcional)
					, CASE 
						WHEN array_length(V_parts, 1) >= 18 AND NULLIF(TRIM(V_parts[18]), '') IS NOT NULL AND TRIM(V_parts[18]) !~ '^\s*/*\s*$' THEN
							CASE 
								WHEN TRIM(V_parts[18]) ~ '^\d{4}/\d{2}/\d{2}$' THEN TO_DATE(TRIM(V_parts[18]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[18]) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(TRIM(V_parts[18]), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Taxa Conversão (NUMERIC)
					, CASE 
						WHEN array_length(V_parts, 1) >= 19 AND NULLIF(TRIM(V_parts[19]), '') IS NOT NULL AND TRIM(V_parts[19]) !~ '^\s*,*\s*$' THEN
							CAST(REPLACE(TRIM(V_parts[19]), ',', '.') AS NUMERIC(15,4))
						ELSE NULL 
					  END
					-- Valor Reais (NUMERIC)
					, CASE 
						WHEN array_length(V_parts, 1) >= 20 AND NULLIF(TRIM(V_parts[20]), '') IS NOT NULL AND TRIM(V_parts[20]) !~ '^\s*,*\s*$' THEN
							CAST(REPLACE(TRIM(V_parts[20]), ',', '.') AS NUMERIC(15,2))
						ELSE NULL 
					  END
					, CASE WHEN array_length(V_parts, 1) >= 29 THEN NULLIF(TRIM(V_parts[29]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 21 THEN NULLIF(TRIM(V_parts[21]), '') ELSE NULL END
				)
				ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

			-- TIPO 9: TRAILER DO ARQUIVO
			ELSIF TRIM(V_parts[1]) = '9' THEN
				INSERT INTO bradesco.cartao_credito_trailer_arquivo (
					id_arquivo
					, id_empresa
					, numero_linha
					, codigo_registro
					, codigo_estabelecimento
					, total_registros_tipo1
					, total_registros_tipo2
					, total_registros_arquivo
					, valor_total_transacoes
				) VALUES (
					p_id_arquivo
					, V_id_empresa
					, V_rec.numero_linha
					, NULLIF(TRIM(V_parts[1]), '')
					, NULLIF(TRIM(V_parts[2]), '')
					, CASE WHEN array_length(V_parts, 1) >= 6 AND NULLIF(TRIM(V_parts[6]), '') IS NOT NULL THEN CAST(TRIM(V_parts[6]) AS BIGINT) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 7 AND NULLIF(TRIM(V_parts[7]), '') IS NOT NULL THEN CAST(TRIM(V_parts[7]) AS BIGINT) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 8 AND NULLIF(TRIM(V_parts[8]), '') IS NOT NULL THEN CAST(TRIM(V_parts[8]) AS BIGINT) ELSE NULL END
					, CASE 
						WHEN array_length(V_parts, 1) >= 10 AND NULLIF(TRIM(V_parts[10]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[10]) LIKE '%,%' THEN CAST(REPLACE(TRIM(V_parts[10]), ',', '.') AS NUMERIC(15,2))
								ELSE CAST(TRIM(V_parts[10]) AS NUMERIC(15,2)) / 100.0
							END
						ELSE NULL 
					  END
				)
				ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;
			END IF;
		END IF;
	END LOOP;
END;
$$;
