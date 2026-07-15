DROP TABLE IF EXISTS public.log_envio_webhook;
DROP TABLE IF EXISTS public.registro_arquivo;

-- 1. REGISTRO ARQUIVO
CREATE TABLE IF NOT EXISTS public.registro_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, nome_arquivo															TEXT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, linha_arquivo														TEXT NOT NULL
	, mensagem_erro														TEXT
	, conteudo_jsonb														JSONB
	, CONSTRAINT pk_registro_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_registro_arquivo UNIQUE (id_arquivo, numero_linha)
);

-- 2. LOG ENVIO WEBHOOK
CREATE TABLE IF NOT EXISTS public.log_envio_webhook (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, request_id_webhook													BIGINT
	, url_destino															TEXT NOT NULL
	, conteudo_json															JSONB NOT NULL
	, status_http															INTEGER
	, resposta_retorno														TEXT
	, sucesso																BOOLEAN DEFAULT FALSE NOT NULL
	, data_envio															TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
	, data_resposta															TIMESTAMP WITH TIME ZONE
	, CONSTRAINT pk_log_envio_webhook PRIMARY KEY (id)
);
