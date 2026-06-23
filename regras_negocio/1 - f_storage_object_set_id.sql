DROP FUNCTION IF EXISTS public.f_storage_object_set_id() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_set_id()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
	-- Atualiza em lote todos os objetos na pasta input/ que não possuem a propriedade 'id' em seu metadado
	WITH sub_storage_object AS (
		SELECT  
			o.id
			, jsonb_concat(o.metadata, jsonb_build_object('id', NEXTVAL('public.seq_pkey'))) AS metadata
		FROM    storage.objects o
		WHERE   o.bucket_id = 'hetzner_files'
		  AND SPLIT_PART(o.name, '/', 1) = 'input'
		  AND NOT NULLIF(TRIM(SPLIT_PART(o.name, '/', 2)), '') IS NULL
		  AND SPLIT_PART(o.name, '/', 2) NOT IN ('.emptyFolderPlaceholder')
		  AND o.name NOT ILIKE '%cielo%'
		  AND o.name NOT ILIKE '%getnet%'
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NULL
	)
	UPDATE  storage.objects o
	SET metadata = sso.metadata
	FROM    sub_storage_object sso
	WHERE   sso.id = o.id;
END;
$$;
