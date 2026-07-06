-- =================================================================================
-- SCHEMA BRADESCO: CRIAÇÃO DE TABELAS (CARTÃO DE CRÉDITO E LEIAUTES)
-- =================================================================================

DROP TABLE IF EXISTS bradesco.parametro_leiaute_arquivo;
DROP TABLE IF EXISTS bradesco.leiaute_campo_arquivo;
DROP TABLE IF EXISTS bradesco.leiaute_arquivo;

-- 1. LEIAUTE DO ARQUIVO (ESPECÍFICO DO BRADESCO)
CREATE TABLE IF NOT EXISTS bradesco.leiaute_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao															TEXT NOT NULL
	, tipo_arquivo															BIGINT NOT NULL -- 1 = Remessa, 2 = Retorno
	, quantidade_caracteres												BIGINT NOT NULL
	, extensao_arquivo													BIGINT NOT NULL -- 1 = .TXT, 2 = .REM, 3 = .RET, 4 = .CSV, 5 = .XML
	, versao_leiaute														TEXT NOT NULL
	, registro_ativo														BOOLEAN DEFAULT TRUE NOT NULL
	, CONSTRAINT pk_bradesco_leiaute_arquivo PRIMARY KEY (id)
);

-- 2. LEIAUTE CAMPO ARQUIVO (ESPECÍFICO DO BRADESCO)
CREATE TABLE IF NOT EXISTS bradesco.leiaute_campo_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao															TEXT NOT NULL
	, descricao																TEXT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL -- 1 = Header, 3 = Movimento, 5 = Trailer
	, posicao_inicial														BIGINT NOT NULL
	, tamanho																BIGINT NOT NULL
	, tipo_valor															BIGINT NOT NULL -- 1 = numerico, 2 = texto
	, preenchimento														BIGINT NULL
	, formato_campo														TEXT NULL
	, campo_identificacao												BOOLEAN NOT NULL DEFAULT FALSE
	, valor_padrao															TEXT NULL
	, expressao_valor														TEXT NULL
	, nome_coluna															TEXT NULL
	, grupo																	TEXT DEFAULT 'geral' NOT NULL
	, CONSTRAINT pk_bradesco_leiaute_campo_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_bradesco_leiaute_campo_arquivo_nome_coluna UNIQUE (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna)
);

-- 3. PARÂMETRO LEIAUTE ARQUIVO (ESPECÍFICO DO BRADESCO)
CREATE TABLE IF NOT EXISTS bradesco.parametro_leiaute_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, codigo																	TEXT NOT NULL
	, id_empresa															BIGINT NULL
	, CONSTRAINT pk_bradesco_parametro_leiaute_arquivo PRIMARY KEY (id)
);

