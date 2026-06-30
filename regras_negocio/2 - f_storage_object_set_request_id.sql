DROP FUNCTION IF EXISTS public.f_storage_object_set_request_id() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_set_request_id()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VVariavelGenerica RECORD;
BEGIN
	-- 1. Obter as credenciais de acesso seguro do cofre do Vault
	SELECT 
		(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage') AS url_storage,
		(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO VVariavelGenerica;

	-- 2. Atualiza em lote disparando as chamadas HTTP assíncronas e gravando o request_id nos metadados
	WITH sub_storage_object AS (
		SELECT  
			o.id
			, jsonb_concat(
				o.metadata,
				jsonb_build_object(
					'request_id',
					net.http_get(
						url := CONCAT(VVariavelGenerica.url_storage, 'hetzner_files/', REPLACE(o.name, ' ', '%20')),
						headers := jsonb_build_object(
							'apikey', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key),
							'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key))
						),
						timeout_milliseconds := 30000
					)
				)
			) AS metadata
		FROM    storage.objects o
		WHERE   o.bucket_id = 'hetzner_files'
		  AND SPLIT_PART(o.name, '/', 1) = 'input'
		  AND NOT NULLIF(TRIM(SPLIT_PART(o.name, '/', 2)), '') IS NULL
		  AND SPLIT_PART(o.name, '/', 2) NOT IN ('.emptyFolderPlaceholder')
		  AND o.name NOT ILIKE '%cielo%'
		  AND o.name NOT ILIKE '%getnet%'
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NOT NULL
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'request_id'), '') AS BIGINT) IS NULL
		ORDER BY (SPLIT_PART(o.name, '/', 2) LIKE 'BV%') DESC, o.created_at ASC
		LIMIT 300
	)
	UPDATE  storage.objects o
	SET metadata = sso.metadata
	FROM    sub_storage_object sso
	WHERE   sso.id = o.id;
END;
$$;
