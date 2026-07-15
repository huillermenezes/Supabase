DROP FUNCTION IF EXISTS public.f_processar_resposta_webhook_bradesco();

CREATE OR REPLACE FUNCTION public.f_processar_resposta_webhook_bradesco()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_rec RECORD;
BEGIN
	-- Loop pelas respostas HTTP registradas pelo pgnet para os requests pendentes
	FOR V_rec IN
		SELECT 
			hr.id AS request_id
			, hr.status_code
			, hr.content
			, hr.error_msg
		FROM net._http_response hr
		WHERE hr.id IN (
			SELECT DISTINCT request_id_webhook
			FROM public.movimento_cartao_retorno_bradesco
			WHERE enviado_brapoio = FALSE
			  AND request_id_webhook IS NOT NULL
		)
	LOOP
		-- Se a resposta for sucesso (HTTP 200 ou 204)
		IF V_rec.status_code IN (200, 204) THEN
			UPDATE public.movimento_cartao_retorno_bradesco
			SET enviado_brapoio = TRUE
			  , status_webhook = V_rec.status_code
			  , retorno_webhook = COALESCE(V_rec.content, 'Enviado com sucesso.')
			WHERE request_id_webhook = V_rec.request_id;
		ELSE
			-- Se a requisição falhou, registra o status/erro e limpa o request_id_webhook para permitir a retransmissão
			UPDATE public.movimento_cartao_retorno_bradesco
			SET status_webhook = V_rec.status_code
			  , retorno_webhook = COALESCE(V_rec.content, V_rec.error_msg, 'Erro desconhecido no envio do webhook.')
			  , request_id_webhook = NULL
			WHERE request_id_webhook = V_rec.request_id;
		END IF;

		-- Atualiza a tabela de log com a resposta e status HTTP recebido
		UPDATE public.log_envio_webhook
		SET status_http = V_rec.status_code
		  , resposta_retorno = COALESCE(V_rec.content, V_rec.error_msg, 'Sem resposta')
		  , sucesso = (V_rec.status_code IN (200, 204))
		  , data_resposta = NOW()
		WHERE request_id_webhook = V_rec.request_id;
	END LOOP;
END;
$$;
