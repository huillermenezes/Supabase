DROP FUNCTION IF EXISTS public.f_storage_objects_download_disparo() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_objects_download_disparo()
RETURNS TABLE (
	id_arquivo UUID,
	nome_arquivo TEXT,
	request_id BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
	VRecord RECORD;
	VVariavelGenerica RECORD;
BEGIN
	-- 1. Obter as credenciais de acesso seguro do cofre do Vault
	SELECT 
		(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage') AS url_storage,
		(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO VVariavelGenerica;

	-- 2. Loop por todos os arquivos 'pendente' (status = 1) na fila
	FOR VRecord IN
		SELECT 
			sod.id_storage_objects_download,
			sod.id_arquivo,
			sod.nome_arquivo,
			CONCAT(VVariavelGenerica.url_storage, 'hetzner_files/', sod.caminho_origem) AS url_arquivo,
			jsonb_build_object('apikey', VVariavelGenerica.auth_key) AS headers
		FROM public.storage_objects_download sod
		WHERE sod.status = 1 -- 1 = 'pendente'
	LOOP
		-- Disparar a chamada HTTP assíncrona (pg_net) e mover status local para 'baixando' (status = 2)
		UPDATE public.storage_objects_download
		SET status = 2, -- 2 = 'baixando'
			request_id_leitura = net.http_get(
				url := VRecord.url_arquivo,
				headers := VRecord.headers
			),
			atualizado_em = now()
		WHERE id_storage_objects_download = VRecord.id_storage_objects_download;
	END LOOP;

	-- 3. Retorna os registros que foram movidos para download
	RETURN QUERY
	SELECT sod.id_arquivo, sod.nome_arquivo, sod.request_id_leitura AS request_id
	FROM public.storage_objects_download sod
	WHERE sod.status = 2
	  AND sod.atualizado_em >= now() - INTERVAL '5 seconds';
END;
$$;
