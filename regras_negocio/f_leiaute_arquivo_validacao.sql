DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao() CASCADE;

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao()
RETURNS TABLE (
	id_arquivo			UUID
	, nome_arquivo		TEXT
	, id_leiaute_arquivo	BIGINT
	, mensagem_erro		TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
	-- Validação 1: filtra por tamanho de linha vs quantidade_caracteres do leiaute
	PERFORM public.f_leiaute_arquivo_validacao_tamanho();

	-- Validação 2: filtra pelos campos de valor_padrao constantes do header
	PERFORM public.f_leiaute_arquivo_validacao_constante();

	-- Validação 3: confirma pelo campo_identificacao e localiza o parametro
	PERFORM public.f_leiaute_arquivo_validacao_identificacao();

	-- Retorna o resultado dos arquivos avaliados nesta execução
	RETURN QUERY
	SELECT sod.id_arquivo, sod.nome_arquivo, sod.id_leiaute_arquivo, sod.mensagem_erro
	FROM public.storage_objects_download sod
	WHERE sod.atualizado_em >= now() - INTERVAL '5 seconds';
END;
$$;
