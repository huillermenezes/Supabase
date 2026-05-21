DROP FUNCTION IF EXISTS public.f_storage_objects_download_enfileiramento() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_objects_download_enfileiramento()
RETURNS TABLE (
	id_arquivo UUID,
	nome_arquivo TEXT,
	status_fila INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	-- 1. Conta quantos arquivos serão inseridos
	SELECT COUNT(*) AS qtde INTO VRecord
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  -- Apenas arquivos na pasta input/
	  AND SPLIT_PART(o.name, '/', 1) = 'input'
	  AND NOT NULLIF(TRIM(SPLIT_PART(o.name, '/', 2)), '') IS NULL
	  AND SPLIT_PART(o.name, '/', 2) NOT IN ('.emptyFolderPlaceholder')
	  -- Que ainda NÃO existem na tabela de registros processados (registro_arquivo)
	  AND NOT EXISTS (
		  SELECT 1 
		  FROM public.registro_arquivo ra
		  WHERE ra.id_arquivo = o.id
	  )
	  -- Que ainda NÃO foram adicionados na fila de download
	  AND NOT EXISTS (
		  SELECT 1
		  FROM public.storage_objects_download sod
		  WHERE sod.id_arquivo = o.id
	  );

	IF VRecord.qtde > 0 THEN
		RAISE NOTICE '[%] - Enfileirando % novos arquivos em storage_objects_download...', CLOCK_TIMESTAMP(), VRecord.qtde;
	END IF;

	-- 2. Insere os novos arquivos na fila local com status 1 (pendente)
	INSERT INTO public.storage_objects_download (
		id_arquivo, nome_arquivo, caminho_origem, status
	)
	SELECT 
		o.id,
		storage.filename(o.name) AS nome,
		o.name,
		1 -- 1 = 'pendente'
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  AND SPLIT_PART(o.name, '/', 1) = 'input'
	  AND NOT NULLIF(TRIM(SPLIT_PART(o.name, '/', 2)), '') IS NULL
	  AND SPLIT_PART(o.name, '/', 2) NOT IN ('.emptyFolderPlaceholder')
	  AND NOT EXISTS (
		  SELECT 1 
		  FROM public.registro_arquivo ra
		  WHERE ra.id_arquivo = o.id
	  )
	  AND NOT EXISTS (
		  SELECT 1
		  FROM public.storage_objects_download sod
		  WHERE sod.id_arquivo = o.id
	  );

	-- 3. Retorna a lista de pendentes
	RETURN QUERY
	SELECT sod.id_arquivo, sod.nome_arquivo, sod.status AS status_fila
	FROM public.storage_objects_download sod
	WHERE sod.status = 1;
END;
$$;
