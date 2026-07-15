DROP FUNCTION IF EXISTS public.f_enviar_movimento_cartao_retorno_bradesco_webhook();

CREATE OR REPLACE FUNCTION public.f_enviar_movimento_cartao_retorno_bradesco_webhook()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_id_arquivo BIGINT;
	V_payload JSONB;
	V_request_id BIGINT;
	V_url TEXT := 'https://brapoio-api-pr-144.laboratorioapoio.com/api/supabase/webhook';
BEGIN
	-- Loop pelos arquivos que possuem registros de movimentos de cartão Bradesco pendentes de envio e sem request em andamento
	FOR V_id_arquivo IN
		SELECT DISTINCT id_arquivo
		FROM public.movimento_cartao_retorno_bradesco
		WHERE enviado_brapoio = FALSE
		  AND request_id_webhook IS NULL
		ORDER BY id_arquivo
	LOOP
		-- Agrupa em um array JSON todos os registros pendentes do respectivo arquivo, incluindo evento e ref_projeto no objeto
		SELECT COALESCE(
			JSONB_AGG(
				TO_JSONB(m) || JSONB_BUILD_OBJECT(
					'evento', 'lancamento_cartao_credito',
					'ref_projeto', 'cartao_credito'
				)
			),
			'[]'::jsonb
		)
		INTO V_payload
		FROM public.movimento_cartao_retorno_bradesco m
		WHERE m.id_arquivo = V_id_arquivo
		  AND m.enviado_brapoio = FALSE
		  AND m.request_id_webhook IS NULL;

		-- Se houver registros, realiza o envio via HTTP POST
		IF V_payload IS NOT NULL AND V_payload <> '[]'::jsonb THEN
			-- Executa a requisição assíncrona usando pgnet apontando para o endpoint oficial
			V_request_id := net.http_post(
				url := V_url,
				headers := '{"Content-Type": "application/json"}'::jsonb,
				body := V_payload,
				timeout_milliseconds := 30000
			);

			-- Associa o request_id aos registros para acompanhamento da resposta
			UPDATE public.movimento_cartao_retorno_bradesco
			SET request_id_webhook = V_request_id
			WHERE id_arquivo = V_id_arquivo
			  AND enviado_brapoio = FALSE
			  AND request_id_webhook IS NULL;

			-- Registra o payload e os dados do envio no log de envios
			INSERT INTO public.log_envio_webhook (
				id_arquivo
				, request_id_webhook
				, url_destino
				, conteudo_json
				, data_envio
			) VALUES (
				V_id_arquivo
				, V_request_id
				, V_url
				, V_payload
				, NOW()
			);
		END IF;
	END LOOP;
END;
$$;
