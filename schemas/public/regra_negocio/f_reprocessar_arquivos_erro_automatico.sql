DROP FUNCTION IF EXISTS public.f_reprocessar_arquivos_erro_automatico();

CREATE OR REPLACE FUNCTION public.f_reprocessar_arquivos_erro_automatico()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_url_move TEXT;
	V_auth_key TEXT;
BEGIN
	-- 1. Obtém as credenciais do Storage no cofre (tratando barra final de forma robusta)
	SELECT 
		REPLACE(
			REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			)
			, '/object/authenticated', '/object/move'
		) AS url_move
		, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
	INTO V_url_move, V_auth_key;

	IF V_url_move IS NULL OR V_auth_key IS NULL THEN
		RETURN;
	END IF;

	-- 2. Cria tabela temporária com lote de 300 arquivos em erro por execução
	CREATE TEMP TABLE temp_arquivos_reprocessar AS
	SELECT 
		o.name AS caminho_erro,
		storage.filename(o.name) AS nome_arquivo,
		CAST(o.metadata ->> 'id' AS BIGINT) AS id_arquivo,
		o.metadata -> 'id' AS metadata_id
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  AND SPLIT_PART(o.name, '/', 1) = 'error'
	  AND o.name NOT ILIKE '%cielo%'
	  AND o.name NOT ILIKE '%getnet%'
	LIMIT 300;

	-- Se não houver arquivos para reprocessar, aborta
	IF NOT EXISTS (SELECT 1 FROM temp_arquivos_reprocessar) THEN
		DROP TABLE IF EXISTS temp_arquivos_reprocessar;
		RETURN;
	END IF;

	-- 3. Bônus / Correção de Race Condition:
	-- Limpa o metadado (mantendo apenas o ID de controle e removendo mensagens de erro antigas) 
	-- NO OBJETO DE ORIGEM (error/...) antes da movimentação. Assim, a API do Storage copiará o metadado limpo.
	UPDATE storage.objects o
	SET metadata = CASE 
		WHEN t.metadata_id IS NOT NULL THEN jsonb_build_object('id', t.metadata_id)
		ELSE '{}'::jsonb
	END
	FROM temp_arquivos_reprocessar t
	WHERE o.name = t.caminho_erro AND o.bucket_id = 'hetzner_files';

	-- 4. Dispara as chamadas HTTP de movimentação no Storage em lote
	PERFORM net.http_post(
		url := V_url_move
		, headers := jsonb_build_object(
			'apikey', TRIM(BOTH E' \r\n\t' FROM V_auth_key)
			, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM V_auth_key))
			, 'Content-Type', 'application/json'
		)
		, body := jsonb_build_object(
			'bucketId', 'hetzner_files'
			, 'sourceKey', t.caminho_erro
			, 'destinationKey', CONCAT('input/', t.nome_arquivo)
		)
		, timeout_milliseconds := 15000
	)
	FROM temp_arquivos_reprocessar t;

	-- 5. Deleta registros residuais das tabelas de processamento para evitar erros de chaves únicas no reprocessamento
	DELETE FROM public.trailer_arquivo WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.trailer_lote WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_arquivo WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_folha_pagamento_240_segmento_a WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_folha_pagamento_240_segmento_b WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_1 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_2 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_3 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_4 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_5 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_adquirente_400_tipo_6 WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.movimento_cartao_retorno_bradesco WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.header_arquivo WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	DELETE FROM public.header_lote WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL);
	
	DELETE FROM public.registro_arquivo 
	WHERE id_arquivo IN (SELECT id_arquivo FROM temp_arquivos_reprocessar WHERE id_arquivo IS NOT NULL)
	   OR nome_arquivo IN (SELECT nome_arquivo FROM temp_arquivos_reprocessar);

	DROP TABLE temp_arquivos_reprocessar;
END;
$$;
