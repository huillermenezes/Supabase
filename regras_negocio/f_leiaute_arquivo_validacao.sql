DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao() CASCADE;

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao()
RETURNS TABLE (
	id_arquivo			BIGINT
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

	-- Retorna o resultado dos arquivos avaliados nesta execução nos últimos 5 segundos
	RETURN QUERY
	SELECT 
		CAST(o.metadata ->> 'id' AS BIGINT) AS id_arquivo
		, storage.filename(o.name) AS nome_arquivo
		, CAST(o.metadata ->> 'id_leiaute_arquivo' AS BIGINT) AS id_leiaute_arquivo
		, o.metadata ->> 'mensagem_erro' AS mensagem_erro
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  AND SPLIT_PART(o.name, '/', 1) = 'input'
	  -- request_id IS NOT NULL indica que o arquivo foi processado
	  AND o.metadata ->> 'request_id' IS NOT NULL
	  AND o.updated_at >= now() - INTERVAL '5 seconds';
END;
$$;
