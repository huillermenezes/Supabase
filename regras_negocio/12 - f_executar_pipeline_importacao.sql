-- =================================================================================
-- AGENDAMENTO DAS ETAPAS DO PIPELINE COM PG_CRON
-- =================================================================================
-- Execute o bloco abaixo no SQL Editor do seu Supabase para ativar o cron job.

CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 1. Remove os agendamentos anteriores se existirem (para evitar duplicidade)
SELECT cron.unschedule('pipeline_1_set_id');
SELECT cron.unschedule('pipeline_2_set_request_id');
SELECT cron.unschedule('pipeline_3_get_response_http');
SELECT cron.unschedule('pipeline_4_validacao_tamanho');
SELECT cron.unschedule('pipeline_5_set_id_leiaute_arquivo');
SELECT cron.unschedule('pipeline_6_validacao_identificacao');
SELECT cron.unschedule('pipeline_7_processar_header');
SELECT cron.unschedule('pipeline_8_processar_movimento');
SELECT cron.unschedule('pipeline_9_processar_trailer');
SELECT cron.unschedule('pipeline_10_mover_backup');
SELECT cron.unschedule('pipeline_11_reprocessar_erros');
-- Remove legado de nomes antigos
SELECT cron.unschedule('pipeline_10_reprocessar_erros');

-- 2. Agenda cada uma das 9 etapas para rodar a cada hora em intervalos de 5 minutos:

-- Etapa 1: Identifica novos arquivos na pasta input/ (Minuto 0)
SELECT cron.schedule(
	'pipeline_1_set_id',
	'0 * * * *',
	$$ SELECT public.f_storage_object_set_id(); $$
);

-- Etapa 2: Dispara chamadas HTTP assíncronas para ler arquivos (Minuto 5)
SELECT cron.schedule(
	'pipeline_2_set_request_id',
	'5 * * * *',
	$$ SELECT public.f_storage_object_set_request_id(); $$
);

-- Etapa 3: Importa em registro_arquivo e move arquivos no storage (Minuto 10)
SELECT cron.schedule(
	'pipeline_3_get_response_http',
	'10 * * * *',
	$$ SELECT public.f_storage_object_get_response_http(); $$
);

-- Etapa 4: Valida o tamanho das linhas do header (Minuto 15)
SELECT cron.schedule(
	'pipeline_4_validacao_tamanho',
	'15 * * * *',
	$$ SELECT public.f_leiaute_arquivo_validacao_tamanho(); $$
);

-- Etapa 5: Filtra layouts candidatos pelas constantes (Minuto 20)
SELECT cron.schedule(
	'pipeline_5_set_id_leiaute_arquivo',
	'20 * * * *',
	$$ SELECT public.f_registro_arquivo_set_id_leiaute_arquivo(); $$
);

-- Etapa 6: Valida identificação e associa layout definitivo (Minuto 25)
SELECT cron.schedule(
	'pipeline_6_validacao_identificacao',
	'25 * * * *',
	$$ SELECT public.f_leiaute_arquivo_validacao_identificacao(); $$
);

-- Etapa 7: Processa o header e insere em header_arquivo (Minuto 30)
SELECT cron.schedule(
	'pipeline_7_processar_header',
	'30 * * * *',
	$$ SELECT public.f_processar_header_arquivo(); $$
);

-- Etapa 8: Processa os movimentos e insere em movimento_arquivo (Minuto 35)
SELECT cron.schedule(
	'pipeline_8_processar_movimento',
	'35 * * * *',
	$$ SELECT public.f_processar_movimento_arquivo(); $$
);

-- Etapa 9: Processa o trailer e insere em trailer_arquivo (Minuto 40)
SELECT cron.schedule(
	'pipeline_9_processar_trailer',
	'40 * * * *',
	$$ SELECT public.f_processar_trailer_arquivo(); $$
);

-- Etapa 10: Move os arquivos processados com sucesso para a pasta backup/ (Minuto 45)
SELECT cron.schedule(
	'pipeline_10_mover_backup',
	'45 * * * *',
	$$ SELECT public.f_storage_object_mover_backup(); $$
);

-- Etapa 11: Reprocessa arquivos em erro cujos leiautes ou parâmetros foram corrigidos (Minuto 50)
SELECT cron.schedule(
	'pipeline_11_reprocessar_erros',
	'50 * * * *',
	$$ SELECT public.f_reprocessar_arquivos_erro_automatico(); $$
);
