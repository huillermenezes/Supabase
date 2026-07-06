-- =================================================================================
-- SCRIPT DE RESET COMPLETO (MOVER PARA 'input/' IGNORANDO CONFLITOS DE DUPLICATAS)
-- =================================================================================

-- 1. DESAGENDAR TODOS OS CRON JOBS DO PG_CRON
DO $$
DECLARE
	r RECORD;
BEGIN
	IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pg_cron') THEN
		FOR r IN SELECT jobid FROM cron.job LOOP
			PERFORM cron.unschedule(r.jobid);
		END LOOP;
	END IF;
END $$;


-- 2. MOVER ARQUIVOS PARA 'input/' SOMENTE SE AINDA NÃO EXISTIREM LÁ (EM LOTES DE 1.000)
UPDATE storage.objects 
SET name = 'input/' || storage.filename(name)
WHERE id IN (
	SELECT o.id 
	FROM storage.objects o
	WHERE o.bucket_id = 'hetzner_files'
	  AND (
		o.name LIKE 'processamento/%' 
		OR o.name LIKE 'backup/%' 
		OR o.name LIKE 'error/%' 
		OR o.name LIKE 'output/%'
	  )
	  -- Ignora arquivos que já possuem uma versão com o mesmo nome na pasta input/
	  AND NOT EXISTS (
		SELECT 1 
		FROM storage.objects inp
		WHERE inp.bucket_id = 'hetzner_files'
		  AND inp.name = 'input/' || storage.filename(o.name)
	  )
	LIMIT 1000
);


-- 3. LIMPAR A TABELA REGISTRO_ARQUIVO NO SCHEMA PUBLIC
TRUNCATE TABLE public.registro_arquivo RESTART IDENTITY;


-- 4. REMOVER TABELAS LEGADAS E TEMPORÁRIAS DO SCHEMA PUBLIC
DROP TABLE IF EXISTS public.movimento_cartao_retorno_bradesco;
DROP TABLE IF EXISTS public.movimento_folha_pagamento_240_segmento_a;
DROP TABLE IF EXISTS public.movimento_folha_pagamento_240_segmento_b;
DROP TABLE IF EXISTS public.movimento_240_segmento_t;
DROP TABLE IF EXISTS public.movimento_240_segmento_u;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_1;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_2;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_3;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_4;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_5;
DROP TABLE IF EXISTS public.movimento_adquirente_400_tipo_6;
DROP TABLE IF EXISTS public.header_lote;
DROP TABLE IF EXISTS public.header_arquivo;
DROP TABLE IF EXISTS public.movimento_arquivo;
DROP TABLE IF EXISTS public.trailer_lote;
DROP TABLE IF EXISTS public.trailer_arquivo;
DROP TABLE IF EXISTS public.log_envio_webhook;

-- Apaga tabelas legadas de leiaute do schema public (pois agora estão isoladas em bradesco.*)
DROP TABLE IF EXISTS public.parametro_leiaute_arquivo;
DROP TABLE IF EXISTS public.leiaute_campo_arquivo;
DROP TABLE IF EXISTS public.leiaute_arquivo;
