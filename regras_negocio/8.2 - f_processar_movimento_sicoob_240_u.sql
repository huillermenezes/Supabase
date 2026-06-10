-- =================================================================================
-- FUNÇÃO DE PROCESSAMENTO PERSONALIZADO DE MOVIMENTO: SICOOB 240 RETORNO - SEGMENTO U
-- =================================================================================

CREATE OR REPLACE FUNCTION public.f_processar_movimento_sicoob_240_u(
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
		valor_juros_mora,
		valor_desconto,
		valor_abatimento,
		valor_iof_recolhido,
		valor_total_recebido,
		valor_outras_despesas,
		valor_outros_creditos,
		data_ocorrencia,
		data_efetivacao_credito
	)
	SELECT 
		ra.id_arquivo,
		P_id_empresa,
		P_id_leiaute,
		3, -- Movimento
		ra.numero_linha,
		SUBSTRING(ra.linha_arquivo, 8, 1) AS codigo_registro,
		SUBSTRING(ra.linha_arquivo, 16, 2) AS codigo_movimento_retorno,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 18, 15)), '') AS valor_juros_mora,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 33, 15)), '') AS valor_desconto,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 48, 15)), '') AS valor_abatimento,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 63, 15)), '') AS valor_iof_recolhido,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 78, 15)), '') AS valor_total_recebido,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 108, 15)), '') AS valor_outras_despesas,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 123, 15)), '') AS valor_outros_creditos,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 138, 8)), '') AS data_ocorrencia,
		NULLIF(TRIM(SUBSTRING(ra.linha_arquivo, 146, 8)), '') AS data_efetivacao_credito
	FROM public.registro_arquivo ra
	WHERE ra.id_arquivo = P_id_arquivo
	  AND ra.numero_linha > 1
	  AND ra.mensagem_erro IS NULL
	  AND SUBSTRING(ra.linha_arquivo, 8, 1) = '3'
	  AND SUBSTRING(ra.linha_arquivo, 14, 1) = 'U';
END;
$$;
