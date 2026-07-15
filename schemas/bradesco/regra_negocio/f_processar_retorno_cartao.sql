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
	V_raw_parts TEXT[];
	V_id_empresa BIGINT := 1;
	V_id_leiaute BIGINT;

	-- Posições e tamanhos dinâmicos do Header (Tipo 0)
	V_h_cod_registro_pos INT; V_h_cod_registro_tam INT;
	V_h_cod_estab_pos INT; V_h_cod_estab_tam INT;
	V_h_nome_estab_pos INT; V_h_nome_estab_tam INT;
	V_h_data_geracao_pos INT; V_h_data_geracao_tam INT;
	V_h_data_proc_pos INT; V_h_data_proc_tam INT;
	V_h_cnpj_pos INT; V_h_cnpj_tam INT;

	-- Posições e tamanhos dinâmicos do Detalhe Portador (Tipo 1)
	V_p_cod_registro_pos INT; V_p_cod_registro_tam INT;
	V_p_cod_estab_pos INT; V_p_cod_estab_tam INT;
	V_p_num_cartao_pos INT; V_p_num_cartao_tam INT;
	V_p_nome_portador_pos INT; V_p_nome_portador_tam INT;
	V_p_endereco_pos INT; V_p_endereco_tam INT;
	V_p_numero_pos INT; V_p_numero_tam INT;
	V_p_bairro_pos INT; V_p_bairro_tam INT;
	V_p_cidade_pos INT; V_p_cidade_tam INT;
	V_p_uf_pos INT; V_p_uf_tam INT;
	V_p_cep_pos INT; V_p_cep_tam INT;
	V_p_cpf_cnpj_pos INT; V_p_cpf_cnpj_tam INT;

	-- Posições e tamanhos dinâmicos do Movimento (Tipo 2)
	V_m_cod_registro_pos INT; V_m_cod_registro_tam INT;
	V_m_cod_estab_pos INT; V_m_cod_estab_tam INT;
	V_m_num_cartao_pos INT; V_m_num_cartao_tam INT;
	V_m_num_parcelas_pos INT; V_m_num_parcelas_tam INT;
	V_m_parcela_rel_pos INT; V_m_parcela_rel_tam INT;
	V_m_nsu_pos INT; V_m_nsu_tam INT;
	V_m_data_trans_pos INT; V_m_data_trans_tam INT;
	V_m_valor_trans_pos INT; V_m_valor_trans_tam INT;
	V_m_valor_fat_pos INT; V_m_valor_fat_tam INT;
	V_m_data_pag_pos INT; V_m_data_pag_tam INT;
	V_m_moeda_pos INT; V_m_moeda_tam INT;
	V_m_cidade_pos INT; V_m_cidade_tam INT;
	V_m_nome_estab_pos INT; V_m_nome_estab_tam INT;
	V_m_mcc_pos INT; V_m_mcc_tam INT;
	V_m_cat_mcc_pos INT; V_m_cat_mcc_tam INT;
	V_m_simb_moeda_pos INT; V_m_simb_moeda_tam INT;
	V_m_sinal_pos INT; V_m_sinal_tam INT;
	V_m_data_cot_pos INT; V_m_data_cot_tam INT;
	V_m_taxa_conv_pos INT; V_m_taxa_conv_tam INT;
	V_m_valor_reais_pos INT; V_m_valor_reais_tam INT;
	V_m_pais_pos INT; V_m_pais_tam INT;
	V_m_reg_postagem_pos INT; V_m_reg_postagem_tam INT;

	-- Posições e tamanhos dinâmicos do Trailer (Tipo 9)
	V_t_cod_registro_pos INT; V_t_cod_registro_tam INT;
	V_t_cod_estab_pos INT; V_t_cod_estab_tam INT;
	V_t_reg_tipo1_pos INT; V_t_reg_tipo1_tam INT;
	V_t_reg_tipo2_pos INT; V_t_reg_tipo2_tam INT;
	V_t_reg_arq_pos INT; V_t_reg_arq_tam INT;
	V_t_valor_tot_pos INT; V_t_valor_tot_tam INT;
BEGIN
	-- 0. Identificar o Leiaute no banco
	SELECT id INTO V_id_leiaute 
	FROM bradesco.leiaute_arquivo 
	WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2;

	IF V_id_leiaute IS NULL THEN
		RAISE EXCEPTION 'Leiaute retorno_cartao_bradesco não cadastrado na tabela leiaute_arquivo.';
	END IF;


	-- 2. Carregar dinamicamente as posições e tamanhos de cada campo

	-- Header (Tipo 0)
	SELECT posicao_inicial, tamanho INTO V_h_cod_registro_pos, V_h_cod_registro_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'codigo_registro';
	SELECT posicao_inicial, tamanho INTO V_h_cod_estab_pos, V_h_cod_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'codigo_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_h_nome_estab_pos, V_h_nome_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'nome_beneficiario';
	SELECT posicao_inicial, tamanho INTO V_h_data_geracao_pos, V_h_data_geracao_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'data_geracao_arquivo';
	SELECT posicao_inicial, tamanho INTO V_h_data_proc_pos, V_h_data_proc_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'data_referencia_movimento';
	SELECT posicao_inicial, tamanho INTO V_h_cnpj_pos, V_h_cnpj_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 1 AND nome_coluna = 'cnpj_estabelecimento';

	-- Detalhe Portador (Tipo 1)
	SELECT posicao_inicial, tamanho INTO V_p_cod_registro_pos, V_p_cod_registro_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'codigo_registro';
	SELECT posicao_inicial, tamanho INTO V_p_cod_estab_pos, V_p_cod_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'codigo_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_p_num_cartao_pos, V_p_num_cartao_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'numero_cartao';
	SELECT posicao_inicial, tamanho INTO V_p_nome_portador_pos, V_p_nome_portador_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'nome_portador';
	SELECT posicao_inicial, tamanho INTO V_p_endereco_pos, V_p_endereco_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'endereco_portador';
	SELECT posicao_inicial, tamanho INTO V_p_numero_pos, V_p_numero_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'numero_endereco';
	SELECT posicao_inicial, tamanho INTO V_p_bairro_pos, V_p_bairro_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'bairro_portador';
	SELECT posicao_inicial, tamanho INTO V_p_cidade_pos, V_p_cidade_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'cidade_portador';
	SELECT posicao_inicial, tamanho INTO V_p_uf_pos, V_p_uf_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'uf_portador';
	SELECT posicao_inicial, tamanho INTO V_p_cep_pos, V_p_cep_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'cep_portador';
	SELECT posicao_inicial, tamanho INTO V_p_cpf_cnpj_pos, V_p_cpf_cnpj_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 2 AND nome_coluna = 'cpf_cnpj_portador';

	-- Movimento (Tipo 2)
	SELECT posicao_inicial, tamanho INTO V_m_cod_registro_pos, V_m_cod_registro_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'codigo_registro';
	SELECT posicao_inicial, tamanho INTO V_m_cod_estab_pos, V_m_cod_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'codigo_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_m_num_cartao_pos, V_m_num_cartao_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'numero_cartao';
	SELECT posicao_inicial, tamanho INTO V_m_num_parcelas_pos, V_m_num_parcelas_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'numero_parcelas';
	SELECT posicao_inicial, tamanho INTO V_m_parcela_rel_pos, V_m_parcela_rel_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'numero_parcela_relacionada';
	SELECT posicao_inicial, tamanho INTO V_m_nsu_pos, V_m_nsu_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'nsu_adquirente';
	SELECT posicao_inicial, tamanho INTO V_m_data_trans_pos, V_m_data_trans_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'data_transacao';
	SELECT posicao_inicial, tamanho INTO V_m_valor_trans_pos, V_m_valor_trans_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'valor_transacao';
	SELECT posicao_inicial, tamanho INTO V_m_valor_fat_pos, V_m_valor_fat_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'valor_faturado';
	SELECT posicao_inicial, tamanho INTO V_m_data_pag_pos, V_m_data_pag_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'data_pagamento';
	SELECT posicao_inicial, tamanho INTO V_m_moeda_pos, V_m_moeda_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'moeda';
	SELECT posicao_inicial, tamanho INTO V_m_cidade_pos, V_m_cidade_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'cidade_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_m_nome_estab_pos, V_m_nome_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'nome_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_m_mcc_pos, V_m_mcc_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'mcc';
	SELECT posicao_inicial, tamanho INTO V_m_cat_mcc_pos, V_m_cat_mcc_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'categoria_mcc';
	SELECT posicao_inicial, tamanho INTO V_m_simb_moeda_pos, V_m_simb_moeda_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'simbolo_moeda';
	SELECT posicao_inicial, tamanho INTO V_m_sinal_pos, V_m_sinal_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'sinal_transacao';
	SELECT posicao_inicial, tamanho INTO V_m_data_cot_pos, V_m_data_cot_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'data_cotacao';
	SELECT posicao_inicial, tamanho INTO V_m_taxa_conv_pos, V_m_taxa_conv_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'taxa_conversao';
	SELECT posicao_inicial, tamanho INTO V_m_valor_reais_pos, V_m_valor_reais_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'valor_reais';
	SELECT posicao_inicial, tamanho INTO V_m_pais_pos, V_m_pais_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'pais_transacao';
	SELECT posicao_inicial, tamanho INTO V_m_reg_postagem_pos, V_m_reg_postagem_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 3 AND nome_coluna = 'registro_postagem';

	-- Trailer (Tipo 9)
	SELECT posicao_inicial, tamanho INTO V_t_cod_registro_pos, V_t_cod_registro_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'codigo_registro';
	SELECT posicao_inicial, tamanho INTO V_t_cod_estab_pos, V_t_cod_estab_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'codigo_estabelecimento';
	SELECT posicao_inicial, tamanho INTO V_t_reg_tipo1_pos, V_t_reg_tipo1_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'total_registros_tipo1';
	SELECT posicao_inicial, tamanho INTO V_t_reg_tipo2_pos, V_t_reg_tipo2_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'total_registros_tipo2';
	SELECT posicao_inicial, tamanho INTO V_t_reg_arq_pos, V_t_reg_arq_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'total_registros_arquivo';
	SELECT posicao_inicial, tamanho INTO V_t_valor_tot_pos, V_t_valor_tot_tam FROM bradesco.leiaute_campo_arquivo WHERE id_leiaute_arquivo = V_id_leiaute AND tipo_campo = 5 AND nome_coluna = 'valor_total_transacoes';


	-- 3. Identificar o id_empresa associado pelo código de estabelecimento parametrizado
	SELECT COALESCE(
		pla.id_empresa,
		1
	)
	INTO V_id_empresa
	FROM public.registro_arquivo ra
	LEFT JOIN bradesco.parametro_leiaute_arquivo pla 
		ON CAST(pla.codigo AS BIGINT) = CAST(REGEXP_REPLACE(
			CASE 
				WHEN POSITION('|' IN ra.linha_arquivo) > 0 THEN SPLIT_PART(ra.linha_arquivo, '|', 2)
				ELSE SUBSTRING(ra.linha_arquivo, V_h_cod_estab_pos, V_h_cod_estab_tam)
			END, '\D', '', 'g') AS BIGINT)
	WHERE ra.id_arquivo = p_id_arquivo
	  AND ra.numero_linha = 1;

	-- 4. Loop pelas linhas do arquivo armazenadas em registro_arquivo
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
		-- Detecta formato: com delimitadores pipe (|) ou largura fixa
		IF POSITION('|' IN V_rec.linha_arquivo) > 0 THEN
			V_parts := string_to_array(V_rec.linha_arquivo, '|');
		ELSE
			-- Reconstrói V_parts dinamicamente a partir das posições do leiaute_campo_arquivo com base no tipo do registro
			IF SUBSTRING(V_rec.linha_arquivo FROM 1 FOR 1) = '0' THEN
				V_parts := ARRAY[
					SUBSTRING(V_rec.linha_arquivo FROM V_h_cod_registro_pos FOR V_h_cod_registro_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_h_cod_estab_pos FOR V_h_cod_estab_tam),
					'',
					'',
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_h_nome_estab_pos FOR V_h_nome_estab_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_h_data_geracao_pos FOR V_h_data_geracao_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_h_data_proc_pos FOR V_h_data_proc_tam),
					'',
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_h_cnpj_pos FOR V_h_cnpj_tam)
				];
			ELSIF SUBSTRING(V_rec.linha_arquivo FROM 1 FOR 1) = '1' THEN
				V_parts := ARRAY[
					SUBSTRING(V_rec.linha_arquivo FROM V_p_cod_registro_pos FOR V_p_cod_registro_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_cod_estab_pos FOR V_p_cod_estab_tam),
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_p_num_cartao_pos FOR V_p_num_cartao_tam),
					'',
					'',
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_p_nome_portador_pos FOR V_p_nome_portador_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_endereco_pos FOR V_p_endereco_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_numero_pos FOR V_p_numero_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_bairro_pos FOR V_p_bairro_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_cidade_pos FOR V_p_cidade_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_uf_pos FOR V_p_uf_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_p_cep_pos FOR V_p_cep_tam),
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_p_cpf_cnpj_pos FOR V_p_cpf_cnpj_tam)
				];
			ELSIF SUBSTRING(V_rec.linha_arquivo FROM 1 FOR 1) = '2' THEN
				V_parts := ARRAY[
					SUBSTRING(V_rec.linha_arquivo FROM V_m_cod_registro_pos FOR V_m_cod_registro_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_cod_estab_pos FOR V_m_cod_estab_tam),
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_m_num_cartao_pos FOR V_m_num_cartao_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_num_parcelas_pos FOR V_m_num_parcelas_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_parcela_rel_pos FOR V_m_parcela_rel_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_nsu_pos FOR V_m_nsu_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_data_trans_pos FOR V_m_data_trans_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_valor_trans_pos FOR V_m_valor_trans_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_valor_fat_pos FOR V_m_valor_fat_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_data_pag_pos FOR V_m_data_pag_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_moeda_pos FOR V_m_moeda_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_cidade_pos FOR V_m_cidade_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_nome_estab_pos FOR V_m_nome_estab_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_mcc_pos FOR V_m_mcc_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_cat_mcc_pos FOR V_m_cat_mcc_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_simb_moeda_pos FOR V_m_simb_moeda_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_sinal_pos FOR V_m_sinal_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_data_cot_pos FOR V_m_data_cot_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_taxa_conv_pos FOR V_m_taxa_conv_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_valor_reais_pos FOR V_m_valor_reais_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_pais_pos FOR V_m_pais_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_m_reg_postagem_pos FOR V_m_reg_postagem_tam)
				];
			ELSIF SUBSTRING(V_rec.linha_arquivo FROM 1 FOR 1) = '9' THEN
				V_parts := ARRAY[
					SUBSTRING(V_rec.linha_arquivo FROM V_t_cod_registro_pos FOR V_t_cod_registro_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_t_cod_estab_pos FOR V_t_cod_estab_tam),
					'',
					'',
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_t_reg_tipo1_pos FOR V_t_reg_tipo1_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_t_reg_tipo2_pos FOR V_t_reg_tipo2_tam),
					SUBSTRING(V_rec.linha_arquivo FROM V_t_reg_arq_pos FOR V_t_reg_arq_tam),
					'',
					SUBSTRING(V_rec.linha_arquivo FROM V_t_valor_tot_pos FOR V_t_valor_tot_tam)
				];
			ELSE
				V_parts := ARRAY[SUBSTRING(V_rec.linha_arquivo FROM 1 FOR 1)];
			END IF;
		END IF;

		IF COALESCE(array_length(V_parts, 1), 0) > 0 THEN
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
					-- Converte Data Geração (DD/MM/YYYY, DDMMYYYY, YYYY/MM/DD ou YYYYMMDD)
					, CASE 
						WHEN array_length(V_parts, 1) >= 7 AND NULLIF(TRIM(V_parts[7]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[7]) ~ '^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}$' THEN TO_DATE(TRIM(V_parts[7]), 'DD/MM/YYYY')
								WHEN TRIM(V_parts[7]) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(TRIM(V_parts[7]), 'DDMMYYYY')
								WHEN TRIM(V_parts[7]) ~ '^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[7]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[7]) ~ '^\d{4}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[7]), 'YYYYMMDD')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Converte Data Processamento (DD/MM/YYYY, DDMMYYYY, YYYY/MM/DD ou YYYYMMDD)
					, CASE 
						WHEN array_length(V_parts, 1) >= 8 AND NULLIF(TRIM(V_parts[8]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[8]) ~ '^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}$' THEN TO_DATE(TRIM(V_parts[8]), 'DD/MM/YYYY')
								WHEN TRIM(V_parts[8]) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(TRIM(V_parts[8]), 'DDMMYYYY')
								WHEN TRIM(V_parts[8]) ~ '^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[8]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[8]) ~ '^\d{4}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[8]), 'YYYYMMDD')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					, CASE WHEN array_length(V_parts, 1) >= 11 THEN REGEXP_REPLACE(NULLIF(TRIM(V_parts[11]), ''), '\D', '', 'g') ELSE NULL END
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
					, CASE WHEN array_length(V_parts, 1) >= 14 THEN REGEXP_REPLACE(NULLIF(TRIM(V_parts[14]), ''), '\D', '', 'g') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 16 THEN REGEXP_REPLACE(NULLIF(TRIM(V_parts[16]), ''), '\D', '', 'g') ELSE NULL END
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
					-- Número de parcelas como Integer (campo 5)
					, CASE WHEN array_length(V_parts, 1) >= 5 AND NULLIF(TRIM(V_parts[5]), '') IS NOT NULL AND TRIM(V_parts[5]) ~ '^\d+$' THEN CAST(TRIM(V_parts[5]) AS INTEGER) ELSE NULL END
					-- Número da parcela relacionada como Integer (campo 6)
					, CASE WHEN array_length(V_parts, 1) >= 6 AND NULLIF(TRIM(V_parts[6]), '') IS NOT NULL AND TRIM(V_parts[6]) ~ '^\d+$' THEN CAST(TRIM(V_parts[6]) AS INTEGER) ELSE NULL END
					-- NSU Adquirente (campo 7)
					, CASE WHEN array_length(V_parts, 1) >= 7 THEN NULLIF(TRIM(V_parts[7]), '') ELSE NULL END
					-- Data Transação (campo 8 - DDMMYYYYHH24MI ou DD/MM/YYYY com validação estrita de dia e mês)
					, CASE 
						WHEN array_length(V_parts, 1) >= 8 AND NULLIF(TRIM(V_parts[8]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[8]) ~ '^\d{12}' AND SUBSTRING(TRIM(V_parts[8]) FROM 1 FOR 8) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(SUBSTRING(TRIM(V_parts[8]) FROM 1 FOR 8), 'DDMMYYYY')
								WHEN TRIM(V_parts[8]) ~ '^\d{8}' AND TRIM(V_parts[8]) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(TRIM(V_parts[8]), 'DDMMYYYY')
								WHEN TRIM(V_parts[8]) ~ '^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}' THEN TO_DATE(SUBSTRING(TRIM(V_parts[8]) FROM 1 FOR 10), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Valor Transação (NUMERIC 15,2 - campo 9)
					, CASE WHEN array_length(V_parts, 1) >= 9 THEN public.f_converter_numerico(V_parts[9], 2) ELSE NULL END
					-- Valor Faturado (NUMERIC 15,2 - campo 10 com escala 3 devido a 3 decimais implícitos)
					, CASE WHEN array_length(V_parts, 1) >= 10 THEN public.f_converter_numerico(V_parts[10], 3) ELSE NULL END
					-- Data Pagamento (campo 11 - YYYY/MM/DD ou DD/MM/YYYY com validação estrita de dia e mês)
					, CASE 
						WHEN array_length(V_parts, 1) >= 11 AND NULLIF(TRIM(V_parts[11]), '') IS NOT NULL THEN
							CASE 
								WHEN TRIM(V_parts[11]) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(TRIM(V_parts[11]), 'DDMMYYYY')
								WHEN TRIM(V_parts[11]) ~ '^\d{4}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[11]), 'YYYYMMDD')
								WHEN TRIM(V_parts[11]) ~ '^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[11]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[11]) ~ '^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}$' THEN TO_DATE(TRIM(V_parts[11]), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					, CASE WHEN array_length(V_parts, 1) >= 12 THEN NULLIF(TRIM(V_parts[12]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 13 THEN NULLIF(TRIM(V_parts[13]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 14 THEN NULLIF(TRIM(V_parts[14]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 15 THEN NULLIF(TRIM(V_parts[15]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 16 THEN NULLIF(TRIM(V_parts[16]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 17 THEN NULLIF(TRIM(V_parts[17]), '') ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 18 THEN NULLIF(TRIM(V_parts[18]), '') ELSE NULL END
					-- Data Cotação (campo 19 - opcional com validação estrita de dia e mês)
					, CASE 
						WHEN array_length(V_parts, 1) >= 19 AND NULLIF(TRIM(V_parts[19]), '') IS NOT NULL AND TRIM(V_parts[19]) !~ '^\s*/*\s*$' THEN
							CASE 
								WHEN TRIM(V_parts[19]) ~ '^(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])\d{4}$' THEN TO_DATE(TRIM(V_parts[19]), 'DDMMYYYY')
								WHEN TRIM(V_parts[19]) ~ '^\d{4}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[19]), 'YYYYMMDD')
								WHEN TRIM(V_parts[19]) ~ '^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12]\d|3[01])$' THEN TO_DATE(TRIM(V_parts[19]), 'YYYY/MM/DD')
								WHEN TRIM(V_parts[19]) ~ '^(0[1-9]|[12]\d|3[01])/(0[1-9]|1[0-2])/\d{4}$' THEN TO_DATE(TRIM(V_parts[19]), 'DD/MM/YYYY')
								ELSE NULL 
							END
						ELSE NULL 
					  END
					-- Taxa Conversão (NUMERIC - campo 20)
					, CASE WHEN array_length(V_parts, 1) >= 20 THEN public.f_converter_numerico(V_parts[20], 2) ELSE NULL END
					-- Valor Reais (NUMERIC - campo 21)
					, CASE WHEN array_length(V_parts, 1) >= 21 THEN public.f_converter_numerico(V_parts[21], 2) ELSE NULL END
					-- Pais Transacao (campo 22)
					, CASE WHEN array_length(V_parts, 1) >= 22 THEN NULLIF(TRIM(V_parts[22]), '') ELSE NULL END
					-- Registro Postagem (campo 23)
					, CASE WHEN array_length(V_parts, 1) >= 23 THEN NULLIF(TRIM(V_parts[23]), '') ELSE NULL END
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
					, CASE WHEN array_length(V_parts, 1) >= 6 THEN CAST(public.f_converter_numerico(V_parts[6], 0) AS BIGINT) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 7 THEN CAST(public.f_converter_numerico(V_parts[7], 0) AS BIGINT) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 8 THEN CAST(public.f_converter_numerico(V_parts[8], 0) AS BIGINT) ELSE NULL END
					, CASE WHEN array_length(V_parts, 1) >= 10 THEN public.f_converter_numerico(V_parts[10], 2) ELSE NULL END
				)
				ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;
			END IF;
		END IF;
	END LOOP;
END;
$$;
