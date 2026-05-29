DROP FUNCTION IF EXISTS public.f_storage_object_get_response_http() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_get_response_http()
RETURNS VOID
LANGUAGE plpgsql
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
			r.id AS request_id
			, CASE
				WHEN r.status_code < 300 AND NOT r.timed_out AND r.error_msg IS NULL THEN TRUE
				ELSE FALSE
			  END AS downloaded_file
			, rtrim(elem.linha, E'\r') AS linha
			, elem.idx
		FROM net._http_response r
		CROSS JOIN LATERAL unnest(string_to_array(r.body, E'\n')) WITH ORDINALITY AS elem(linha, idx)
		WHERE rtrim(elem.linha, E'\r') != '' AND elem.linha IS NOT NULL
	),
	-- sub_response: Enumera as linhas de forma independente para cada arquivo (1..N)
	sub_response AS (
		SELECT 
			request_id
			, downloaded_file
			, row_number() OVER (PARTITION BY request_id ORDER BY idx) AS num_linha
			, linha
		FROM raw_lines
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
	)
	INSERT INTO public.registro_arquivo (
		id_arquivo, nome_arquivo, numero_linha, linha_arquivo
	)
	SELECT 
		sso.id_arquivo
		, sso.nome_arquivo
		, sr.num_linha
		, sr.linha
	FROM sub_storage_objects sso
	INNER JOIN sub_response sr ON sr.request_id = sso.request_id
	WHERE sr.downloaded_file = TRUE
	  AND NOT EXISTS (
		  SELECT 1 
		  FROM public.registro_arquivo ra
		  WHERE ra.id_arquivo = sso.id_arquivo
		    AND ra.numero_linha = sr.num_linha
	  )
	ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;

	-- 3. Movimentação física dos arquivos no Storage (processamento/ ou erro/)
	FOR VRecord IN
		SELECT 
			o.name AS caminho_origem
			, storage.filename(o.name) AS nome_arquivo
			, CASE
				WHEN r.status_code < 300 AND NOT r.timed_out AND r.error_msg IS NULL THEN TRUE
				ELSE FALSE
			  END AS downloaded_file
		FROM storage.objects o
		INNER JOIN net._http_response r ON r.id = CAST(o.metadata ->> 'request_id' AS BIGINT)
		WHERE o.bucket_id = 'hetzner_files'
		  AND SPLIT_PART(o.name, '/', 1) = 'input'
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT) IS NOT NULL
		  AND CAST(NULLIF(TRIM(o.metadata ->> 'request_id'), '') AS BIGINT) IS NOT NULL
	LOOP
		IF VRecord.downloaded_file = TRUE THEN
			PERFORM net.http_post(
				url := VVariavelGenerica.url_move
				, headers := jsonb_build_object(
					'Authorization', 'Bearer ' || VVariavelGenerica.auth_key
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'srcKey', VRecord.caminho_origem
					, 'destKey', 'processamento/' || VRecord.nome_arquivo
				)
			);
		ELSE
			PERFORM net.http_post(
				url := VVariavelGenerica.url_move
				, headers := jsonb_build_object(
					'Authorization', 'Bearer ' || VVariavelGenerica.auth_key
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'srcKey', VRecord.caminho_origem
					, 'destKey', 'erro/' || VRecord.nome_arquivo
				)
			);
		END IF;
	END LOOP;
END;
$$;
