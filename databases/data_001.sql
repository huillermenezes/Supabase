-- =================================================================================
-- ESTRUTURA DO BANCO DE DADOS (SCHEMAS)
-- =================================================================================

DROP TABLE IF EXISTS public.leiaute_campo_arquivo;
DROP TABLE IF EXISTS public.parametro_leiaute_arquivo;
DROP TABLE IF EXISTS public.header_arquivo;
DROP TABLE IF EXISTS public.header_lote;
DROP TABLE IF EXISTS public.movimento_arquivo;
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
DROP TABLE IF EXISTS public.movimento_cartao_retorno_bradesco;
DROP TABLE IF EXISTS public.log_envio_webhook;
DROP TABLE IF EXISTS public.trailer_arquivo;
DROP TABLE IF EXISTS public.trailer_lote;
DROP TABLE IF EXISTS public.storage_objects_download;
DROP TABLE IF EXISTS public.registro_arquivo;
DROP TABLE IF EXISTS public.leiaute_arquivo;

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

CREATE TABLE IF NOT EXISTS public.leiaute_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao															TEXT NOT NULL
	, tipo_arquivo															BIGINT NOT NULL -- 1 = Remessa, 2 = Retorno
	, quantidade_caracteres												BIGINT NOT NULL
	, extensao_arquivo													BIGINT NOT NULL -- 1 = .TXT, 2 = .REM, 3 = .RET, 4 = .CSV, 5 = .XML
	, versao_leiaute														TEXT NOT NULL
	, registro_ativo														BOOLEAN DEFAULT TRUE NOT NULL
	, CONSTRAINT pk_leiaute_arquivo PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.leiaute_campo_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, denominacao															TEXT NOT NULL
	, descricao																TEXT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial														BIGINT NOT NULL
	, tamanho																BIGINT NOT NULL
	, tipo_valor															BIGINT NOT NULL -- 1 = numerico, 2 = texto
	, preenchimento														BIGINT NULL -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, formato_campo														TEXT NULL
	, campo_identificacao												BOOLEAN NOT NULL DEFAULT FALSE
	, valor_padrao															TEXT NULL
	, expressao_valor														TEXT NULL
	, nome_coluna															TEXT NULL
	, grupo																	TEXT DEFAULT 'geral' NOT NULL
	, CONSTRAINT pk_leiaute_campo_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_leiaute_campo_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
	, CONSTRAINT uq_leiaute_campo_arquivo_nome_coluna UNIQUE (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna)
);

CREATE TABLE IF NOT EXISTS public.parametro_leiaute_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, codigo																	TEXT NOT NULL
	, id_empresa															BIGINT NULL
	, CONSTRAINT pk_parametro_leiaute_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_parametro_leiaute_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.header_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_remessa														TEXT
	, literal_transmissao												TEXT
	, codigo_tipo_servico												TEXT
	, literal_servico														TEXT
	, codigo_transmissao													TEXT
	, codigo_agencia_beneficiaria										TEXT
	, conta_movimento_beneficiario									TEXT
	, conta_cobranca_beneficiario										TEXT
	, codigo_beneficiario												TEXT
	, sigla_empresa_sistema												TEXT
	, nome_beneficiario													TEXT
	, codigo_banco															TEXT
	, nome_banco															TEXT
	, data_geracao_arquivo												TEXT
	, reservado_banco_1													TEXT
	, mensagem_1															TEXT
	, mensagem_2															TEXT
	, mensagem_3															TEXT
	, mensagem_4															TEXT
	, mensagem_5															TEXT
	, reservado_banco_2													TEXT
	, reservado_banco_3													TEXT
	, numero_sequencial_arquivo										TEXT
	, numero_sequencial_registro										TEXT
	, data_criacao_arquivo												TEXT
	, hora_criacao_arquivo												TEXT
	, data_referencia_movimento										TEXT
	, arquivo_versao														TEXT
	, codigo_estabelecimento											TEXT
	, cnpj_adquirente														TEXT
	, nome_adquirente														TEXT
	, sequencia																TEXT
	, codigo_adquirente													TEXT
	, versao_layout														TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_header_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_header_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.header_lote (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_banco															TEXT
	, lote_servico															TEXT
	, tipo_registro														TEXT
	, tipo_operacao														TEXT
	, tipo_servico															TEXT
	, forma_lancamento													TEXT
	, versao_layout_lote													TEXT
	, cnab_1																	TEXT
	, tipo_inscricao_empresa											TEXT
	, inscricao_empresa													TEXT
	, codigo_convenio														TEXT
	, agencia_mantenedora												TEXT
	, dv_agencia															TEXT
	, conta_corrente														TEXT
	, dv_conta																TEXT
	, dv_agencia_conta													TEXT
	, nome_empresa															TEXT
	, mensagem																TEXT
	, logradouro_empresa													TEXT
	, numero_endereco														TEXT
	, complemento_endereco												TEXT
	, cidade_empresa														TEXT
	, cep_empresa															TEXT
	, complemento_cep_empresa											TEXT
	, uf_empresa															TEXT
	, cnab_2																	TEXT
	, ocorrencias_lote													TEXT
	, CONSTRAINT pk_header_lote PRIMARY KEY (id)
	, CONSTRAINT fk_header_lote_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_arquivo (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, tipo_inscricao_beneficiario										TEXT
	, inscricao_beneficiario											TEXT
	, codigo_agencia_beneficiaria										TEXT
	, conta_movimento_beneficiario									TEXT
	, conta_cobranca_beneficiario										TEXT
	, identificacao_boleto_empresa									TEXT
	, nosso_numero															TEXT
	, data_desconto_2														TEXT
	, reservado_banco_1													TEXT
	, codigo_multa															TEXT
	, percentual_multa													TEXT
	, codigo_moeda															TEXT
	, valor_boleto_outra_unidade										TEXT
	, reservado_banco_2													TEXT
	, data_multa															TEXT
	, tipo_cobranca														TEXT
	, codigo_movimento_remessa											TEXT
	, numero_documento													TEXT
	, data_vencimento_boleto											TEXT
	, valor_nominal_boleto												TEXT
	, numero_banco_cobrador												TEXT
	, codigo_agencia_cobradora											TEXT
	, especie_boleto														TEXT
	, identificacao_boleto_aceite										TEXT
	, data_emissao_boleto												TEXT
	, primeira_instrucao													TEXT
	, segunda_instrucao													TEXT
	, valor_mora_dia														TEXT
	, data_limite_desconto												TEXT
	, valor_desconto														TEXT
	, percentual_iof														TEXT
	, valor_abatimento													TEXT
	, tipo_inscricao_pagador											TEXT
	, inscricao_pagador													TEXT
	, nome_pagador															TEXT
	, endereco_pagador													TEXT
	, bairro_pagador														TEXT
	, cep_pagador															TEXT
	, sufixo_cep_pagador													TEXT
	, cidade_pagador														TEXT
	, uf_pagador															TEXT
	, reservado_banco_3													TEXT
	, reservado_banco_4													TEXT
	, identificador_complemento										TEXT
	, complemento															TEXT
	, reservado_banco_5													TEXT
	, numero_dias_protesto												TEXT
	, reservado_banco_6													TEXT
	, codigo_movimento_retorno											TEXT
	, data_ocorrencia														TEXT
	, nosso_numero_banco													TEXT
	, codigo_original_remessa											TEXT
	, codigo_erro_ocorrencia_1											TEXT
	, codigo_erro_ocorrencia_2											TEXT
	, codigo_erro_ocorrencia_3											TEXT
	, codigo_agencia_recebedora										TEXT
	, valor_tarifa_cobrada												TEXT
	, valor_outras_despesas												TEXT
	, valor_juros_atraso													TEXT
	, valor_iof_recolhido												TEXT
	, valor_total_recebido												TEXT
	, valor_juros_mora													TEXT
	, valor_outros_creditos												TEXT
	, data_efetivacao_credito											TEXT
	, valor_iof_outra_unidade											TEXT
	, valor_debito_credito												TEXT
	, identificacao_lancamento											TEXT
	, sigla_empresa_sistema												TEXT
	, numero_sequencial_arquivo										TEXT
	, numero_sequencial_registro										TEXT
	, CONSTRAINT pk_movimento_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_folha_pagamento_240_segmento_a (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_banco															TEXT
	, lote_servico															TEXT
	, tipo_registro														TEXT
	, sequencial_lote														TEXT
	, codigo_segmento														TEXT
	, tipo_movimento														TEXT
	, instrucao_movimento												TEXT
	, camara_centralizadora												TEXT
	, banco_favorecido													TEXT
	, agencia_favorecido													TEXT
	, dv_agencia_favorecido												TEXT
	, conta_favorecido													TEXT
	, dv_conta_favorecido												TEXT
	, dv_agencia_conta_favorecido										TEXT
	, nome_favorecido														TEXT
	, seu_numero															TEXT
	, data_pagamento														TEXT
	, tipo_moeda															TEXT
	, quantidade_moeda													TEXT
	, valor_pagamento														TEXT
	, nosso_numero															TEXT
	, data_real																TEXT
	, valor_real															TEXT
	, outras_informacoes													TEXT
	, finalidade_doc														TEXT
	, finalidade_ted														TEXT
	, aviso_favorecido													TEXT
	, cnab_1																	TEXT
	, ocorrencias															TEXT
	, CONSTRAINT pk_movimento_folha_pagamento_240_segmento_a PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_folha_pagamento_240_sega_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_folha_pagamento_240_segmento_b (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_banco															TEXT
	, lote_servico															TEXT
	, tipo_registro														TEXT
	, sequencial_lote														TEXT
	, codigo_segmento														TEXT
	, cnab_1																	TEXT
	, tipo_inscricao_favorecido										TEXT
	, inscricao_favorecido												TEXT
	, logradouro_favorecido												TEXT
	, numero_endereco														TEXT
	, complemento_endereco												TEXT
	, bairro_favorecido													TEXT
	, cidade_favorecido													TEXT
	, cep_favorecido														TEXT
	, complemento_cep_favorecido										TEXT
	, uf_favorecido														TEXT
	, data_vencimento														TEXT
	, valor_pagamento														TEXT
	, valor_abatimento													TEXT
	, valor_desconto														TEXT
	, valor_mora															TEXT
	, valor_multa															TEXT
	, codigo_documento_favorecido										TEXT
	, aviso_favorecido													TEXT
	, cnab_2																	TEXT
	, CONSTRAINT pk_movimento_folha_pagamento_240_segmento_b PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_folha_pagamento_240_segb_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_240_segmento_t (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_movimento_retorno											TEXT
	, codigo_agencia_beneficiaria										TEXT
	, conta_movimento_beneficiario									TEXT
	, nosso_numero															TEXT
	, nosso_numero_banco													TEXT
	, numero_documento													TEXT
	, data_vencimento_boleto											TEXT
	, valor_nominal_boleto												TEXT
	, numero_banco_cobrador												TEXT
	, codigo_agencia_cobradora											TEXT
	, nome_pagador															TEXT
	, valor_tarifa_cobrada												TEXT
	, codigo_erro_ocorrencia_1											TEXT
	, CONSTRAINT pk_movimento_240_segmento_t PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_240_segt_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_240_segmento_u (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_movimento_retorno											TEXT
	, valor_juros_mora													TEXT
	, valor_desconto														TEXT
	, valor_abatimento													TEXT
	, valor_iof_recolhido												TEXT
	, valor_total_recebido												TEXT
	, valor_outras_despesas												TEXT
	, valor_outros_creditos												TEXT
	, data_ocorrencia														TEXT
	, data_efetivacao_credito											TEXT
	, CONSTRAINT pk_movimento_240_segmento_u PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_240_segu_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_1 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, codigo_produto														TEXT
	, forma_captura														TEXT
	, numero_rv																TEXT
	, data_rv																TEXT
	, data_pagamento														TEXT
	, banco																	TEXT
	, agencia																TEXT
	, conta_corrente														TEXT
	, numero_cvs_aceitos													TEXT
	, numero_cvs_rejeitados												TEXT
	, valor_bruto															TEXT
	, valor_liquido														TEXT
	, valor_tarifa															TEXT
	, valor_taxa_desconto												TEXT
	, valor_rejeitado														TEXT
	, valor_credito														TEXT
	, valor_encargos														TEXT
	, indicador_tipo_pagamento											TEXT
	, numero_parcela_rv													TEXT
	, quantidade_parcelas_rv											TEXT
	, centralizador_pagamentos											TEXT
	, numero_operacao_antecipacao										TEXT
	, data_vencimento_original											TEXT
	, custo_operacao														TEXT
	, valor_liquido_rv_antecipado										TEXT
	, numero_controle_operacao_cobranca								TEXT
	, valor_liquido_cobranca											TEXT
	, id_compensacao														TEXT
	, moeda																	TEXT
	, identificador_baixa_cobranca									TEXT
	, sinal_transacao														TEXT
	, metadado_1															TEXT
	, conta_pagamento														TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_1 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_1_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_2 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, numero_rv																TEXT
	, nsu_adquirente														TEXT
	, data_transacao														TEXT
	, hora_transacao														TEXT
	, numero_cartao														TEXT
	, valor_transacao														TEXT
	, valor_saque															TEXT
	, valor_taxa_embarque												TEXT
	, numero_parcelas														TEXT
	, numero_parcela_relacionada										TEXT
	, valor_parcela														TEXT
	, data_pagamento														TEXT
	, codigo_autorizacao													TEXT
	, forma_captura														TEXT
	, status_transacao													TEXT
	, codigo_estabelecimento_centralizador							TEXT
	, codigo_terminal														TEXT
	, moeda																	TEXT
	, origem_emissor_cartao												TEXT
	, sinal_transacao														TEXT
	, carteira_digital													TEXT
	, valor_comissao_venda												TEXT
	, identificador_proximo_conteudo									TEXT
	, conteudo_dinamico													TEXT
	, identificador_proximo_conteudo_2								TEXT
	, conteudo_dinamico_2												TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_2 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_2_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_3 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, numero_rv_ajustado													TEXT
	, data_rv																TEXT
	, data_pagamento_rv													TEXT
	, identificador_ajuste												TEXT
	, brancos																TEXT
	, sinal_valor_ajuste													TEXT
	, valor_ajuste															TEXT
	, motivo_ajuste														TEXT
	, data_carta															TEXT
	, numero_cartao														TEXT
	, numero_rv_original													TEXT
	, nsu_adquirente														TEXT
	, data_transacao_original											TEXT
	, indicador_tipo_pagamento											TEXT
	, numero_terminal_original											TEXT
	, data_pagamento_original											TEXT
	, moeda																	TEXT
	, valor_comissao_venda												TEXT
	, identificador_proximo_conteudo									TEXT
	, conteudo_dinamico													TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_3 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_3_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_4 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, data_operacao														TEXT
	, data_credito															TEXT
	, numero_operacao														TEXT
	, valor_bruto_antecipacao											TEXT
	, valor_taxa_antecipacao											TEXT
	, valor_liquido_antecipacao										TEXT
	, taxa_ao_mes_operacao												TEXT
	, codigo_estabelecimento_centralizador							TEXT
	, banco_domicilio_bancario											TEXT
	, agencia_domicilio_bancario										TEXT
	, conta_corrente														TEXT
	, canal_antecipacao													TEXT
	, indicador_tipo_pagamento											TEXT
	, metadado_1															TEXT
	, conta_pagamento														TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_4 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_4_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_5 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, data_operacao														TEXT
	, data_credito_operacao												TEXT
	, numero_operacao														TEXT
	, tipo_operacao														TEXT
	, valor_bruto_total_operacao										TEXT
	, valor_bruto_operacao_adquirencia								TEXT
	, valor_custo_operacao												TEXT
	, valor_liquido_operacao											TEXT
	, taxa_mensal_operacao												TEXT
	, tipo_conta_estabelecimento										TEXT
	, banco_domicilio_bancario											TEXT
	, agencia_domicilio_bancario										TEXT
	, conta_domicilio_bancario											TEXT
	, canal_operacao														TEXT
	, tipo_movimento														TEXT
	, tipo_participante													TEXT
	, id_participante														TEXT
	, tipo_documento_participante										TEXT
	, cnpj_cpf_participante												TEXT
	, tipo_conta_participante											TEXT
	, banco_participante													TEXT
	, agencia_participante												TEXT
	, conta_participante													TEXT
	, codigo_estabelecimento_centralizador							TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_5 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_5_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_adquirente_400_tipo_6 (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, data_operacao														TEXT
	, numero_operacao														TEXT
	, tipo_operacao														TEXT
	, chave_ur																TEXT
	, codigo_produto														TEXT
	, data_vencimento_ur													TEXT
	, valor_bruto_total_ur												TEXT
	, valor_bruto_ur_adquirencia										TEXT
	, valor_custo_ur														TEXT
	, valor_liquido_ur													TEXT
	, tipo_conta_estabelecimento										TEXT
	, banco_domicilio_bancario											TEXT
	, agencia_domicilio_bancario										TEXT
	, conta_domicilio_bancario											TEXT
	, tipo_movimento														TEXT
	, tipo_participante													TEXT
	, id_participante														TEXT
	, tipo_documento_participante										TEXT
	, cnpj_cpf_participante												TEXT
	, tipo_conta_participante											TEXT
	, banco_participante													TEXT
	, agencia_participante												TEXT
	, conta_participante													TEXT
	, codigo_estabelecimento_centralizador							TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_movimento_adquirente_400_tipo_6 PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_adquirente_400_tipo_6_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.movimento_cartao_retorno_bradesco (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, codigo_estabelecimento											TEXT
	, numero_cartao														TEXT
	, numero_parcelas														TEXT
	, numero_parcela_relacionada										TEXT
	, nsu_adquirente														TEXT
	, data_transacao														TEXT
	, valor_transacao														TEXT
	, valor_faturado														TEXT
	, data_pagamento														TEXT
	, moeda																	TEXT
	, cidade_estabelecimento											TEXT
	, nome_estabelecimento												TEXT
	, mcc																		TEXT
	, categoria_mcc														TEXT
	, simbolo_moeda														TEXT
	, sinal_transacao														TEXT
	, data_cotacao															TEXT
	, taxa_conversao														TEXT
	, valor_reais															TEXT
	, pais_transacao														TEXT
	, registro_postagem													TEXT
	, enviado_brapoio														BOOLEAN DEFAULT FALSE NOT NULL
	, request_id_webhook													BIGINT
	, status_webhook														INTEGER
	, retorno_webhook														TEXT
	, CONSTRAINT pk_movimento_cartao_retorno_bradesco PRIMARY KEY (id)
	, CONSTRAINT fk_movimento_cartao_retorno_bradesco_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

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

CREATE TABLE IF NOT EXISTS public.trailer_arquivo(
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_registro														TEXT
	, quantidade_registros												TEXT
	, valor_total_boletos												TEXT
	, reservado_banco														TEXT
	, codigo_remessa														TEXT
	, codigo_tipo_servico												TEXT
	, codigo_banco															TEXT
	, quantidade_registros_simples									TEXT
	, valor_total_boletos_simples										TEXT
	, numero_aviso_cobranca_simples									TEXT
	, quantidade_registros_caucionada								TEXT
	, valor_total_boletos_caucionada									TEXT
	, numero_aviso_cobranca_caucionada								TEXT
	, quantidade_registros_descontada								TEXT
	, valor_total_boletos_descontada									TEXT
	, numero_aviso_cobranca_descontada								TEXT
	, numero_sequencial_arquivo										TEXT
	, reservado_banco_1													TEXT
	, reservado_banco_2													TEXT
	, reservado_banco_3													TEXT
	, reservado_banco_4													TEXT
	, numero_sequencial_registro										TEXT
	, reservado_futuro													TEXT
	, CONSTRAINT pk_trailer_arquivo PRIMARY KEY (id)
	, CONSTRAINT fk_trailer_arquivo_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);

CREATE TABLE IF NOT EXISTS public.trailer_lote (
	id																		BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL
	, id_arquivo															BIGINT NOT NULL
	, id_empresa															BIGINT NOT NULL
	, id_leiaute_arquivo													BIGINT NOT NULL
	, tipo_campo															BIGINT NOT NULL
	, numero_linha															BIGINT NOT NULL
	, codigo_banco															TEXT
	, lote_servico															TEXT
	, tipo_registro														TEXT
	, cnab_1																	TEXT
	, qtd_registros_lote													TEXT
	, valor_total_lote													TEXT
	, qtd_moedas_lote														TEXT
	, numero_aviso_debito												TEXT
	, cnab_2																	TEXT
	, ocorrencias_lote													TEXT
	, CONSTRAINT pk_trailer_lote PRIMARY KEY (id)
	, CONSTRAINT fk_trailer_lote_leiaute_arquivo FOREIGN KEY (id_leiaute_arquivo) REFERENCES public.leiaute_arquivo(id)
);


