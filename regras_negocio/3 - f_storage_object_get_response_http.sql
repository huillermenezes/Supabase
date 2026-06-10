DROP FUNCTION IF EXISTS public.f_storage_object_get_response_http() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_get_response_http()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VVariavelGenerica RECORD;
	VRecord RECORD;
BEGIN
	-- 1. Obter as credenciais de acesso seguro do cofre do Vault
	SELECT 
		REPLACE(
			(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
			, '/object/authenticated/', '/object/move'
		) AS url_move
		, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO VVariavelGenerica;

	-- 2. Ingestão em lote na tabela registro_arquivo
	-- raw_lines: Extrai as linhas do response.body com ordinalidade para preservar a ordem original
	WITH raw_lines AS (
		SELECT  
			hr.id request_id
			, i.numero_linha
			, TRIM(TRAILING E'\r' FROM i.linha_arquivo) AS linha_arquivo
		FROM  net._http_response hr
			, UNNEST(STRING_TO_ARRAY(hr.content, E'\n')) WITH ORDINALITY AS i (linha_arquivo, numero_linha)
		WHERE	hr.status_code < 300 
		AND	NOT hr.timed_out 
		AND	hr.error_msg IS NULL
		AND NOT NULLIF(TRIM(i.linha_arquivo), '') IS NULL
	),
	-- sub_storage_objects: Traz as chaves associadas e extrai o ID sequencial de controle (metadata.id)
	sub_storage_objects AS (
		SELECT 
			CAST(o.metadata ->> 'id' AS BIGINT) AS id_arquivo
			, CAST(o.metadata ->> 'request_id' AS BIGINT) AS request_id
			, storage.filename(o.name) AS nome_arquivo
		FROM storage.objects o
		WHERE o.bucket_id = 'hetzner_files'
		  AND SPLIT_PART(o.name, '/', 1) = 'input'
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NOT NULL
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'request_id'), '') AS BIGINT) IS NOT NULL
		  AND EXISTS (
			  SELECT 1 
			  FROM net._http_response hr 
			  WHERE hr.id = CAST(o.metadata ->> 'request_id' AS BIGINT)
		  )
		ORDER BY o.created_at ASC
		LIMIT 300
	)
	INSERT INTO public.registro_arquivo (
		id_arquivo, nome_arquivo, numero_linha, linha_arquivo
	)
	SELECT 
		sso.id_arquivo
		, sso.nome_arquivo
		, rl.numero_linha
		, rl.linha_arquivo
	FROM	sub_storage_objects sso
		INNER JOIN raw_lines rl ON (rl.request_id = sso.request_id)
	WHERE NOT EXISTS (
		SELECT	1 
		FROM	public.registro_arquivo ra
		WHERE	ra.id_arquivo = sso.id_arquivo
		AND	ra.numero_linha = rl.numero_linha
	)
	ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

	-- 3. Movimentação física dos arquivos no Storage (processamento/ ou erro/)
	PERFORM net.http_post(
		url := VVariavelGenerica.url_move
		, headers := sub.headers 
		, body := sub.body
	)
	FROM (
		SELECT 
			JSONB_BUILD_OBJECT(
				'apikey', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key)
				, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key))
				, 'Content-Type', 'application/json'
			) AS headers
			, jsonb_build_object(
				'bucketId', o.bucket_id 
				, 'sourceKey', o.name
				, 'destinationKey', 
					CONCAT(
						(CASE WHEN EXISTS(
							SELECT	1 
							FROM	registro_arquivo ra 
							WHERE	ra.id_arquivo = CAST(o.metadata ->> 'id' AS BIGINT)
						) THEN 'processamento/' ELSE 'error/' END)
						, storage.filename(o.name)
					)
			) AS body
		FROM storage.objects o
		WHERE o.bucket_id = 'hetzner_files'
		  AND SPLIT_PART(o.name, '/', 1) = 'input'
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NOT NULL
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'request_id'), '') AS BIGINT) IS NOT NULL
		  AND EXISTS (
			  SELECT 1 
			  FROM net._http_response hr 
			  WHERE hr.id = CAST(o.metadata ->> 'request_id' AS BIGINT)
		  )
	) sub;
END;
$$;
