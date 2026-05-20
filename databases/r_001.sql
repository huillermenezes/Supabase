DROP TABLE IF EXISTS arquivo;
DROP TABLE IF EXISTS registro_arquivo;
DROP TABLE IF EXISTS leiaute_arquivo;
DROP TABLE IF EXISTS leiaute_campo_arquivo;
DROP TABLE IF EXISTS parametro_leiaute_arquivo;

CREATE TABLE IF NOT EXISTS public.arquivo (
	id_arquivo											UUID NOT NULL
	, id_storage											UUID NOT NULL
	, nome_arquivo											TEXT NOT NULL
	, CONSTRAINT pk_arquivo PRIMARY KEY (id_arquivo)
);

CREATE TABLE IF NOT EXISTS public.registro_arquivo (
	id_registro_arquivo								BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo											UUID NOT NULL
	, numero_linha											INTEGER NOT NULL
	, linha_arquivo										TEXT NOT NULL
	, mensagem_erro										TEXT NULL
	, conteudo_json										JSONB NULL
	, CONSTRAINT pk_registro_arquivo PRIMARY KEY (id_registro_arquivo)
	, CONSTRAINT uk_registro_arquivo_numero_linha UNIQUE (id_arquivo, numero_linha)
	, CONSTRAINT fk_registro_arquivo_arquivo FOREIGN KEY (id_arquivo) REFERENCES public.arquivo(id_arquivo)
);

CREATE TABLE IF NOT EXISTS public.leiaute_arquivo (
	id_leiaute_arquivo								BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao											TEXT NOT NULL
	, tipo_arquivo											INTEGER NOT NULL -- 1 = Remessa, 2 = Retorno
	, quantidade_caracteres								INTEGER NOT NULL -- 240, 400, ...
	, extensao_arquivo									INTEGER NOT NULL -- 
	, versao_leiaute										TEXT NOT NULL
	, registro_ativo										BOOLEAN DEFAULT TRUE NOT NULL
	, CONSTRAINT pk_leiaute_arquivo PRIMARY KEY (id_leiaute_arquivo)
	, CONSTRAINT ckc_leiaute_arquivo_tipo_arquivo CHECK (tipo_arquivo IN (1, 2))
	, CONSTRAINT ckc_leiaute_arquivo_extensao_arquivo CHECK (extensao_arquivo IN (1, 2, 3, 4, 5))
);

CREATE TABLE IF NOT EXISTS public.leiaute_campo_arquivo (
	id_leiaute_campo_arquivo						BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao											TEXT NOT NULL
	, descricao												TEXT NOT NULL
	, id_leiaute_arquivo									BIGINT NOT NULL
	, tipo_campo											INTEGER NOT NULL -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial										INTEGER NOT NULL
	, tamanho												INTEGER NOT NULL
	, tipo_valor											INTEGER NOT NULL -- 1 = numerico, 2 = texto
	, preenchimento										INTEGER NOT NULL -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, formato_campo										TEXT
	, campo_identificacao								BOOLEAN NOT NULL DEFAULT FALSE
	, valor_padrao											TEXT
	, expressao_valor										TEXT
	, CONSTRAINT pk_leiaute_campo_arquivo PRIMARY KEY (id_leiaute_campo_arquivo)
	, CONSTRAINT fk_leiaute_campo_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id_leiaute_arquivo)
	, CONSTRAINT ckc_leiaute_campo_arquivo_tipo_campo CHECK (tipo_campo IN (1, 2, 3, 4, 5))
	, CONSTRAINT ckc_leiaute_campo_arquivo_tipo_valor CHECK (tipo_valor IN (1, 2))
	, CONSTRAINT ckc_leiaute_campo_arquivo_preenchimento CHECK (preenchimento IN (1, 2, 3, 4))
);

CREATE TABLE IF NOT EXISTS public.parametro_leiaute_arquivo (
	id_parametro_leiaute_arquivo					BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_leiaute_arquivo									BIGINT NOT NULL
	, parametro_codigo									TEXT NOT NULL
	, id_empresa											BIGINT NULL
	, id_banco												BIGINT NULL
	, id_conta_financeira								BIGINT NULL
	, CONSTRAINT pk_parametro_leiaute_arquivo PRIMARY KEY (id_parametro_leiaute_arquivo)
	, CONSTRAINT fk_parametro_leiaute_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id_leiaute_arquivo)
	, CONSTRAINT fk_parametro_leiaute_arquivo_empresa FOREIGN KEY (id_empresa) REFERENCES public.sis_empresa(id_empresa)
	, CONSTRAINT fk_parametro_leiaute_arquivo_banco FOREIGN KEY (id_banco) REFERENCES public.banco(id_banco)
	, CONSTRAINT fk_parametro_leiaute_arquivo_conta_financeira FOREIGN KEY (id_conta_financeira) REFERENCES public.conta_financeira(id_conta_financeira)
);
