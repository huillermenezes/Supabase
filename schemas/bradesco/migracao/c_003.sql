DROP TABLE IF EXISTS bradesco.cartao_credito_trailer_arquivo;
DROP TABLE IF EXISTS bradesco.cartao_credito_movimento_arquivo;
DROP TABLE IF EXISTS bradesco.cartao_credito_detalhe_portador;
DROP TABLE IF EXISTS bradesco.cartao_credito_header_arquivo;

-- 4. HEADER DO ARQUIVO (TIPO 0)
CREATE TABLE IF NOT EXISTS bradesco.cartao_credito_header_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento_centralizador							TEXT
	, nome_estabelecimento												TEXT
	, data_geracao															DATE
	, data_processamento													DATE
	, cnpj_estabelecimento												TEXT
	, CONSTRAINT pk_bradesco_cartao_credito_header_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_bradesco_cartao_credito_header_arquivo UNIQUE (id_arquivo, numero_linha)
);

-- 5. DETALHE DO PORTADOR / CARTÃO (TIPO 1)
CREATE TABLE IF NOT EXISTS bradesco.cartao_credito_detalhe_portador (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, numero_cartao														TEXT
	, nome_portador														TEXT
	, endereco_portador													TEXT
	, numero_endereco														TEXT
	, bairro_portador														TEXT
	, cidade_portador														TEXT
	, uf_portador															TEXT
	, cep_portador															TEXT
	, cpf_cnpj_portador													TEXT
	, CONSTRAINT pk_bradesco_cartao_credito_detalhe_portador PRIMARY KEY (id)
	, CONSTRAINT uq_bradesco_cartao_credito_detalhe_portador UNIQUE (id_arquivo, numero_linha)
);

-- 6. MOVIMENTO DO ARQUIVO / TRANSAÇÕES (TIPO 2)
CREATE TABLE IF NOT EXISTS bradesco.cartao_credito_movimento_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, numero_cartao														TEXT
	, numero_parcelas														INTEGER
	, numero_parcela_relacionada										INTEGER
	, nsu_adquirente														TEXT
	, data_transacao														DATE
	, valor_transacao														NUMERIC(15,2)
	, valor_faturado														NUMERIC(15,2)
	, data_pagamento														DATE
	, moeda																	TEXT
	, cidade_estabelecimento											TEXT
	, nome_estabelecimento												TEXT
	, mcc																		TEXT
	, categoria_mcc														TEXT
	, simbolo_moeda														TEXT
	, sinal_transacao														TEXT
	, data_cotacao															DATE
	, taxa_conversao														NUMERIC(15,4)
	, valor_reais															NUMERIC(15,2)
	, pais_transacao														TEXT
	, registro_postagem													TEXT
	, enviado_brapoio														BOOLEAN DEFAULT FALSE NOT NULL
	, request_id_webhook													BIGINT
	, status_webhook														INTEGER
	, retorno_webhook														TEXT
	, data_criacao															TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
	, CONSTRAINT pk_bradesco_cartao_credito_movimento_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_bradesco_cartao_credito_movimento_arquivo UNIQUE (id_arquivo, numero_linha)
);

-- 7. TRAILER DO ARQUIVO (TIPO 9)
CREATE TABLE IF NOT EXISTS bradesco.cartao_credito_trailer_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, total_registros_tipo1												BIGINT
	, total_registros_tipo2												BIGINT
	, total_registros_arquivo											BIGINT
	, valor_total_transacoes											NUMERIC(15,2)
	, CONSTRAINT pk_bradesco_cartao_credito_trailer_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_bradesco_cartao_credito_trailer_arquivo UNIQUE (id_arquivo, numero_linha)
);