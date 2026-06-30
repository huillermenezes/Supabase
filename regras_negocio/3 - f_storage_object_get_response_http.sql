DROP FUNCTION IF EXISTS public.f_storage_object_get_response_http() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_get_response_http()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VVariavelGenerica RECORD;
BEGIN
	-- 1. Obter as credenciais de acesso seguro do cofre do Vault (tratando barra final de forma robusta)
	SELECT 
		REPLACE(
			REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			)
			, '/object/authenticated', '/object/move'
		) AS url_move
		, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO VVariavelGenerica;

	IF VVariavelGenerica.url_move IS NULL OR VVariavelGenerica.auth_key IS NULL THEN
		RETURN;
	END IF;

	-- 2. Cria tabela temporária com os arquivos candidatos para garantir alinhamento perfeito (evitando furos de limite/ordenação)
	CREATE TEMP TABLE temp_objetos_processar AS
	SELECT 
		CAST(o.metadata ->> 'id' AS BIGINT) AS id_arquivo
		, CAST(o.metadata ->> 'request_id' AS BIGINT) AS request_id
		, storage.filename(o.name) AS nome_arquivo
		, o.name AS caminho_origem
		, o.bucket_id
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  AND SPLIT_PART(o.name, '/', 1) = 'input'
	  AND o.name NOT ILIKE '%cielo%'
	  AND o.name NOT ILIKE '%getnet%'
	  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NOT NULL
	  AND CAST(NULLIF(TRIM(o.metadata ->> 'request_id'), '') AS BIGINT) IS NOT NULL
	  AND EXISTS (
		  SELECT 1 
		  FROM net._http_response hr 
		  WHERE hr.id = CAST(o.metadata ->> 'request_id' AS BIGINT)
	  )
	ORDER BY (SPLIT_PART(o.name, '/', 2) LIKE 'BV%') DESC, o.created_at ASC
	LIMIT 300;

	-- Se não houver registros a processar, finaliza
	IF NOT EXISTS (SELECT 1 FROM temp_objetos_processar) THEN
		DROP TABLE IF EXISTS temp_objetos_processar;
		RETURN;
	END IF;

	-- 3. Ingestão em lote na tabela registro_arquivo
	INSERT INTO public.registro_arquivo (
		id_arquivo, nome_arquivo, numero_linha, linha_arquivo
	)
	SELECT 
		t.id_arquivo
		, t.nome_arquivo
		, rl.numero_linha
		, rl.linha_arquivo
	FROM temp_objetos_processar t
	INNER JOIN (
		SELECT  
			hr.id request_id
			, i.numero_linha
			, TRIM(TRAILING E'\r' FROM i.linha_arquivo) AS linha_arquivo
		FROM  net._http_response hr
			, UNNEST(STRING_TO_ARRAY(hr.content, E'\n')) WITH ORDINALITY AS i (linha_arquivo, numero_linha)
		WHERE	hr.status_code < 300 
		AND	NOT hr.timed_out 
		AND	hr.error_msg IS NULL
		AND	NOT NULLIF(TRIM(i.linha_arquivo), '') IS NULL
	) rl ON (rl.request_id = t.request_id)
	WHERE NOT EXISTS (
		SELECT	1 
		FROM	public.registro_arquivo ra
		WHERE	ra.id_arquivo = t.id_arquivo
		AND	ra.numero_linha = rl.numero_linha
	)
	ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

	-- 4. Movimentação física dos arquivos no Storage (processamento/ ou error/) em lote
	PERFORM net.http_post(
		url := VVariavelGenerica.url_move
		, headers := JSONB_BUILD_OBJECT(
			'apikey', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key)
			, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VVariavelGenerica.auth_key))
			, 'Content-Type', 'application/json'
		)
		, body := jsonb_build_object(
			'bucketId', t.bucket_id 
			, 'sourceKey', t.caminho_origem
			, 'destinationKey', 
				CONCAT(
					(CASE WHEN EXISTS(
						SELECT	1 
						FROM	public.registro_arquivo ra 
						WHERE	ra.id_arquivo = t.id_arquivo
					) THEN 'processamento/' ELSE 'error/' END)
					, t.nome_arquivo
				)
		)
		, timeout_milliseconds := 15000
	)
	FROM temp_objetos_processar t;

	DROP TABLE temp_objetos_processar;
END;
$$;
