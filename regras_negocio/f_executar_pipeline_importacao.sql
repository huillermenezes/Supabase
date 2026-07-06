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
SELECT cron.unschedule('pipeline_7_processar_header_arquivo');
SELECT cron.unschedule('pipeline_8_processar_header_lote');
SELECT cron.unschedule('pipeline_9_processar_movimento_arquivo');
SELECT cron.unschedule('pipeline_10_processar_trailer_lote');
SELECT cron.unschedule('pipeline_11_processar_trailer_arquivo');
SELECT cron.unschedule('pipeline_12_mover_erro');
SELECT cron.unschedule('pipeline_13_mover_backup');
SELECT cron.unschedule('pipeline_14_enviar_webhook');
SELECT cron.unschedule('pipeline_15_processar_resposta_webhook');
SELECT cron.unschedule('pipeline_16_reprocessar_erros');

-- Remove legado de nomes antigos/desatualizados
SELECT cron.unschedule('pipeline_7_processar_header');
SELECT cron.unschedule('pipeline_8_processar_movimento');
SELECT cron.unschedule('pipeline_9_processar_trailer');
SELECT cron.unschedule('pipeline_10_mover_erro');
SELECT cron.unschedule('pipeline_11_mover_backup');
SELECT cron.unschedule('pipeline_12_reprocessar_erros');
SELECT cron.unschedule('pipeline_13_enviar_webhook');
SELECT cron.unschedule('pipeline_14_processar_resposta_webhook');
SELECT cron.unschedule('pipeline_10_mover_backup');
SELECT cron.unschedule('pipeline_11_reprocessar_erros');
SELECT cron.unschedule('pipeline_10_reprocessar_erros');

-- 2. Agenda cada uma das 16 etapas para rodar a cada hora nos minutos definidos (ordem cronológica de 1 a 16):

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
	'pipeline_7_processar_header_arquivo',
	'30 * * * *',
	$$ SELECT public.f_processar_header_arquivo(); $$
);

-- Etapa 8: Processa o header em lote (Minuto 32)
SELECT cron.schedule(
	'pipeline_8_processar_header_lote',
	'32 * * * *',
	$$ SELECT public.f_processar_header_lote(); $$
);

-- Etapa 9: Processa os movimentos e insere em movimento_arquivo (Minuto 35)
SELECT cron.schedule(
	'pipeline_9_processar_movimento_arquivo',
	'35 * * * *',
	$$ SELECT public.f_processar_movimento_arquivo(); $$
);

-- Etapa 10: Processa o trailer em lote (Minuto 40)
SELECT cron.schedule(
	'pipeline_10_processar_trailer_lote',
	'40 * * * *',
	$$ SELECT public.f_processar_trailer_lote(); $$
);

-- Etapa 11: Processa o trailer e insere em trailer_arquivo (Minuto 42)
SELECT cron.schedule(
	'pipeline_11_processar_trailer_arquivo',
	'42 * * * *',
	$$ SELECT public.f_processar_trailer_arquivo(); $$
);

-- Etapa 12: Move os arquivos com erro de validação/processamento para a pasta error/ (Minuto 45)
SELECT cron.schedule(
	'pipeline_12_mover_erro',
	'45 * * * *',
	$$ SELECT public.f_storage_object_mover_erro(); $$
);

-- Etapa 13: Move os arquivos processados com sucesso para a pasta backup/ (Minuto 50)
SELECT cron.schedule(
	'pipeline_13_mover_backup',
	'50 * * * *',
	$$ SELECT public.f_storage_object_mover_backup(); $$
);

-- Etapa 14: Envia os movimentos do cartão Bradesco via webhook para o BrApoio (Minuto 52)
SELECT cron.schedule(
	'pipeline_14_enviar_webhook',
	'52 * * * *',
	$$ SELECT bradesco.f_enviar_retorno_cartao_webhook(); $$
);

-- Etapa 15: Processa o retorno do webhook do cartão Bradesco (Minuto 54)
SELECT cron.schedule(
	'pipeline_15_processar_resposta_webhook',
	'54 * * * *',
	$$ SELECT bradesco.f_processar_resposta_retorno_cartao_webhook(); $$
);

-- Etapa 16: Reprocessa arquivos em erro cujos leiautes ou parâmetros foram corrigidos (Minuto 55)
SELECT cron.schedule(
	'pipeline_16_reprocessar_erros',
	'55 * * * *',
	$$ SELECT public.f_reprocessar_arquivos_erro_automatico(); $$
);
