DROP TABLE IF EXISTS public.registro_arquivo CASCADE;
DROP TABLE IF EXISTS public.storage_objects_download CASCADE;
DROP TABLE IF EXISTS public.header_arquivo CASCADE;
DROP TABLE IF EXISTS public.movimento_arquivo CASCADE;
DROP TABLE IF EXISTS public.trailer_arquivo CASCADE;
DROP TABLE IF EXISTS public.leiaute_campo_arquivo CASCADE;
DROP TABLE IF EXISTS public.parametro_leiaute_arquivo CASCADE;
DROP TABLE IF EXISTS public.leiaute_arquivo CASCADE;

CREATE TABLE IF NOT EXISTS public.registro_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								BIGINT NOT NULL
	, nome_arquivo								TEXT NOT NULL
	, numero_linha								BIGINT NOT NULL
	, linha_arquivo							TEXT NOT NULL
	, mensagem_erro							TEXT
	, conteudo_jsonb							JSONB
	, CONSTRAINT pk_registro_arquivo PRIMARY KEY (id)
	, CONSTRAINT uq_registro_arquivo UNIQUE (id_arquivo, numero_linha)
);

CREATE TABLE IF NOT EXISTS public.leiaute_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao								TEXT NOT NULL
	, tipo_arquivo								BIGINT NOT NULL -- 1 = Remessa, 2 = Retorno
	, quantidade_caracteres					BIGINT NOT NULL
	, extensao_arquivo						BIGINT NOT NULL -- 1 = .TXT, 2 = .REM, 3 = .RET, 4 = .CSV, 5 = .XML
	, versao_leiaute							TEXT NOT NULL
	, registro_ativo							BOOLEAN DEFAULT TRUE NOT NULL
	, CONSTRAINT pk_leiaute_arquivo PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.leiaute_campo_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao								TEXT NOT NULL
	, descricao									TEXT NULL
	, id_leiaute_arquivo						BIGINT NOT NULL
	, tipo_campo								BIGINT NOT NULL -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial							BIGINT NOT NULL
	, tamanho									BIGINT NOT NULL
	, tipo_valor								BIGINT NOT NULL -- 1 = numerico, 2 = texto
	, preenchimento							BIGINT NULL -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, formato_campo							TEXT NULL
	, campo_identificacao					BOOLEAN NOT NULL DEFAULT FALSE
	, valor_padrao								TEXT NULL
	, expressao_valor							TEXT NULL
	, nome_coluna								TEXT NULL
	, CONSTRAINT pk_leiaute_campo_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_leiaute_campo_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.parametro_leiaute_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_leiaute_arquivo						BIGINT NOT NULL
	, codigo										TEXT NOT NULL
	, id_empresa								BIGINT NULL
	, CONSTRAINT pk_parametro_leiaute_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_parametro_leiaute_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);


CREATE TABLE IF NOT EXISTS public.header_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								BIGINT NOT NULL
	, id_leiaute_arquivo						BIGINT NOT NULL
	, tipo_campo								BIGINT NOT NULL
	, codigo_registro							TEXT
	, codigo_remessa							TEXT
	, literal_transmissao					TEXT
	, codigo_tipo_servico					TEXT
	, literal_servico							TEXT
	, codigo_transmissao						TEXT
	, nome_beneficiario						TEXT
	, codigo_banco								TEXT
	, nome_banco								TEXT
	, data_geracao_arquivo					TEXT
	, reservado_banco_1						TEXT
	, mensagem_1								TEXT
	, mensagem_2								TEXT
	, mensagem_3								TEXT
	, mensagem_4								TEXT
	, mensagem_5								TEXT
	, reservado_banco_2						TEXT
	, reservado_banco_3						TEXT
	, numero_sequencial_arquivo			TEXT
	, numero_sequencial_registro			TEXT
	, CONSTRAINT pk_header_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_header_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

/*
CREATE TABLE IF NOT EXISTS public.header_lote(
	id_header_lote								BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								UUID NOT NULL
	, id_arquivo_layout						BIGINT NOT NULL
	, id_empresa								BIGINT NOT NULL
	, CONSTRAINT pk_header_lote PRIMARY KEY (id_header_lote)
	, CONSTRAINT fk_header_lote_leiaute_arquivo FOREIGN KEY (id_arquivo_layout) REFERENCES public.leiaute_arquivo(id)
);
*/

CREATE TABLE IF NOT EXISTS public.movimento_arquivo (
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								BIGINT NOT NULL
	, id_leiaute_arquivo						BIGINT NOT NULL
	, tipo_campo								BIGINT NOT NULL
	, numero_linha								BIGINT NOT NULL
	-- campos do movimento
	, codigo_registro							TEXT
	, tipo_inscricao_beneficiario			TEXT
	, inscricao_beneficiario				TEXT
	, codigo_agencia_beneficiaria			TEXT
	, conta_movimento_beneficiario		TEXT
	, conta_cobranca_beneficiario			TEXT
	, identificacao_boleto_empresa		TEXT
	, nosso_numero								TEXT
	, data_desconto_2							TEXT
	, reservado_banco_1						TEXT
	, codigo_multa								TEXT
	, percentual_multa						TEXT
	, codigo_moeda								TEXT
	, valor_boleto_outra_unidade			TEXT
	, reservado_banco_2						TEXT
	, data_multa								TEXT
	, tipo_cobranca							TEXT
	, codigo_movimento_remessa				TEXT
	, numero_documento						TEXT
	, data_vencimento_boleto				TEXT
	, valor_nominal_boleto					TEXT
	, numero_banco_cobrador					TEXT
	, codigo_agencia_cobradora				TEXT
	, especie_boleto							TEXT
	, identificacao_boleto_aceite			TEXT
	, data_emissao_boleto					TEXT
	, primeira_instrucao						TEXT
	, segunda_instrucao						TEXT
	, valor_mora_dia							TEXT
	, data_limite_desconto					TEXT
	, valor_desconto							TEXT
	, percentual_iof							TEXT
	, valor_abatimento						TEXT
	, tipo_inscricao_pagador				TEXT
	, inscricao_pagador						TEXT
	, nome_pagador								TEXT
	, endereco_pagador						TEXT
	, bairro_pagador							TEXT
	, cep_pagador								TEXT
	, sufixo_cep_pagador						TEXT
	, cidade_pagador							TEXT
	, uf_pagador								TEXT
	, reservado_banco_3						TEXT
	, reservado_banco_4						TEXT
	, identificador_complemento			TEXT
	, complemento								TEXT
	, reservado_banco_5						TEXT
	, numero_dias_protesto					TEXT
	, reservado_banco_6						TEXT
	, numero_sequencial_registro			TEXT
	, CONSTRAINT pk_movimento_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

/*
CREATE TABLE IF NOT EXISTS public.trailer_lote(
	id_trailer_lote							BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								UUID NOT NULL
	, id_arquivo_layout						BIGINT NOT NULL
	, id_empresa								BIGINT NOT NULL
	, CONSTRAINT pk_trailer_lote PRIMARY KEY (id_trailer_lote)
	, CONSTRAINT fk_trailer_lote_leiaute_arquivo FOREIGN KEY (id_arquivo_layout) REFERENCES public.leiaute_arquivo(id)
);
*/

CREATE TABLE IF NOT EXISTS public.trailer_arquivo(
	id											BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo								BIGINT NOT NULL
	, id_leiaute_arquivo						BIGINT NOT NULL
	, tipo_campo								BIGINT NOT NULL
	, numero_linha								BIGINT NOT NULL
	, codigo_registro							TEXT
	, quantidade_registros					TEXT
	, valor_total_boletos					TEXT
	, reservado_banco							TEXT
	, numero_sequencial_registro			TEXT
	, CONSTRAINT pk_trailer_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_trailer_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);




/*
CREATE SEQUENCE IF NOT EXISTS public.seq_pkey START WITH 1;

WITH sub_storage_object AS (
    SELECT  
        o.id_storage
        , o.metadata || JSONB_BUILD_OBJECT('id', NEXTVAL('seq_pkey')) metadata
    FROM    storage.objects o
    WHERE   ob.bucket_id = 'hetzner_files'
    AND SPLIT_PART(ob.name, '/', 1) = 'input'
    AND NOT NULLIF(TRIM(SPLIT_PART(ob.name, '/', 2)), '') IS NULL
    AND SPLIT_PART(ob.name, '/', 2) NOT IN ('.emptyFolderPlaceholder')
    AND CAST(NULLIF(TRIM(ob.metadata ->> 'id'), '') AS BIGINT) IS NULL
)
UPDATE  storage.objects o
SET metadata = sso.metadata
FROM    sub_storage_object sso
WHERE   sso.id_storage = o.id_storage;

FOR I IN
SELECT 
   LA.id_leiaute_arquivo
   , LCA.TIPO_REGISTRO
FROM LEIAUTE_ARQUIVO la 
   INNER JOIN LEIAUTE_CAMPO_ARQUIVO lca 
      ON lca.id_leiaute_arquivo = la.id
GROUP BY 
   LA.id_leiaute_arquivo
   , LCA.TIPO_REGISTRO
LOOP
   SELECT   JSONB_AGG(JSONB_BUILD_OBJECT(expressao_valor, SUBSTRING(ra.linha_arquivo, lca.posicao_inicial, lca.tamanho)))
   FROM  registro_arquivo
   WHERE ra.conteudo_jsonb ->> lista_id_leiaute_arquivo = I.id_leiaute_arquivo

END LOOP;




		SELECT
			ra.id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, o.name AS caminho_origem
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
			, (
				SELECT	ARRAY_AGG(DISTINCT pla.id_parametro_leiaute_arquivo) lista_id_parametro_leiaute_arquivo
				FROM	parametro_leiaute_arquivo pla
					INNER leiaute_campo_arquivo lca ON (lca.id_leiaute_arquivo = pla.id_leiaute_arquivo)
				WHERE	lca.id_leiaute_arquivo = ANY(CAST(ra.conteudo_jsonb -> 'lista_id_leiaute_arquivo' AS BIGINT[]))
				AND lca.tipo_campo = 1 -- Header Arquivo
				AND lca.campo_identificacao
				AND pla.codigo = SUBSTRING(ra.linha_arquivo, lca.posicao_inicial, lca.tamanho)
			)
		FROM public.registro_arquivo ra
			INNER JOIN storage.objects o ON CAST(o.metadata ->> 'id' AS BIGINT) = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registrado
		AND NOT NULLIF(TRIM(ra.conteudo_jsonb ->> 'lista_id_leiaute_arquivo'), '') IS NULL  -- já tem candidatos de tamanho

		*/