DROP FUNCTION IF EXISTS public.f_storage_object_mover_backup() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_object_mover_backup()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_url_move TEXT;
	V_auth_key TEXT;
BEGIN
	-- 1. Obtém as credenciais do Storage no cofre
	SELECT 
		REPLACE(
			(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
			, '/object/authenticated/', '/object/move'
		) AS url_move
		, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO V_url_move, V_auth_key;

	IF V_url_move IS NULL OR V_auth_key IS NULL THEN
		RETURN;
	END IF;
	-- 2. Dispara as chamadas HTTP de movimentação no Storage em lote diretamente da subquery
	PERFORM net.http_post(
		url := V_url_move
		, headers := jsonb_build_object(
			'apikey', TRIM(BOTH E' \r\n\t' FROM V_auth_key)
			, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM V_auth_key))
			, 'Content-Type', 'application/json'
		)
		, body := jsonb_build_object(
			'bucketId', 'hetzner_files'
			, 'sourceKey', sub.caminho_origem
			, 'destinationKey', CONCAT('backup/', sub.nome_arquivo)
		)
	)
	FROM (
		SELECT 
			o.name AS caminho_origem,
			storage.filename(o.name) AS nome_arquivo
		FROM storage.objects o
		INNER JOIN public.registro_arquivo ra_h 
			ON ra_h.id_arquivo = CAST(NULLIF(TRIM(o.metadata ->> 'id'), '') AS BIGINT)
			AND ra_h.numero_linha = 1
		INNER JOIN public.trailer_arquivo ta 
			ON ta.id_arquivo = ra_h.id_arquivo
		WHERE o.bucket_id = 'hetzner_files'
		  AND o.name LIKE 'processamento/%'
		ORDER BY o.created_at ASC
		LIMIT 300
	) sub;
END;
$$;
