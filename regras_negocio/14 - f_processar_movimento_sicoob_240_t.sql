-- =================================================================================
-- FUNÇÃO DE PROCESSAMENTO PERSONALIZADO DE MOVIMENTO: SICOOB 240 RETORNO - SEGMENTO T
-- =================================================================================

CREATE OR REPLACE FUNCTION public.f_processar_movimento_sicoob_240_t(
	P_id_arquivo BIGINT,
	P_id_empresa BIGINT,
	P_id_leiaute BIGINT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
	INSERT INTO public.movimento_arquivo (
		id_arquivo,
		id_empresa,
		id_leiaute_arquivo,
		tipo_campo,
		numero_linha,
		codigo_registro,
		codigo_movimento_retorno,
		codigo_agencia_beneficiaria,
		conta_movimento_beneficiario,
		nosso_numero,
		nosso_numero_banco,
		numero_documento,
		data_vencimento_boleto,
		valor_nominal_boleto,
		numero_banco_cobrador,
		codigo_agencia_cobradora,
		nome_pagador,
		valor_tarifa_cobrada,
		codigo_erro_ocorrencia_1
	)
	SELECT 
		ra.id_arquivo,
		P_id_empresa,
		P_id_leiaute,
		3, -- Movimento
		ra.numero_linha,
		SUBSTRING(ra.linha_arquivo, 8, 1) AS codigo_registro,
		SUBSTRING(ra.linha_arquivo, 16, 2) AS codigo_movimento_retorno,
		TRIM(SUBSTRING(ra.linha_arquivo, 18, 5)) AS codigo_agencia_beneficiaria,
		TRIM(SUBSTRING(ra.linha_arquivo, 24, 12)) AS conta_movimento_beneficiario,
		TRIM(SUBSTRING(ra.linha_arquivo, 38, 20)) AS nosso_numero,
		TRIM(SUBSTRING(ra.linha_arquivo, 38, 20)) AS nosso_numero_banco,
		TRIM(SUBSTRING(ra.linha_arquivo, 59, 15)) AS numero_documento,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 74, 8)), '') AS data_vencimento_boleto,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 82, 15)), '') AS valor_nominal_boleto,
		SUBSTRING(ra.linha_arquivo, 97, 3) AS numero_banco_cobrador,
		TRIM(SUBSTRING(ra.linha_arquivo, 100, 5)) AS codigo_agencia_cobradora,
		TRIM(SUBSTRING(ra.linha_arquivo, 148, 40)) AS nome_pagador,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 199, 15)), '') AS valor_tarifa_cobrada,
		TRIM(SUBSTRING(ra.linha_arquivo, 214, 10)) AS codigo_erro_ocorrencia_1
	FROM public.registro_arquivo ra
	WHERE ra.id_arquivo = P_id_arquivo
	  AND ra.numero_linha > 1
	  AND ra.mensagem_erro IS NULL
	  AND SUBSTRING(ra.linha_arquivo, 8, 1) = '3'
	  AND SUBSTRING(ra.linha_arquivo, 14, 1) = 'T';
END;
$$;
