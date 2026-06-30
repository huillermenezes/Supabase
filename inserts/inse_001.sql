-- =================================================================================
-- POPULAÇÃO DAS TABELAS (INSERTS)
-- =================================================================================

-- 1. Inserção de Leiautes de Arquivo
INSERT INTO public.leiaute_arquivo (
	denominacao
	, tipo_arquivo
	, quantidade_caracteres
	, extensao_arquivo
	, versao_leiaute
) VALUES
	('folha_pagamento_bradesco_240_posicoes_remessa', 1, 240, 2, 'VERSÃO 8.0 DE 31/08/2004')
	, ('folha_pagamento_bradesco_240_posicoes_retorno', 2, 240, 1, 'VERSÃO 8.0 DE 31/08/2004')
	, ('cobranca_bradesco_400_posicoes_remessa', 1, 400, 2, 'V 2.37 Fev/2026')
	, ('cobranca_bradesco_400_posicoes_retorno', 2, 400, 1, 'V 2.37 Fev/2026')
	, ('cobranca_santander_400_posicoes_remessa', 1, 400, 2, 'V 2.37 Fev/2026')
	, ('cobranca_santander_400_posicoes_retorno', 2, 400, 1, 'V 2.37 Fev/2026')
	, ('cobranca_sicoob_240_posicoes_retorno', 2, 240, 1, 'V 1.0 DDMMAAAA')
	, ('getnet_400_posicoes_retorno', 2, 400, 1, 'CEADM100');

-- 3. Inserção Geral de Campos de Layout
INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
) VALUES
	-- ==============================================
	-- LAYOUT: cobranca_bradesco_400_posicoes_remessa
	-- ==============================================
	-- HEADER
	('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 1, 1, 1, NULL, FALSE, '0', NULL, 'codigo_registro')
	, ('Código da Remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 2, 1, 1, NULL, FALSE, '1', NULL, 'codigo_remessa')
	, ('Literal de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 3, 7, 2, NULL, FALSE, 'REMESSA', NULL, 'literal_transmissao')
	, ('Código do Tipo Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 10, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Literal de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 12, 15, 2, NULL, FALSE, 'COBRANCA       ', NULL, 'literal_servico')
	, ('Código de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 27, 20, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao')
	, ('Nome do Beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 47, 30, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario')
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 77, 3, 1, NULL, FALSE, '237', NULL, 'codigo_banco')
	, ('Nome do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 80, 15, 2, NULL, FALSE, 'BRADESCO', NULL, 'nome_banco')
	, ('Data da Gravação do Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 95, 6, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 101, 8, 1, NULL, FALSE, '00000000', NULL, 'reservado_banco_1')
	, ('Código do Beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 109, 9, 1, NULL, FALSE, NULL, NULL, 'codigo_beneficiario')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 118, 268, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Sigla da empresa no sistema', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 386, 4, 2, NULL, FALSE, NULL, NULL, 'sigla_empresa_sistema')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 390, 2, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Nº sequencial do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Nº sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 395, 6, 1, 3, FALSE, '000001', NULL, 'numero_sequencial_registro')
	-- MOVIMENTO
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 1, 1, 1, NULL, FALSE, '1', NULL, 'codigo_registro')
	, ('Tipo de inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 2, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_beneficiario')
	, ('Inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 4, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_beneficiario')
	, ('Código de agência do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 18, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta movimento do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 22, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta cobrança do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 30, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Identificação do boleto na empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 38, 25, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_empresa')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 63, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 71, 37, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Tipo de cobrança', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 108, 1, 1, NULL, FALSE, NULL, NULL, 'tipo_cobranca')
	, ('Código movimento remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 109, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_movimento_remessa')
	, ('Número do documento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 111, 10, 2, NULL, FALSE, NULL, NULL, 'numero_documento')
	, ('Data de vencimento do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 121, 6, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto')
	, ('Valor nominal do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 127, 13, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto')
	, ('Número do banco cobrador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 140, 3, 1, NULL, FALSE, '237', NULL, 'numero_banco_cobrador')
	, ('Código agência Cobradora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 143, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_cobradora')
	, ('Espécie do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 148, 2, 1, NULL, FALSE, NULL, NULL, 'especie_boleto')
	, ('Identificação boleto aceite / não aceite', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 150, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_aceite')
	, ('Data de emissão do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 151, 6, 1, NULL, FALSE, NULL, NULL, 'data_emissao_boleto')
	, ('Primeira instrução', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 157, 2, 1, NULL, FALSE, NULL, NULL, 'primeira_instrucao')
	, ('Segunda instrução', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 159, 2, 1, NULL, FALSE, NULL, NULL, 'segunda_instrucao')
	, ('Valor de Mora dia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 161, 13, 1, NULL, FALSE, NULL, NULL, 'valor_mora_dia')
	, ('Data Limite para concessão do desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 174, 6, 1, NULL, FALSE, NULL, NULL, 'data_limite_desconto')
	, ('Valor do desconto a ser concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 180, 13, 1, NULL, FALSE, NULL, NULL, 'valor_desconto')
	, ('Percentual do IOF a ser recolhido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 193, 13, 1, NULL, FALSE, NULL, NULL, 'percentual_iof')
	, ('Valor do abatimento ou Valor do segundo desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 206, 13, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento')
	, ('Tipo de inscrição do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 219, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_pagador')
	, ('Inscrição do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 221, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_pagador')
	, ('Nome do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 235, 40, 2, NULL, FALSE, NULL, NULL, 'nome_pagador')
	, ('Endereço do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 275, 40, 2, NULL, FALSE, NULL, NULL, 'endereco_pagador')
	, ('Bairro do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 315, 12, 2, NULL, FALSE, NULL, NULL, 'bairro_pagador')
	, ('Cep do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 327, 5, 1, NULL, FALSE, NULL, NULL, 'cep_pagador')
	, ('Sufixo do Cep do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 332, 3, 1, NULL, FALSE, NULL, NULL, 'sufixo_cep_pagador')
	, ('Cidade do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 335, 15, 2, NULL, FALSE, NULL, NULL, 'cidade_pagador')
	, ('Unidade de Federação do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 350, 2, 2, NULL, FALSE, NULL, NULL, 'uf_pagador')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 352, 30, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 382, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Identificador do complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 383, 1, 2, NULL, FALSE, NULL, NULL, 'identificador_complemento')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 384, 2, 1, NULL, FALSE, NULL, NULL, 'complemento')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 386, 6, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_5')
	, ('Número de dias corridos para Protesto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 392, 2, 1, NULL, FALSE, NULL, NULL, 'numero_dias_protesto')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 394, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_6')
	, ('Número sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- TRAILER
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 1, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro')
	, ('Quantidade de registros', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 2, 6, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros')
	, ('Valor Total dos boletos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 8, 13, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 21, 374, 1, NULL, FALSE, NULL, NULL, 'reservado_banco')
	, ('Número sequencial de registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')

	-- ==============================================
	-- LAYOUT: cobranca_remessa
	-- ==============================================
	-- HEADER
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 1, 1, 1, NULL, FALSE, '0', NULL, 'codigo_registro')
	, ('Código da Remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 2, 1, 1, NULL, FALSE, '1', NULL, 'codigo_remessa')
	, ('Literal de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 3, 7, 2, NULL, FALSE, 'REMESSA', NULL, 'literal_transmissao')
	, ('Código do Tipo Serviço ', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 10, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Literal de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 12, 15, 2, NULL, FALSE, 'COBRANCA       ', NULL, 'literal_servico')
	, ('Código de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 27, 20, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao')
	, ('Nome do Beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 47, 30, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario')
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 77, 3, 1, NULL, FALSE, '033', NULL, 'codigo_banco')
	, ('Nome do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 80, 15, 2, NULL, FALSE, 'BANCO SANTANDER', NULL, 'nome_banco')
	, ('Data da Gravação do Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 95, 6, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo')
	, ('Reservado (uso Banco) ', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 101, 16, 1, NULL, FALSE, '0000000000000000', NULL, 'reservado_banco_1')
	, ('Mensagem 1', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 117, 47, 2, 2, FALSE, NULL, NULL, 'mensagem_1')
	, ('Mensagem 2', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 164, 47, 2, 2, FALSE, NULL, NULL, 'mensagem_2')
	, ('Mensagem 3', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 211, 47, 2, 2, FALSE, NULL, NULL, 'mensagem_3')
	, ('Mensagem 4', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 258, 47, 2, 2, FALSE, NULL, NULL, 'mensagem_4')
	, ('Mensagem 5', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 305, 47, 2, 2, FALSE, NULL, NULL, 'mensagem_5')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 352, 34, 2, 2, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 386, 6, 2, 2, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Nº sequencial do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Nº sequencial do registro no arquivo ', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 395, 6, 1, 3, FALSE, '000001', NULL, 'numero_sequencial_registro')
	-- MOVIMENTO
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 1, 1, 1, NULL, FALSE, '1', NULL, 'codigo_registro')
	, ('Tipo de inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 2, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_beneficiario')
	, ('Inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 4, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_beneficiario')
	, ('Código da agência beneficiária', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 18, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta movimento beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 22, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta cobrança beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 30, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Identificação do boleto na empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 38, 25, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_empresa')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 63, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero')
	, ('Data do desconto 2', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 71, 6, 1, NULL, FALSE, NULL, NULL, 'data_desconto_2')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 77, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Código de Multa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 78, 1, 1, NULL, FALSE, NULL, NULL, 'codigo_multa')
	, ('Percentual de Multa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 79, 4, 1, NULL, FALSE, NULL, NULL, 'percentual_multa')
	, ('Código da Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 83, 2, 1, NULL, FALSE, '00', NULL, 'codigo_moeda')
	, ('Valor do boleto em outra unidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 85, 13, 1, NULL, FALSE, NULL, NULL, 'valor_boleto_outra_unidade')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 98, 4, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Data da Multa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 102, 6, 1, NULL, FALSE, NULL, NULL, 'data_multa')
	, ('Tipo de Cobrança', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 108, 1, 1, NULL, FALSE, NULL, NULL, 'tipo_cobranca')
	, ('Código de movimento remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 109, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_movimento_remessa')
	, ('Nº do documento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 111, 10, 2, NULL, FALSE, NULL, NULL, 'numero_documento')
	, ('Data de vencimento do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 121, 6, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto')
	, ('Valor nominal do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 127, 13, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto')
	, ('Número do banco cobrador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 140, 3, 1, NULL, FALSE, '033', NULL, 'numero_banco_cobrador')
	, ('Código agência Cobradora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 143, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_cobradora')
	, ('Espécie do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 148, 2, 1, NULL, FALSE, NULL, NULL, 'especie_boleto')
	, ('Identificação boleto aceite / não aceite', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 150, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_aceite')
	, ('Data de emissão do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 151, 6, 1, NULL, FALSE, NULL, NULL, 'data_emissao_boleto')
	, ('Primeira instrução', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 157, 2, 1, NULL, FALSE, NULL, NULL, 'primeira_instrucao')
	, ('Segunda instrução', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 159, 2, 1, NULL, FALSE, NULL, NULL, 'segunda_instrucao')
	, ('Valor de Mora dia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 161, 13, 1, NULL, FALSE, NULL, NULL, 'valor_mora_dia')
	, ('Data Limite para concessão do desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 174, 6, 1, NULL, FALSE, NULL, NULL, 'data_limite_desconto')
	, ('Valor do desconto a ser concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 180, 13, 1, NULL, FALSE, NULL, NULL, 'valor_desconto')
	, ('Percentual do IOF a ser recolhido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 193, 13, 1, NULL, FALSE, NULL, NULL, 'percentual_iof')
	, ('Valor do abatimento ou Valor do segundo desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 206, 13, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento')
	, ('Tipo de inscrição do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 219, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_pagador')
	, ('Inscrição do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 221, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_pagador')
	, ('Nome do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 235, 40, 2, NULL, FALSE, NULL, NULL, 'nome_pagador')
	, ('Endereço do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 275, 40, 2, NULL, FALSE, NULL, NULL, 'endereco_pagador')
	, ('Bairro do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 315, 12, 2, NULL, FALSE, NULL, NULL, 'bairro_pagador')
	, ('Cep do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 327, 5, 1, NULL, FALSE, NULL, NULL, 'cep_pagador')
	, ('Sufixo do Cep do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 332, 3, 1, NULL, FALSE, NULL, NULL, 'sufixo_cep_pagador')
	, ('Cidade do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 335, 15, 2, NULL, FALSE, NULL, NULL, 'cidade_pagador')
	, ('Unidade de Federação do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 350, 2, 2, NULL, FALSE, NULL, NULL, 'uf_pagador')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 352, 30, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 382, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Identificador do complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 383, 1, 2, NULL, FALSE, NULL, NULL, 'identificador_complemento')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 384, 2, 1, NULL, FALSE, NULL, NULL, 'complemento')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 386, 6, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_5')
	, ('Número de dias corridos para Protesto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 392, 2, 1, NULL, FALSE, NULL, NULL, 'numero_dias_protesto')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 394, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_6')
	, ('Número sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- TRAILER
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 1, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro')
	, ('Quantidade de registros', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 2, 6, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros')
	, ('Valor Total dos boletos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 8, 13, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 21, 374, 1, NULL, FALSE, NULL, NULL, 'reservado_banco')
	, ('Número sequencial de registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')

	-- ==============================================
	-- LAYOUT: cobranca_retorno
	-- ==============================================
	-- HEADER
	, ('Código do registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 1, 1, NULL, FALSE, '0', NULL, 'codigo_registro')
	, ('Código da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 2, 1, 1, NULL, FALSE, '2', NULL, 'codigo_remessa')
	, ('Literal de transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 3, 7, 2, NULL, FALSE, 'RETORNO', NULL, 'literal_transmissao')
	, ('Código de serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 10, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Literal do serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 12, 15, 2, NULL, FALSE, 'COBRANCA       ', NULL, 'literal_servico')
	, ('Código da agência do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 27, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta Movimento do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 31, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta Cobrança do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 39, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Código de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 27, 20, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao')
	, ('Nome do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 47, 30, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario')
	, ('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 77, 3, 1, NULL, FALSE, NULL, NULL, 'codigo_banco')
	, ('Nome do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 80, 15, 2, NULL, FALSE, 'BRADESCO      ', NULL, 'nome_banco')
	, ('Data da geração do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 95, 6, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 101, 8, 1, NULL, FALSE, '00000000', NULL, 'reservado_banco_1')
	, ('Código do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 109, 9, 1, NULL, FALSE, NULL, NULL, 'codigo_beneficiario')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 118, 268, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Sigla da empresa no sistema', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 386, 4, 2, NULL, FALSE, NULL, NULL, 'sigla_empresa_sistema')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 390, 2, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- MOVIMENTO
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 1, NULL, FALSE, '1', NULL, 'codigo_registro')
	, ('Tipo de inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_beneficiario')
	, ('Inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 4, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_beneficiario')
	, ('Código de agência do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta movimento do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 22, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta cobrança do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 30, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Identificação do boleto na empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 38, 25, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_empresa')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 71, 37, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Tipo de cobrança', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 108, 1, 1, NULL, FALSE, NULL, NULL, 'tipo_cobranca')
	, ('Código movimento retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 109, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_movimento_retorno')
	, ('Data da ocorrência', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 111, 6, 1, NULL, FALSE, NULL, NULL, 'data_ocorrencia')
	, ('Número do documento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 117, 10, 2, NULL, FALSE, NULL, NULL, 'numero_documento')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 127, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero_banco')
	, ('Código Original da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 135, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_original_remessa')
	, ('Código de erro/ocorrência (1º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 137, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_1')
	, ('Código de erro/ocorrência (2º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 140, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_2')
	, ('Código de erro/ocorrência (3º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 143, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_3')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 146, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Data de vencimento do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 147, 6, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto')
	, ('Valor nominal do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 153, 13, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto')
	, ('Número do banco cobrador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 166, 3, 1, NULL, FALSE, NULL, NULL, 'numero_banco_cobrador')
	, ('Código da agência recebedora do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 169, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_recebedora')
	, ('Espécie do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 174, 2, 1, NULL, FALSE, NULL, NULL, 'especie_boleto')
	, ('Valor da tarifa cobrada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 176, 13, 1, NULL, FALSE, NULL, NULL, 'valor_tarifa_cobrada')
	, ('Valor de outras despesas', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 189, 13, 1, NULL, FALSE, NULL, NULL, 'valor_outras_despesas')
	, ('Valor de juros de atraso', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 202, 13, 1, NULL, FALSE, NULL, NULL, 'valor_juros_atraso')
	, ('Valor de IOF recolhido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 215, 13, 1, NULL, FALSE, NULL, NULL, 'valor_iof_recolhido')
	, ('Valor do abatimento concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 228, 13, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento')
	, ('Valor do desconto concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 241, 13, 1, NULL, FALSE, NULL, NULL, 'valor_desconto')
	, ('Valor total recebido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 254, 13, 1, NULL, FALSE, NULL, NULL, 'valor_total_recebido')
	, ('Valor do juros de mora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 267, 13, 1, NULL, FALSE, NULL, NULL, 'valor_juros_mora')
	, ('Valor de outros créditos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 280, 13, 1, NULL, FALSE, NULL, NULL, 'valor_outros_creditos')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 293, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Identificação boleto aceite / não aceite', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 294, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_aceite')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 295, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Data da efetivação crédito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 296, 6, 1, NULL, FALSE, NULL, NULL, 'data_efetivacao_credito')
	, ('Nome do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 302, 36, 2, NULL, FALSE, NULL, NULL, 'nome_pagador')
	, ('Identificador do complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 338, 1, 2, NULL, FALSE, NULL, NULL, 'identificador_complemento')
	, ('Código da moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 339, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_moeda')
	, ('Valor do boleto em outra unidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 341, 13, 1, NULL, FALSE, NULL, NULL, 'valor_boleto_outra_unidade')
	, ('Valor do IOF em outra unidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 354, 13, 1, NULL, FALSE, NULL, NULL, 'valor_iof_outra_unidade')
	, ('Valor do débito ou crédito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 367, 13, 1, NULL, FALSE, NULL, NULL, 'valor_debito_credito')
	, ('Identificação do lançamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 380, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_lancamento')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 381, 3, 1, NULL, FALSE, NULL, NULL, 'reservado_banco_5')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 384, 2, 1, NULL, FALSE, NULL, NULL, 'complemento')
	, ('Sigla da empresa no sistema', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 386, 4, 2, NULL, FALSE, NULL, NULL, 'sigla_empresa_sistema')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 390, 2, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_6')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- TRAILER
	, ('Código de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro')
	, ('Código da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 2, 1, 1, NULL, FALSE, '2', NULL, 'codigo_remessa')
	, ('Código do Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 3, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 5, 3, 1, NULL, FALSE, NULL, NULL, 'codigo_banco')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 8, 10, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Quantidade de registros na cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 18, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_simples')
	, ('Valor total dos boletos na cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 26, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_simples')
	, ('Número do aviso de cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 40, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_simples')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 48, 50, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Quantidade de registros na cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 98, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_caucionada')
	, ('Valor total dos boletos na cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 106, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_caucionada')
	, ('Número do aviso da cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 120, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_caucionada')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 128, 10, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Quantidade de registros na cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 138, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_descontada')
	, ('Valor total dos boletos na cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 146, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_descontada')
	, ('Número do aviso da cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 160, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_descontada')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 168, 224, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_bradesco_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')

	-- ==============================================
	-- LAYOUT: cobranca_santander_400_posicoes_retorno
	-- ==============================================
	-- HEADER
	, ('Código do registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 1, 1, NULL, FALSE, '0', NULL, 'codigo_registro')
	, ('Código da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 2, 1, 1, NULL, FALSE, '2', NULL, 'codigo_remessa')
	, ('Literal de transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 3, 7, 2, NULL, FALSE, 'RETORNO', NULL, 'literal_transmissao')
	, ('Código de serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 10, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Literal do serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 12, 15, 2, NULL, FALSE, 'COBRANCA       ', NULL, 'literal_servico')
	, ('Código da agência do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 27, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta Movimento do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 31, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta Cobrança do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 39, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Código de Transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 27, 20, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao')
	, ('Nome do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 47, 30, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario')
	, ('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 77, 3, 1, NULL, FALSE, NULL, NULL, 'codigo_banco')
	, ('Nome do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 80, 15, 2, NULL, FALSE, 'SANTANDER     ', NULL, 'nome_banco')
	, ('Data da geração do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 95, 6, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 101, 8, 1, NULL, FALSE, '00000000', NULL, 'reservado_banco_1')
	, ('Código do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 109, 9, 1, NULL, FALSE, NULL, NULL, 'codigo_beneficiario')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 118, 268, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Sigla da empresa no sistema', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 386, 4, 2, NULL, FALSE, NULL, NULL, 'sigla_empresa_sistema')
	, ('Reservado (uso banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 390, 2, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- MOVIMENTO
	, ('Código do Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 1, NULL, FALSE, '1', NULL, 'codigo_registro')
	, ('Tipo de inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_beneficiario')
	, ('Inscrição do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 4, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_beneficiario')
	, ('Código de agência do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta movimento do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 22, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta cobrança do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 30, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Identificação do boleto na empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 38, 25, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_empresa')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 71, 37, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Tipo de cobrança', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 108, 1, 1, NULL, FALSE, NULL, NULL, 'tipo_cobranca')
	, ('Código movimento retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 109, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_movimento_retorno')
	, ('Data da ocorrência', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 111, 6, 1, NULL, FALSE, NULL, NULL, 'data_ocorrencia')
	, ('Número do documento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 117, 10, 2, NULL, FALSE, NULL, NULL, 'numero_documento')
	, ('Identificação do boleto no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 127, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero_banco')
	, ('Código Original da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 135, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_original_remessa')
	, ('Código de erro/ocorrência (1º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 137, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_1')
	, ('Código de erro/ocorrência (2º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 140, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_2')
	, ('Código de erro/ocorrência (3º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 143, 3, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_3')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 146, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Data de vencimento do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 147, 6, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto')
	, ('Valor nominal do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 153, 13, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto')
	, ('Número do banco cobrador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 166, 3, 1, NULL, FALSE, NULL, NULL, 'numero_banco_cobrador')
	, ('Código da agência recebedora do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 169, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_recebedora')
	, ('Espécie do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 174, 2, 1, NULL, FALSE, NULL, NULL, 'especie_boleto')
	, ('Valor da tarifa cobrada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 176, 13, 1, NULL, FALSE, NULL, NULL, 'valor_tarifa_cobrada')
	, ('Valor de outras despesas', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 189, 13, 1, NULL, FALSE, NULL, NULL, 'valor_outras_despesas')
	, ('Valor de juros de atraso', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 202, 13, 1, NULL, FALSE, NULL, NULL, 'valor_juros_atraso')
	, ('Valor de IOF recolhido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 215, 13, 1, NULL, FALSE, NULL, NULL, 'valor_iof_recolhido')
	, ('Valor do abatimento concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 228, 13, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento')
	, ('Valor do desconto concedido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 241, 13, 1, NULL, FALSE, NULL, NULL, 'valor_desconto')
	, ('Valor total recebido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 254, 13, 1, NULL, FALSE, NULL, NULL, 'valor_total_recebido')
	, ('Valor do juros de mora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 267, 13, 1, NULL, FALSE, NULL, NULL, 'valor_juros_mora')
	, ('Valor de outros créditos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 280, 13, 1, NULL, FALSE, NULL, NULL, 'valor_outros_creditos')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 293, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Identificação boleto aceite / não aceite', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 294, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_aceite')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 295, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Data da efetivação crédito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 296, 6, 1, NULL, FALSE, NULL, NULL, 'data_efetivacao_credito')
	, ('Nome do Pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 302, 36, 2, NULL, FALSE, NULL, NULL, 'nome_pagador')
	, ('Identificador do complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 338, 1, 2, NULL, FALSE, NULL, NULL, 'identificador_complemento')
	, ('Código da moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 339, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_moeda')
	, ('Valor do boleto em outra unidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 341, 13, 1, NULL, FALSE, NULL, NULL, 'valor_boleto_outra_unidade')
	, ('Valor do IOF em outra unidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 354, 13, 1, NULL, FALSE, NULL, NULL, 'valor_iof_outra_unidade')
	, ('Valor do débito ou crédito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 367, 13, 1, NULL, FALSE, NULL, NULL, 'valor_debito_credito')
	, ('Identificação do lançamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 380, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_lancamento')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 381, 3, 1, NULL, FALSE, NULL, NULL, 'reservado_banco_5')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 384, 2, 1, NULL, FALSE, NULL, NULL, 'complemento')
	, ('Sigla da empresa no sistema', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 386, 4, 2, NULL, FALSE, NULL, NULL, 'sigla_empresa_sistema')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 390, 2, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_6')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro no arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
	-- TRAILER
	, ('Código de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro')
	, ('Código da remessa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 2, 1, 1, NULL, FALSE, '2', NULL, 'codigo_remessa')
	, ('Código do Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 3, 2, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 5, 3, 1, NULL, FALSE, NULL, NULL, 'codigo_banco')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 8, 10, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Quantidade de registros na cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 18, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_simples')
	, ('Valor total dos boletos na cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 26, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_simples')
	, ('Número do aviso de cobrança Simples', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 40, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_simples')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 48, 50, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Quantidade de registros na cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 98, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_caucionada')
	, ('Valor total dos boletos na cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 106, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_caucionada')
	, ('Número do aviso da cobrança caucionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 120, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_caucionada')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 128, 10, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Quantidade de registros na cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 138, 8, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros_descontada')
	, ('Valor total dos boletos na cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 146, 12, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos_descontada')
	, ('Número do aviso da cobrança descontada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 160, 8, 1, NULL, FALSE, NULL, NULL, 'numero_aviso_cobranca_descontada')
	, ('Reservado (uso Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 168, 224, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Número Sequência do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 392, 3, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Número Sequencial do registro do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_santander_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;

	-- ==============================================
	-- LAYOUT: cobranca_sicoob_240_posicoes_retorno
	-- ==============================================
INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
	, grupo
) VALUES
	('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 3, 1, NULL, FALSE, '756', NULL, 'codigo_banco', 'geral')
	, ('Código do registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 8, 1, 1, NULL, FALSE, '0', NULL, 'codigo_registro', 'geral')
	, ('Código da transmissão', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 53, 20, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao', 'geral')
	, ('Nome do beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 73, 30, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario', 'geral')
	, ('Nome do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 103, 30, 2, NULL, FALSE, 'SICOOB                        ', NULL, 'nome_banco', 'geral')
	, ('Código de serviço (Retorno)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 143, 1, 1, NULL, FALSE, '2', NULL, 'codigo_tipo_servico', 'geral')
	, ('Data da geração do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 144, 8, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo', 'geral')
	, ('Número sequencial do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 158, 6, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo', 'geral')

	-- MOVIMENTO - SEGMENTO T
	, ('SegT - Código do registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 8, 1, 1, NULL, FALSE, '3', NULL, 'codigo_registro', 'segt')
	, ('SegT - Código do segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 14, 1, 2, NULL, FALSE, 'T', NULL, 'codigo_segmento', 'segt')
	, ('SegT - Código movimento retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 16, 2, 2, NULL, FALSE, NULL, NULL, 'codigo_movimento_retorno', 'segt')
	, ('SegT - Código da agência beneficiária', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 5, 2, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria', 'segt')
	, ('SegT - Conta movimento beneficiário', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 24, 12, 2, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario', 'segt')
	, ('SegT - Nosso número', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 38, 20, 2, NULL, FALSE, NULL, NULL, 'nosso_numero', 'segt')
	, ('SegT - Nosso número banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 38, 20, 2, NULL, FALSE, NULL, NULL, 'nosso_numero_banco', 'segt')
	, ('SegT - Número do documento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 59, 15, 2, NULL, FALSE, NULL, NULL, 'numero_documento', 'segt')
	, ('SegT - Data de vencimento do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 74, 8, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto', 'segt')
	, ('SegT - Valor nominal do boleto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 82, 15, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto', 'segt')
	, ('SegT - Número do banco cobrador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 97, 3, 1, NULL, FALSE, NULL, NULL, 'numero_banco_cobrador', 'segt')
	, ('SegT - Código agência cobradora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 100, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_cobradora', 'segt')
	, ('SegT - Nome do pagador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 148, 40, 2, NULL, FALSE, NULL, NULL, 'nome_pagador', 'segt')
	, ('SegT - Valor da tarifa cobrada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 199, 15, 1, NULL, FALSE, NULL, NULL, 'valor_tarifa_cobrada', 'segt')
	, ('SegT - Código de erro/ocorrência (1º)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 214, 10, 2, NULL, FALSE, NULL, NULL, 'codigo_erro_ocorrencia_1', 'segt')

	-- MOVIMENTO - SEGMENTO U
	, ('SegU - Código do registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 8, 1, 1, NULL, FALSE, '3', NULL, 'codigo_registro', 'segu')
	, ('SegU - Código do segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 14, 1, 2, NULL, FALSE, 'U', NULL, 'codigo_segmento', 'segu')
	, ('SegU - Código movimento retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 16, 2, 2, NULL, FALSE, NULL, NULL, 'codigo_movimento_retorno', 'segu')
	, ('SegU - Valor juros de mora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 15, 1, NULL, FALSE, NULL, NULL, 'valor_juros_mora', 'segu')
	, ('SegU - Valor do desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 33, 15, 1, NULL, FALSE, NULL, NULL, 'valor_desconto', 'segu')
	, ('SegU - Valor do abatimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 48, 15, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento', 'segu')
	, ('SegU - Valor do IOF recolhido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 15, 1, NULL, FALSE, NULL, NULL, 'valor_iof_recolhido', 'segu')
	, ('SegU - Valor total recebido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 78, 15, 1, NULL, FALSE, NULL, NULL, 'valor_total_recebido', 'segu')
	, ('SegU - Valor de outras despesas', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 108, 15, 1, NULL, FALSE, NULL, NULL, 'valor_outras_despesas', 'segu')
	, ('SegU - Valor de outros créditos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 123, 15, 1, NULL, FALSE, NULL, NULL, 'valor_outros_creditos', 'segu')
	, ('SegU - Data da ocorrência', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 138, 8, 1, NULL, FALSE, NULL, NULL, 'data_ocorrencia', 'segu')
	, ('SegU - Data da efetivação crédito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 146, 8, 1, NULL, FALSE, NULL, NULL, 'data_efetivacao_credito', 'segu')

	-- TRAILER
	, ('Código do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 3, 1, NULL, FALSE, '756', NULL, 'codigo_banco', 'geral')
	, ('Código de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 8, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro', 'geral')
	, ('Quantidade de registros', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'cobranca_sicoob_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 24, 6, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;


	-- ==============================================
	-- LAYOUT: folha_pagamento_bradesco_240_posicoes_remessa
	-- ==============================================
INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
	, grupo
) VALUES
	-- HEADER DE ARQUIVO
	('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 1, 3, 1, 3, TRUE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 4, 4, 1, 3, FALSE, '0000', NULL, 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 8, 1, 1, 3, FALSE, '0', NULL, 'tipo_registro', 'geral')
	, ('CNAB (Reservado Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Tipo de Inscrição da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 18, 1, 1, 3, FALSE, NULL, 'empresa.tipo_inscricao', 'tipo_inscricao_empresa', 'geral')
	, ('Número de Inscrição da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 19, 14, 1, 3, FALSE, NULL, 'empresa.cnpj', 'inscricao_empresa', 'geral')
	, ('Código do Convênio', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 33, 20, 2, 2, FALSE, NULL, 'empresa.convenio', 'codigo_convenio', 'geral')
	, ('Agência Mantenedora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 53, 5, 1, 3, FALSE, NULL, 'conta.agencia', 'agencia_mantenedora', 'geral')
	, ('Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 58, 1, 2, 2, FALSE, NULL, 'conta.agencia_dv', 'dv_agencia', 'geral')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 59, 12, 1, 3, FALSE, NULL, 'conta.numero', 'conta_corrente', 'geral')
	, ('Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 71, 1, 2, 2, FALSE, NULL, 'conta.numero_dv', 'dv_conta', 'geral')
	, ('Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 72, 1, 2, 2, FALSE, NULL, 'conta.dv_ag_conta', 'dv_agencia_conta', 'geral')
	, ('Nome da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 73, 30, 2, 2, FALSE, NULL, 'empresa.nome', 'nome_empresa', 'geral')
	, ('Nome do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 103, 30, 2, 2, FALSE, 'BRADESCO', 'banco.nome', 'nome_banco', 'geral')
	, ('CNAB (Reservado)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 133, 10, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Código Remessa/Retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 143, 1, 1, 3, FALSE, '1', NULL, 'codigo_remessa_retorno', 'geral')
	, ('Data Geração', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 144, 8, 1, 3, FALSE, NULL, 'CURRENT_DATE', 'data_geracao', 'geral')
	, ('Hora Geração', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 152, 6, 1, 3, FALSE, NULL, 'CURRENT_TIME', 'hora_geracao', 'geral')
	, ('Seq (NSA)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 158, 6, 1, 3, FALSE, NULL, 'NSA', 'sequencial_arquivo', 'geral')
	, ('Versão do Layout', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 164, 3, 1, 3, FALSE, '089', NULL, 'versao_layout', 'geral')
	, ('Densidade (BPI)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 167, 5, 1, 3, FALSE, '01600', NULL, 'densidade_gravacao', 'geral')
	, ('Reservado Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 172, 20, 2, 2, FALSE, ' ', NULL, 'reservado_banco', 'geral')
	, ('Reservado Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 192, 20, 2, 2, FALSE, ' ', NULL, 'reservado_empresa', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 1, 212, 29, 2, 2, FALSE, ' ', NULL, 'cnab_3', 'geral')

	-- HEADER DE LOTE
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 8, 1, 1, 3, FALSE, '1', NULL, 'tipo_registro', 'geral')
	, ('Tipo de Operação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 9, 1, 2, 2, FALSE, 'C', NULL, 'tipo_operacao', 'geral')
	, ('Tipo de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 10, 2, 1, 3, FALSE, '30', NULL, 'tipo_servico', 'geral')
	, ('Forma de Lançamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 12, 2, 1, 3, FALSE, '01', NULL, 'forma_lancamento', 'geral')
	, ('Versão do Layout Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 14, 3, 1, 3, FALSE, '040', NULL, 'versao_layout_lote', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 17, 1, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Tipo Inscrição Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 18, 1, 1, 3, FALSE, NULL, 'empresa.tipo_inscricao', 'tipo_inscricao_empresa', 'geral')
	, ('Número Inscrição Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 19, 14, 1, 3, FALSE, NULL, 'empresa.cnpj', 'inscricao_empresa', 'geral')
	, ('Código Convênio BD', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 33, 20, 2, 2, FALSE, NULL, 'empresa.convenio', 'codigo_convenio', 'geral')
	, ('Agência Mantenedora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 53, 5, 1, 3, FALSE, NULL, 'conta.agencia', 'agencia_mantenedora', 'geral')
	, ('Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 58, 1, 2, 2, FALSE, NULL, 'conta.agencia_dv', 'dv_agencia', 'geral')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 59, 12, 1, 3, FALSE, NULL, 'conta.numero', 'conta_corrente', 'geral')
	, ('Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 71, 1, 2, 2, FALSE, NULL, 'conta.numero_dv', 'dv_conta', 'geral')
	, ('Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 72, 1, 2, 2, FALSE, NULL, 'conta.dv_ag_conta', 'dv_agencia_conta', 'geral')
	, ('Nome da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 73, 30, 2, 2, FALSE, NULL, 'empresa.nome', 'nome_empresa', 'geral')
	, ('Mensagem', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 103, 40, 2, 2, FALSE, ' ', NULL, 'mensagem', 'geral')
	, ('Logradouro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 143, 30, 2, 2, FALSE, NULL, 'empresa.logradouro', 'logradouro_empresa', 'geral')
	, ('Número', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 173, 5, 1, 3, FALSE, NULL, 'empresa.numero', 'numero_endereco', 'geral')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 178, 15, 2, 2, FALSE, NULL, 'empresa.complemento', 'complemento_endereco', 'geral')
	, ('Nome da Cidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 193, 20, 2, 2, FALSE, NULL, 'empresa.cidade', 'cidade_empresa', 'geral')
	, ('CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 213, 5, 1, 3, FALSE, NULL, 'empresa.cep', 'cep_empresa', 'geral')
	, ('Complemento CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 218, 3, 2, 2, FALSE, NULL, 'empresa.complemento_cep', 'complemento_cep_empresa', 'geral')
	, ('Sigla do Estado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 221, 2, 2, 2, FALSE, NULL, 'empresa.estado', 'uf_empresa', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 223, 8, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Ocorrências Retorno Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 2, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias_lote', 'geral')

	-- DETALHE - SEGMENTO A
	, ('SegA - Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'sega')
	, ('SegA - Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'sega')
	, ('SegA - Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 8, 1, 1, 3, FALSE, '3', NULL, 'tipo_registro', 'sega')
	, ('SegA - Seq. do Registro no Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 9, 5, 1, 3, FALSE, NULL, 'sequencia_lote', 'sequencial_lote', 'sega')
	, ('SegA - Código do Segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 14, 1, 2, 2, FALSE, 'A', NULL, 'codigo_segmento', 'sega')
	, ('SegA - Tipo de Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 15, 1, 1, 3, FALSE, '0', NULL, 'tipo_movimento', 'sega')
	, ('SegA - Código Instrução Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 16, 2, 1, 3, FALSE, '00', NULL, 'instrucao_movimento', 'sega')
	, ('SegA - Câmara Centralizadora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 18, 3, 1, 3, FALSE, '018', 'pagamento.camara', 'camara_centralizadora', 'sega')
	, ('SegA - Banco do Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 21, 3, 1, 3, FALSE, NULL, 'conta_favorecido.banco', 'banco_favorecido', 'sega')
	, ('SegA - Agência Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 24, 5, 1, 3, FALSE, NULL, 'conta_favorecido.agencia', 'agencia_favorecido', 'sega')
	, ('SegA - Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 29, 1, 2, 2, FALSE, NULL, 'conta_favorecido.agencia_dv', 'dv_agencia_favorecido', 'sega')
	, ('SegA - Conta Corrente Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 30, 12, 1, 3, FALSE, NULL, 'conta_favorecido.numero', 'conta_favorecido', 'sega')
	, ('SegA - Conta Corrente DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 42, 1, 2, 2, FALSE, NULL, 'conta_favorecido.numero_dv', 'dv_conta_favorecido', 'sega')
	, ('SegA - Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 43, 1, 2, 2, FALSE, NULL, 'conta_favorecido.dv_ag_conta', 'dv_agencia_conta_favorecido', 'sega')
	, ('SegA - Nome do Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 44, 30, 2, 2, FALSE, NULL, 'colaborador.nome', 'nome_favorecido', 'sega')
	, ('SegA - Seu Número (Doc Empresa)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 74, 20, 2, 2, FALSE, NULL, 'pagamento.id', 'seu_numero', 'sega')
	, ('SegA - Data de Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 94, 8, 1, 3, FALSE, NULL, 'pagamento.data', 'data_pagamento', 'sega')
	, ('SegA - Tipo da Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 102, 3, 2, 2, FALSE, 'BRL', NULL, 'tipo_moeda', 'sega')
	, ('SegA - Quantidade da Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 105, 15, 1, 3, FALSE, '0', NULL, 'quantidade_moeda', 'sega')
	, ('SegA - Valor Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 120, 15, 1, 3, FALSE, NULL, 'pagamento.valor', 'valor_pagamento', 'sega')
	, ('SegA - Nosso Número (Doc Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 135, 20, 2, 2, FALSE, ' ', 'pagamento.id', 'nosso_numero', 'sega')
	, ('SegA - Data Real (Pagto Efetivo)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 155, 8, 1, 3, FALSE, '00000000', NULL, 'data_real', 'sega')
	, ('SegA - Valor Real da Efetivação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 163, 15, 1, 3, FALSE, '0', NULL, 'valor_real', 'sega')
	, ('SegA - Informação (SIAPE, etc)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 178, 40, 2, 2, FALSE, ' ', NULL, 'outras_informacoes', 'sega')
	, ('SegA - Código Finalidade DOC', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 218, 2, 2, 2, FALSE, ' ', NULL, 'finalidade_doc', 'sega')
	, ('SegA - Código Finalidade TED', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 220, 5, 2, 2, FALSE, ' ', NULL, 'finalidade_ted', 'sega')
	, ('SegA - Aviso ao Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 225, 1, 2, 2, FALSE, '0', NULL, 'aviso_favorecido', 'sega')
	, ('SegA - CNAB Final (BRANCOS)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 226, 5, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'sega')
	, ('SegA - Ocorrências Retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias', 'sega')

	-- DETALHE - SEGMENTO B
	, ('SegB - Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'segb')
	, ('SegB - Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'segb')
	, ('SegB - Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 8, 1, 1, 3, FALSE, '3', NULL, 'tipo_registro', 'segb')
	, ('SegB - Seq. do Registro no Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 9, 5, 1, 3, FALSE, NULL, 'sequencia_lote', 'sequencial_lote', 'segb')
	, ('SegB - Código do Segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 14, 1, 2, 2, FALSE, 'B', NULL, 'codigo_segmento', 'segb')
	, ('SegB - CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 15, 3, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'segb')
	, ('SegB - Tipo Inscrição Favorec', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 18, 1, 1, 3, FALSE, NULL, 'colaborador.tipo_inscricao', 'tipo_inscricao_favorecido', 'segb')
	, ('SegB - Número Inscrição Favorec', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 19, 14, 1, 3, FALSE, NULL, 'colaborador.cpf', 'inscricao_favorecido', 'segb')
	, ('SegB - Logradouro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 33, 30, 2, 2, FALSE, NULL, 'colaborador.logradouro', 'logradouro_favorecido', 'segb')
	, ('SegB - Número Casa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 63, 5, 1, 3, FALSE, NULL, 'colaborador.numero', 'numero_endereco', 'segb')
	, ('SegB - Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 68, 15, 2, 2, FALSE, NULL, 'colaborador.complemento', 'complemento_endereco', 'segb')
	, ('SegB - Bairro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 83, 15, 2, 2, FALSE, NULL, 'colaborador.bairro', 'bairro_favorecido', 'segb')
	, ('SegB - Cidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 98, 20, 2, 2, FALSE, NULL, 'colaborador.cidade', 'cidade_favorecido', 'segb')
	, ('SegB - CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 118, 5, 1, 3, FALSE, NULL, 'colaborador.cep', 'cep_favorecido', 'segb')
	, ('SegB - CEP Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 123, 3, 2, 2, FALSE, NULL, 'colaborador.complemento_cep', 'complemento_cep_favorecido', 'segb')
	, ('SegB - Estado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 126, 2, 2, 2, FALSE, NULL, 'colaborador.estado', 'uf_favorecido', 'segb')
	, ('SegB - Data Vencimento (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 128, 8, 1, 3, FALSE, NULL, 'pagamento.data_vencimento', 'data_vencimento', 'segb')
	, ('SegB - Valor a Pagar (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 136, 15, 1, 3, FALSE, NULL, 'pagamento.valor', 'valor_pagamento', 'segb')
	, ('SegB - Abatimento (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 151, 15, 1, 3, FALSE, '0', NULL, 'valor_abatimento', 'segb')
	, ('SegB - Desconto (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 166, 15, 1, 3, FALSE, '0', NULL, 'valor_desconto', 'segb')
	, ('SegB - Mora (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 181, 15, 1, 3, FALSE, '0', NULL, 'valor_mora', 'segb')
	, ('SegB - Multa (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 196, 15, 1, 3, FALSE, '0', NULL, 'valor_multa', 'segb')
	, ('SegB - Cód. Doc. Banco Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 211, 15, 2, 2, FALSE, ' ', NULL, 'codigo_documento_favorecido', 'segb')
	, ('SegB - Aviso Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 226, 1, 1, 3, FALSE, '0', NULL, 'aviso_favorecido', 'segb')
	, ('SegB - Uso Exclusivo FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 3, 227, 14, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'segb')

	-- TRAILER DE LOTE
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 8, 1, 1, 3, FALSE, '5', NULL, 'tipo_registro', 'geral')
	, ('CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Qtd Registros Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 18, 6, 1, 3, FALSE, NULL, 'lote.quantidade_registros', 'qtd_registros_lote', 'geral')
	, ('Valor Total Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 24, 18, 1, 3, FALSE, NULL, 'lote.valor_total', 'valor_total_lote', 'geral')
	, ('Qtd Moedas Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 42, 18, 1, 3, FALSE, '0', NULL, 'qtd_moedas_lote', 'geral')
	, ('Nº Aviso Débito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 60, 6, 1, 3, FALSE, '0', NULL, 'numero_aviso_debito', 'geral')
	, ('CNAB Final Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 66, 165, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Ocorrências Retorno Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 4, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias_lote', 'geral')

	-- TRAILER DE ARQUIVO
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 4, 4, 1, 3, FALSE, '9999', NULL, 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 8, 1, 1, 3, FALSE, '9', NULL, 'tipo_registro', 'geral')
	, ('CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Qtd Lotes Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 18, 6, 1, 3, FALSE, NULL, 'arquivo.quantidade_lotes', 'qtd_lotes_arquivo', 'geral')
	, ('Qtd Registros Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 24, 6, 1, 3, FALSE, NULL, 'arquivo.quantidade_registros_total', 'qtd_registros_arquivo', 'geral')
	, ('Qtd Contas Conciliação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 30, 6, 1, 3, FALSE, '0', NULL, 'qtd_contas_conciliacao', 'geral')
	, ('CNAB Final Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_remessa' AND tipo_arquivo = 1 LIMIT 1), 5, 36, 205, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;
	-- ==============================================
	-- LAYOUT: folha_pagamento_bradesco_240_posicoes_retorno
	-- ==============================================
INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
	, grupo
) VALUES
	-- HEADER DE ARQUIVO
	('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 3, 1, 3, TRUE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 4, 4, 1, 3, FALSE, '0000', NULL, 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 8, 1, 1, 3, FALSE, '0', NULL, 'tipo_registro', 'geral')
	, ('CNAB (Reservado Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Tipo de Inscrição da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 18, 1, 1, 3, FALSE, NULL, 'empresa.tipo_inscricao', 'tipo_inscricao_empresa', 'geral')
	, ('Número de Inscrição da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 19, 14, 1, 3, FALSE, NULL, 'empresa.cnpj', 'inscricao_empresa', 'geral')
	, ('Código do Convênio', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 33, 20, 2, 2, FALSE, NULL, 'empresa.convenio', 'codigo_convenio', 'geral')
	, ('Agência Mantenedora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 53, 5, 1, 3, FALSE, NULL, 'conta.agencia', 'agencia_mantenedora', 'geral')
	, ('Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 58, 1, 2, 2, FALSE, NULL, 'conta.agencia_dv', 'dv_agencia', 'geral')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 59, 12, 1, 3, FALSE, NULL, 'conta.numero', 'conta_corrente', 'geral')
	, ('Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 71, 1, 2, 2, FALSE, NULL, 'conta.numero_dv', 'dv_conta', 'geral')
	, ('Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 72, 1, 2, 2, FALSE, NULL, 'conta.dv_ag_conta', 'dv_agencia_conta', 'geral')
	, ('Nome da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 73, 30, 2, 2, FALSE, NULL, 'empresa.nome', 'nome_empresa', 'geral')
	, ('Nome do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 103, 30, 2, 2, FALSE, 'BRADESCO', 'banco.nome', 'nome_banco', 'geral')
	, ('CNAB (Reservado)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 133, 10, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Código Remessa/Retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 143, 1, 1, 3, FALSE, '2', NULL, 'codigo_remessa_retorno', 'geral')
	, ('Data Geração', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 144, 8, 1, 3, FALSE, NULL, 'CURRENT_DATE', 'data_geracao', 'geral')
	, ('Hora Geração', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 152, 6, 1, 3, FALSE, NULL, 'CURRENT_TIME', 'hora_geracao', 'geral')
	, ('Seq (NSA)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 158, 6, 1, 3, FALSE, NULL, 'NSA', 'sequencial_arquivo', 'geral')
	, ('Versão do Layout', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 164, 3, 1, 3, FALSE, '089', NULL, 'versao_layout', 'geral')
	, ('Densidade (BPI)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 167, 5, 1, 3, FALSE, '01600', NULL, 'densidade_gravacao', 'geral')
	, ('Reservado Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 172, 20, 2, 2, FALSE, ' ', NULL, 'reservado_banco', 'geral')
	, ('Reservado Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 192, 20, 2, 2, FALSE, ' ', NULL, 'reservado_empresa', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 212, 29, 2, 2, FALSE, ' ', NULL, 'cnab_3', 'geral')
	
	-- HEADER DE LOTE
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 8, 1, 1, 3, FALSE, '1', NULL, 'tipo_registro', 'geral')
	, ('Tipo de Operação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 9, 1, 2, 2, FALSE, 'C', NULL, 'tipo_operacao', 'geral')
	, ('Tipo de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 10, 2, 1, 3, FALSE, '30', NULL, 'tipo_servico', 'geral')
	, ('Forma de Lançamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 12, 2, 1, 3, FALSE, '01', NULL, 'forma_lancamento', 'geral')
	, ('Versão do Layout Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 14, 3, 1, 3, FALSE, '040', NULL, 'versao_layout_lote', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 17, 1, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Tipo Inscrição Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 18, 1, 1, 3, FALSE, NULL, 'empresa.tipo_inscricao', 'tipo_inscricao_empresa', 'geral')
	, ('Número Inscrição Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 19, 14, 1, 3, FALSE, NULL, 'empresa.cnpj', 'inscricao_empresa', 'geral')
	, ('Código Convênio BD', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 33, 20, 2, 2, FALSE, NULL, 'empresa.convenio', 'codigo_convenio', 'geral')
	, ('Agência Mantenedora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 53, 5, 1, 3, FALSE, NULL, 'conta.agencia', 'agencia_mantenedora', 'geral')
	, ('Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 58, 1, 2, 2, FALSE, NULL, 'conta.agencia_dv', 'dv_agencia', 'geral')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 59, 12, 1, 3, FALSE, NULL, 'conta.numero', 'conta_corrente', 'geral')
	, ('Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 71, 1, 2, 2, FALSE, NULL, 'conta.numero_dv', 'dv_conta', 'geral')
	, ('Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 72, 1, 2, 2, FALSE, NULL, 'conta.dv_ag_conta', 'dv_agencia_conta', 'geral')
	, ('Nome da Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 73, 30, 2, 2, FALSE, NULL, 'empresa.nome', 'nome_empresa', 'geral')
	, ('Mensagem', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 103, 40, 2, 2, FALSE, ' ', NULL, 'mensagem', 'geral')
	, ('Logradouro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 143, 30, 2, 2, FALSE, NULL, 'empresa.logradouro', 'logradouro_empresa', 'geral')
	, ('Número', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 173, 5, 1, 3, FALSE, NULL, 'empresa.numero', 'numero_endereco', 'geral')
	, ('Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 178, 15, 2, 2, FALSE, NULL, 'empresa.complemento', 'complemento_endereco', 'geral')
	, ('Nome da Cidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 193, 20, 2, 2, FALSE, NULL, 'empresa.cidade', 'cidade_empresa', 'geral')
	, ('CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 213, 5, 1, 3, FALSE, NULL, 'empresa.cep', 'cep_empresa', 'geral')
	, ('Complemento CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 218, 3, 2, 2, FALSE, NULL, 'empresa.complemento_cep', 'complemento_cep_empresa', 'geral')
	, ('Sigla do Estado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 221, 2, 2, 2, FALSE, NULL, 'empresa.estado', 'uf_empresa', 'geral')
	, ('CNAB FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 223, 8, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Ocorrências Retorno Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 2, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias_lote', 'geral')
	
	-- DETALHE - SEGMENTO A
	, ('SegA - Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'sega')
	, ('SegA - Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'sega')
	, ('SegA - Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 8, 1, 1, 3, FALSE, '3', NULL, 'tipo_registro', 'sega')
	, ('SegA - Seq. do Registro no Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 9, 5, 1, 3, FALSE, NULL, 'sequencia_lote', 'sequencial_lote', 'sega')
	, ('SegA - Código do Segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 14, 1, 2, 2, FALSE, 'A', NULL, 'codigo_segmento', 'sega')
	, ('SegA - Tipo de Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 15, 1, 1, 3, FALSE, '0', NULL, 'tipo_movimento', 'sega')
	, ('SegA - Código Instrução Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 16, 2, 1, 3, FALSE, '00', NULL, 'instrucao_movimento', 'sega')
	, ('SegA - Câmara Centralizadora', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 3, 1, 3, FALSE, '018', 'pagamento.camara', 'camara_centralizadora', 'sega')
	, ('SegA - Banco do Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 21, 3, 1, 3, FALSE, NULL, 'conta_favorecido.banco', 'banco_favorecido', 'sega')
	, ('SegA - Agência Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 24, 5, 1, 3, FALSE, NULL, 'conta_favorecido.agencia', 'agencia_favorecido', 'sega')
	, ('SegA - Agência DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 29, 1, 2, 2, FALSE, NULL, 'conta_favorecido.agencia_dv', 'dv_agencia_favorecido', 'sega')
	, ('SegA - Conta Corrente Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 30, 12, 1, 3, FALSE, NULL, 'conta_favorecido.numero', 'conta_favorecido', 'sega')
	, ('SegA - Conta Corrente DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 42, 1, 2, 2, FALSE, NULL, 'conta_favorecido.numero_dv', 'dv_conta_favorecido', 'sega')
	, ('SegA - Agência/Conta DV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 43, 1, 2, 2, FALSE, NULL, 'conta_favorecido.dv_ag_conta', 'dv_agencia_conta_favorecido', 'sega')
	, ('SegA - Nome do Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 44, 30, 2, 2, FALSE, NULL, 'colaborador.nome', 'nome_favorecido', 'sega')
	, ('SegA - Seu Número (Doc Empresa)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 74, 20, 2, 2, FALSE, NULL, 'pagamento.id', 'seu_numero', 'sega')
	, ('SegA - Data de Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 94, 8, 1, 3, FALSE, NULL, 'pagamento.data', 'data_pagamento', 'sega')
	, ('SegA - Tipo da Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 102, 3, 2, 2, FALSE, 'BRL', NULL, 'tipo_moeda', 'sega')
	, ('SegA - Quantidade da Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 105, 15, 1, 3, FALSE, '0', NULL, 'quantidade_moeda', 'sega')
	, ('SegA - Valor Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 120, 15, 1, 3, FALSE, NULL, 'pagamento.valor', 'valor_pagamento', 'sega')
	, ('SegA - Nosso Número (Doc Banco)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 135, 20, 2, 2, FALSE, ' ', 'pagamento.id', 'nosso_numero', 'sega')
	, ('SegA - Data Real (Pagto Efetivo)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 155, 8, 1, 3, FALSE, '00000000', NULL, 'data_real', 'sega')
	, ('SegA - Valor Real da Efetivação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 163, 15, 1, 3, FALSE, '0', NULL, 'valor_real', 'sega')
	, ('SegA - Informação (SIAPE, etc)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 178, 40, 2, 2, FALSE, ' ', NULL, 'outras_informacoes', 'sega')
	, ('SegA - Código Finalidade DOC', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 218, 2, 2, 2, FALSE, ' ', NULL, 'finalidade_doc', 'sega')
	, ('SegA - Código Finalidade TED', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 220, 5, 2, 2, FALSE, ' ', NULL, 'finalidade_ted', 'sega')
	, ('SegA - Aviso ao Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 225, 1, 2, 2, FALSE, '0', NULL, 'aviso_favorecido', 'sega')
	, ('SegA - CNAB Final (BRANCOS)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 226, 5, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'sega')
	, ('SegA - Ocorrências Retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias', 'sega')
	
	-- DETALHE - SEGMENTO B
	, ('SegB - Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'segb')
	, ('SegB - Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'segb')
	, ('SegB - Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 8, 1, 1, 3, FALSE, '3', NULL, 'tipo_registro', 'segb')
	, ('SegB - Seq. do Registro no Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 9, 5, 1, 3, FALSE, NULL, 'sequencia_lote', 'sequencial_lote', 'segb')
	, ('SegB - Código do Segmento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 14, 1, 2, 2, FALSE, 'B', NULL, 'codigo_segmento', 'segb')
	, ('SegB - CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 15, 3, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'segb')
	, ('SegB - Tipo Inscrição Favorec', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 18, 1, 1, 3, FALSE, NULL, 'colaborador.tipo_inscricao', 'tipo_inscricao_favorecido', 'segb')
	, ('SegB - Número Inscrição Favorec', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 19, 14, 1, 3, FALSE, NULL, 'colaborador.cpf', 'inscricao_favorecido', 'segb')
	, ('SegB - Logradouro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 33, 30, 2, 2, FALSE, NULL, 'colaborador.logradouro', 'logradouro_favorecido', 'segb')
	, ('SegB - Número Casa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 5, 1, 3, FALSE, NULL, 'colaborador.numero', 'numero_endereco', 'segb')
	, ('SegB - Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 68, 15, 2, 2, FALSE, NULL, 'colaborador.complemento', 'complemento_endereco', 'segb')
	, ('SegB - Bairro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 83, 15, 2, 2, FALSE, NULL, 'colaborador.bairro', 'bairro_favorecido', 'segb')
	, ('SegB - Cidade', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 98, 20, 2, 2, FALSE, NULL, 'colaborador.cidade', 'cidade_favorecido', 'segb')
	, ('SegB - CEP', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 118, 5, 1, 3, FALSE, NULL, 'colaborador.cep', 'cep_favorecido', 'segb')
	, ('SegB - CEP Complemento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 123, 3, 2, 2, FALSE, NULL, 'colaborador.complemento_cep', 'complemento_cep_favorecido', 'segb')
	, ('SegB - Estado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 126, 2, 2, 2, FALSE, NULL, 'colaborador.estado', 'uf_favorecido', 'segb')
	, ('SegB - Data Vencimento (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 128, 8, 1, 3, FALSE, NULL, 'pagamento.data_vencimento', 'data_vencimento', 'segb')
	, ('SegB - Valor a Pagar (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 136, 15, 1, 3, FALSE, NULL, 'pagamento.valor', 'valor_pagamento', 'segb')
	, ('SegB - Abatimento (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 151, 15, 1, 3, FALSE, '0', NULL, 'valor_abatimento', 'segb')
	, ('SegB - Desconto (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 166, 15, 1, 3, FALSE, '0', NULL, 'valor_desconto', 'segb')
	, ('SegB - Mora (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 181, 15, 1, 3, FALSE, '0', NULL, 'valor_mora', 'segb')
	, ('SegB - Multa (Tributos)', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 196, 15, 1, 3, FALSE, '0', NULL, 'valor_multa', 'segb')
	, ('SegB - Cód. Doc. Banco Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 211, 15, 2, 2, FALSE, ' ', NULL, 'codigo_documento_favorecido', 'segb')
	, ('SegB - Aviso Favorecido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 226, 1, 1, 3, FALSE, '0', NULL, 'aviso_favorecido', 'segb')
	, ('SegB - Uso Exclusivo FEBRABAN', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 227, 14, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'segb')
	
	-- TRAILER DE LOTE
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 4, 4, 1, 3, FALSE, NULL, 'lote.numero', 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 8, 1, 1, 3, FALSE, '5', NULL, 'tipo_registro', 'geral')
	, ('CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Qtd Registros Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 18, 6, 1, 3, FALSE, NULL, 'lote.quantidade_registros', 'qtd_registros_lote', 'geral')
	, ('Valor Total Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 24, 18, 1, 3, FALSE, NULL, 'lote.valor_total', 'valor_total_lote', 'geral')
	, ('Qtd Moedas Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 42, 18, 1, 3, FALSE, '0', NULL, 'qtd_moedas_lote', 'geral')
	, ('Nº Aviso Débito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 60, 6, 1, 3, FALSE, '0', NULL, 'numero_aviso_debito', 'geral')
	, ('CNAB Final Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 66, 165, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
	, ('Ocorrências Retorno Lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 4, 231, 10, 2, 2, FALSE, ' ', NULL, 'ocorrencias_lote', 'geral')
	
	-- TRAILER DE ARQUIVO
	, ('Código do Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 3, 1, 3, FALSE, '237', 'banco.codigo', 'codigo_banco', 'geral')
	, ('Lote de Serviço', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 4, 4, 1, 3, FALSE, '9999', NULL, 'lote_servico', 'geral')
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 8, 1, 1, 3, FALSE, '9', NULL, 'tipo_registro', 'geral')
	, ('CNAB Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 9, 9, 2, 2, FALSE, ' ', NULL, 'cnab_1', 'geral')
	, ('Qtd Lotes Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 18, 6, 1, 3, FALSE, NULL, 'arquivo.quantidade_lotes', 'qtd_lotes_arquivo', 'geral')
	, ('Qtd Registros Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 24, 6, 1, 3, FALSE, NULL, 'arquivo.quantidade_registros_total', 'qtd_registros_arquivo', 'geral')
	, ('Qtd Contas Conciliação', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 30, 6, 1, 3, FALSE, '0', NULL, 'qtd_contas_conciliacao', 'geral')
	, ('CNAB Final Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 36, 205, 2, 2, FALSE, ' ', NULL, 'cnab_2', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;

	-- ==============================================
	-- LAYOUT: getnet_400_posicoes_retorno
	-- ==============================================
INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
	, grupo
) VALUES
	-- TIPO 0 (Header)
	('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 1, 2, 2, FALSE, '0', NULL, 'codigo_registro', 'geral')
	, ('Data de criacao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 2, 8, 1, 3, FALSE, NULL, NULL, 'data_criacao_arquivo', 'geral')
	, ('Hora de criacao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 10, 6, 1, 3, FALSE, NULL, NULL, 'hora_criacao_arquivo', 'geral')
	, ('Data de referencia do Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 16, 8, 1, 3, FALSE, NULL, NULL, 'data_referencia_movimento', 'geral')
	, ('Arquivo e Versao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 24, 8, 2, 2, FALSE, 'CEADM100', NULL, 'arquivo_versao', 'geral')
	, ('Codigo do Estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 32, 15, 2, 2, TRUE, NULL, NULL, 'codigo_estabelecimento', 'geral')
	, ('CNPJ do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 47, 14, 1, 3, FALSE, NULL, NULL, 'cnpj_adquirente', 'geral')
	, ('Nome do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 61, 20, 2, 2, FALSE, NULL, NULL, 'nome_adquirente', 'geral')
	, ('Sequencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 81, 9, 1, 3, FALSE, NULL, NULL, 'sequencia', 'geral')
	, ('Codigo do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 90, 2, 2, 2, FALSE, NULL, NULL, 'codigo_adquirente', 'geral')
	, ('Versao do Layout', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 92, 25, 2, 2, FALSE, NULL, NULL, 'versao_layout', 'geral')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 1, 117, 284, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')

	-- TIPO 1 (Movimento)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '1', NULL, 'codigo_registro', 'getnet1')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet1')
	, ('Codigo do Produto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 2, 2, 2, FALSE, NULL, NULL, 'codigo_produto', 'getnet1')
	, ('Forma de Captura', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 19, 3, 2, 2, FALSE, NULL, NULL, 'forma_captura', 'getnet1')
	, ('Numero do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 22, 9, 1, 3, FALSE, NULL, NULL, 'numero_rv', 'getnet1')
	, ('Data do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 31, 8, 1, 3, FALSE, NULL, NULL, 'data_rv', 'getnet1')
	, ('Data Do Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 39, 8, 1, 3, FALSE, NULL, NULL, 'data_pagamento', 'getnet1')
	, ('Banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 47, 3, 1, 3, FALSE, NULL, NULL, 'banco', 'getnet1')
	, ('Agencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 50, 6, 1, 3, FALSE, NULL, NULL, 'agencia', 'getnet1')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 56, 11, 1, 3, FALSE, NULL, NULL, 'conta_corrente', 'getnet1')
	, ('Numero do CVs Aceitos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 67, 9, 1, 3, FALSE, NULL, NULL, 'numero_cvs_aceitos', 'getnet1')
	, ('Numero de CVs Rejeitados', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 76, 9, 1, 3, FALSE, NULL, NULL, 'numero_cvs_rejeitados', 'getnet1')
	, ('Valor Bruto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 85, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto', 'getnet1')
	, ('Valor Liquido', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 97, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido', 'getnet1')
	, ('Valor da tarifa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 109, 12, 1, 3, FALSE, NULL, NULL, 'valor_tarifa', 'getnet1')
	, ('Valor da Taxa de Desconto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 121, 12, 1, 3, FALSE, NULL, NULL, 'valor_taxa_desconto', 'getnet1')
	, ('Valor Rejeitado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 133, 12, 1, 3, FALSE, NULL, NULL, 'valor_rejeitado', 'getnet1')
	, ('Valor Credito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 145, 12, 1, 3, FALSE, NULL, NULL, 'valor_credito', 'getnet1')
	, ('Valor Encargos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 157, 12, 1, 3, FALSE, NULL, NULL, 'valor_encargos', 'getnet1')
	, ('Indicador de tipo de pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 169, 2, 2, 2, FALSE, NULL, NULL, 'indicador_tipo_pagamento', 'getnet1')
	, ('Numero da parcela do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 171, 2, 1, 3, FALSE, NULL, NULL, 'numero_parcela_rv', 'getnet1')
	, ('Quantidade de parcelas do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 173, 2, 1, 3, FALSE, NULL, NULL, 'quantidade_parcelas_rv', 'getnet1')
	, ('Centralizador dos Pagamentos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 175, 15, 2, 2, FALSE, NULL, NULL, 'centralizador_pagamentos', 'getnet1')
	, ('Numero da Operacao de Antecipacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 190, 15, 1, 3, FALSE, NULL, NULL, 'numero_operacao_antecipacao', 'getnet1')
	, ('Data do vencimento original', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 205, 8, 1, 3, FALSE, NULL, NULL, 'data_vencimento_original', 'getnet1')
	, ('Custo da Operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 213, 12, 1, 3, FALSE, NULL, NULL, 'custo_operacao', 'getnet1')
	, ('Valor liquido do RV Antecipado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 225, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido_rv_antecipado', 'getnet1')
	, ('Numero de controle operacao cobranca', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 237, 18, 1, 3, FALSE, NULL, NULL, 'numero_controle_operacao_cobranca', 'getnet1')
	, ('Valor liquido cobranca', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 255, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido_cobranca', 'getnet1')
	, ('ID compensacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 267, 15, 1, 3, FALSE, NULL, NULL, 'id_compensacao', 'getnet1')
	, ('Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 282, 3, 1, 3, FALSE, NULL, NULL, 'moeda', 'getnet1')
	, ('Identificador de baixa da cobranca', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 285, 1, 2, 2, FALSE, NULL, NULL, 'identificador_baixa_cobranca', 'getnet1')
	, ('Sinal da transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 286, 1, 1, 3, FALSE, NULL, NULL, 'sinal_transacao', 'getnet1')
	, ('Metadado 1', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 287, 2, 2, 2, FALSE, NULL, NULL, 'metadado_1', 'getnet1')
	, ('Conta para pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 289, 20, 1, 3, FALSE, NULL, NULL, 'conta_pagamento', 'getnet1')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 309, 92, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet1')

	-- TIPO 2 (Movimento)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '2', NULL, 'codigo_registro', 'getnet2')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet2')
	, ('Numero do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 9, 1, 3, FALSE, NULL, NULL, 'numero_rv', 'getnet2')
	, ('NSU do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 26, 12, 1, 3, FALSE, NULL, NULL, 'nsu_adquirente', 'getnet2')
	, ('Data da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 38, 8, 1, 3, FALSE, NULL, NULL, 'data_transacao', 'getnet2')
	, ('Hora da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 46, 6, 1, 3, FALSE, NULL, NULL, 'hora_transacao', 'getnet2')
	, ('Numero do Cartao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 52, 19, 2, 2, FALSE, NULL, NULL, 'numero_cartao', 'getnet2')
	, ('Valor da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 71, 12, 1, 3, FALSE, NULL, NULL, 'valor_transacao', 'getnet2')
	, ('Valor do Saque', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 83, 12, 1, 3, FALSE, NULL, NULL, 'valor_saque', 'getnet2')
	, ('Valor da Taxa de Embarque', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 95, 12, 1, 3, FALSE, NULL, NULL, 'valor_taxa_embarque', 'getnet2')
	, ('Numero de Parcelas', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 107, 2, 1, 3, FALSE, NULL, NULL, 'numero_parcelas', 'getnet2')
	, ('Numero da Parcela relacionada', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 109, 2, 1, 3, FALSE, NULL, NULL, 'numero_parcela_relacionada', 'getnet2')
	, ('Valor da Parcela', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 111, 12, 1, 3, FALSE, NULL, NULL, 'valor_parcela', 'getnet2')
	, ('Data do Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 123, 8, 1, 3, FALSE, NULL, NULL, 'data_pagamento', 'getnet2')
	, ('Codigo de Autorizacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 131, 10, 2, 2, FALSE, NULL, NULL, 'codigo_autorizacao', 'getnet2')
	, ('Forma de captura', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 141, 3, 2, 2, FALSE, NULL, NULL, 'forma_captura', 'getnet2')
	, ('Status da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 144, 1, 2, 2, FALSE, NULL, NULL, 'status_transacao', 'getnet2')
	, ('Codigo estabelecimento Centralizador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 145, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento_centralizador', 'getnet2')
	, ('Codigo do terminal', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 160, 8, 2, 2, FALSE, NULL, NULL, 'codigo_terminal', 'getnet2')
	, ('Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 168, 3, 1, 3, FALSE, NULL, NULL, 'moeda', 'getnet2')
	, ('Origem do Emissor do Cartao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 171, 1, 2, 2, FALSE, NULL, NULL, 'origem_emissor_cartao', 'getnet2')
	, ('Sinal da transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 172, 1, 1, 3, FALSE, NULL, NULL, 'sinal_transacao', 'getnet2')
	, ('Carteira Digital', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 173, 3, 2, 2, FALSE, NULL, NULL, 'carteira_digital', 'getnet2')
	, ('Valor Comissao da venda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 176, 12, 1, 3, FALSE, NULL, NULL, 'valor_comissao_venda', 'getnet2')
	, ('Identificador proximo conteudo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 188, 2, 2, 2, FALSE, NULL, NULL, 'identificador_proximo_conteudo', 'getnet2')
	, ('Conteudo dinamico', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 190, 118, 2, 2, FALSE, NULL, NULL, 'conteudo_dinamico', 'getnet2')
	, ('Identificador proximo conteudo 2', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 308, 2, 2, 2, FALSE, NULL, NULL, 'identificador_proximo_conteudo_2', 'getnet2')
	, ('Conteudo dinamico 2', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 310, 50, 2, 2, FALSE, NULL, NULL, 'conteudo_dinamico_2', 'getnet2')
	, ('Reservado para o futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 360, 41, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet2')

	-- TIPO 3 (Movimento)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '3', NULL, 'codigo_registro', 'getnet3')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet3')
	, ('Numero do RV ajustado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 9, 1, 3, FALSE, NULL, NULL, 'numero_rv_ajustado', 'getnet3')
	, ('Data do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 26, 8, 1, 3, FALSE, NULL, NULL, 'data_rv', 'getnet3')
	, ('Data do Pagamento do RV', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 34, 8, 1, 3, FALSE, NULL, NULL, 'data_pagamento_rv', 'getnet3')
	, ('Identificador do ajuste', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 42, 20, 1, 3, FALSE, NULL, NULL, 'identificador_ajuste', 'getnet3')
	, ('Brancos', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 62, 1, 2, 2, FALSE, NULL, NULL, 'brancos', 'getnet3')
	, ('Sinal do valor do ajuste', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 1, 2, 2, FALSE, NULL, NULL, 'sinal_valor_ajuste', 'getnet3')
	, ('Valor do ajuste', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 64, 12, 1, 3, FALSE, NULL, NULL, 'valor_ajuste', 'getnet3')
	, ('Motivo do ajuste', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 76, 2, 2, 2, FALSE, NULL, NULL, 'motivo_ajuste', 'getnet3')
	, ('Data da carta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 78, 8, 1, 3, FALSE, NULL, NULL, 'data_carta', 'getnet3')
	, ('Numero do Cartao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 86, 19, 2, 2, FALSE, NULL, NULL, 'numero_cartao', 'getnet3')
	, ('Numero do RV original', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 105, 9, 1, 3, FALSE, NULL, NULL, 'numero_rv_original', 'getnet3')
	, ('NSU do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 114, 12, 1, 3, FALSE, NULL, NULL, 'nsu_adquirente', 'getnet3')
	, ('Data da transacao original', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 126, 8, 1, 3, FALSE, NULL, NULL, 'data_transacao_original', 'getnet3')
	, ('Indicador de tipo de pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 134, 2, 2, 2, FALSE, NULL, NULL, 'indicador_tipo_pagamento', 'getnet3')
	, ('Numero do Terminal original', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 136, 8, 2, 2, FALSE, NULL, NULL, 'numero_terminal_original', 'getnet3')
	, ('Data Pagamento original', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 144, 8, 2, 2, FALSE, NULL, NULL, 'data_pagamento_original', 'getnet3')
	, ('Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 152, 3, 1, 3, FALSE, NULL, NULL, 'moeda', 'getnet3')
	, ('Valor Comissao do venda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 155, 12, 1, 3, FALSE, NULL, NULL, 'valor_comissao_venda', 'getnet3')
	, ('Identificador proximo conteudo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 167, 2, 2, 2, FALSE, NULL, NULL, 'identificador_proximo_conteudo', 'getnet3')
	, ('Conteudo dinamico', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 169, 118, 2, 2, FALSE, NULL, NULL, 'conteudo_dinamico', 'getnet3')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 287, 114, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet3')

	-- TIPO 4 (Movimento)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '4', NULL, 'codigo_registro', 'getnet4')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet4')
	, ('Data da Operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 8, 1, 3, FALSE, NULL, NULL, 'data_operacao', 'getnet4')
	, ('Data do Credito', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 25, 8, 1, 3, FALSE, NULL, NULL, 'data_credito', 'getnet4')
	, ('Numero da Operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 33, 15, 1, 3, FALSE, NULL, NULL, 'numero_operacao', 'getnet4')
	, ('Valor Bruto da Antecipacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 48, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto_antecipacao', 'getnet4')
	, ('Valor da Taxa de Antecipacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 60, 12, 1, 3, FALSE, NULL, NULL, 'valor_taxa_antecipacao', 'getnet4')
	, ('Valor Liquido da Antecipacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 72, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido_antecipacao', 'getnet4')
	, ('Taxa ao mes da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 84, 11, 1, 3, FALSE, NULL, NULL, 'taxa_ao_mes_operacao', 'getnet4')
	, ('Codigo estabelecimento Centralizador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 95, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento_centralizador', 'getnet4')
	, ('Banco do Domicilio Bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 110, 3, 1, 3, FALSE, NULL, NULL, 'banco_domicilio_bancario', 'getnet4')
	, ('Agencia do Domicilio Bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 113, 6, 1, 3, FALSE, NULL, NULL, 'agencia_domicilio_bancario', 'getnet4')
	, ('Conta Corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 119, 11, 2, 2, FALSE, NULL, NULL, 'conta_corrente', 'getnet4')
	, ('Canal de Antecipacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 130, 3, 2, 2, FALSE, NULL, NULL, 'canal_antecipacao', 'getnet4')
	, ('Indicador do Tipo de Pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 133, 2, 2, 2, FALSE, NULL, NULL, 'indicador_tipo_pagamento', 'getnet4')
	, ('Metadado 1', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 135, 2, 2, 2, FALSE, NULL, NULL, 'metadado_1', 'getnet4')
	, ('Conta para pagamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 137, 20, 1, 3, FALSE, NULL, NULL, 'conta_pagamento', 'getnet4')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 157, 244, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet4')

	-- TIPO 5 (Movimento)
	, ('Tipo de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '5', NULL, 'codigo_registro', 'getnet5')
	, ('Codigo do estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet5')
	, ('Data da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 8, 1, 3, FALSE, NULL, NULL, 'data_operacao', 'getnet5')
	, ('Data do credito da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 25, 8, 1, 3, FALSE, NULL, NULL, 'data_credito_operacao', 'getnet5')
	, ('Numero da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 33, 20, 2, 2, FALSE, NULL, NULL, 'numero_operacao', 'getnet5')
	, ('Tipo da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 53, 2, 2, 2, FALSE, NULL, NULL, 'tipo_operacao', 'getnet5')
	, ('Valor bruto total da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 55, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto_total_operacao', 'getnet5')
	, ('Valor bruto da operacao Adquirencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 67, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto_operacao_adquirencia', 'getnet5')
	, ('Valor do custo da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 79, 12, 1, 3, FALSE, NULL, NULL, 'valor_custo_operacao', 'getnet5')
	, ('Valor liquido da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 91, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido_operacao', 'getnet5')
	, ('Taxa mensal da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 103, 11, 1, 3, FALSE, NULL, NULL, 'taxa_mensal_operacao', 'getnet5')
	, ('Tipo de conta do estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 114, 2, 2, 2, FALSE, NULL, NULL, 'tipo_conta_estabelecimento', 'getnet5')
	, ('Banco do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 116, 3, 1, 3, FALSE, NULL, NULL, 'banco_domicilio_bancario', 'getnet5')
	, ('Agencia do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 119, 6, 1, 3, FALSE, NULL, NULL, 'agencia_domicilio_bancario', 'getnet5')
	, ('Conta do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 125, 20, 2, 2, FALSE, NULL, NULL, 'conta_domicilio_bancario', 'getnet5')
	, ('Canal de operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 145, 3, 2, 2, FALSE, NULL, NULL, 'canal_operacao', 'getnet5')
	, ('Tipo de movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 148, 1, 2, 2, FALSE, NULL, NULL, 'tipo_movimento', 'getnet5')
	, ('Tipo de participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 149, 3, 2, 2, FALSE, NULL, NULL, 'tipo_participante', 'getnet5')
	, ('ID do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 158, 18, 1, 3, FALSE, NULL, NULL, 'id_participante', 'getnet5')
	, ('Tipo de documento do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 170, 1, 2, 2, FALSE, NULL, NULL, 'tipo_documento_participante', 'getnet5')
	, ('CNPJ/CPF do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 171, 14, 1, 3, FALSE, NULL, NULL, 'cnpj_cpf_participante', 'getnet5')
	, ('Tipo de conta do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 185, 2, 2, 2, FALSE, NULL, NULL, 'tipo_conta_participante', 'getnet5')
	, ('Banco do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 187, 3, 1, 3, FALSE, NULL, NULL, 'banco_participante', 'getnet5')
	, ('Agencia do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 190, 6, 1, 3, FALSE, NULL, NULL, 'agencia_participante', 'getnet5')
	, ('Conta do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 196, 20, 2, 2, FALSE, NULL, NULL, 'conta_participante', 'getnet5')
	, ('Codigo estabelecimento centralizador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 216, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento_centralizador', 'getnet5')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 231, 170, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet5')

	-- TIPO 6 (Movimento)
	, ('Tipo de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '6', NULL, 'codigo_registro', 'getnet6')
	, ('Codigo do estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'getnet6')
	, ('Data da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 17, 8, 1, 3, FALSE, NULL, NULL, 'data_operacao', 'getnet6')
	, ('Numero da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 25, 20, 2, 2, FALSE, NULL, NULL, 'numero_operacao', 'getnet6')
	, ('Tipo de operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 45, 2, 2, 2, FALSE, NULL, NULL, 'tipo_operacao', 'getnet6')
	, ('Chave da UR', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 47, 18, 1, 3, FALSE, NULL, NULL, 'chave_ur', 'getnet6')
	, ('Codigo do produto', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 65, 2, 2, 2, FALSE, NULL, NULL, 'codigo_produto', 'getnet6')
	, ('Data de vencimento da UR', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 67, 8, 1, 3, FALSE, NULL, NULL, 'data_vencimento_ur', 'getnet6')
	, ('Valor bruto total da UR', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 75, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto_total_ur', 'getnet6')
	, ('Valor bruto da UR Adquirencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 87, 12, 1, 3, FALSE, NULL, NULL, 'valor_bruto_ur_adquirencia', 'getnet6')
	, ('Valor do custo da UR', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 99, 12, 1, 3, FALSE, NULL, NULL, 'valor_custo_ur', 'getnet6')
	, ('Valor liquido da UR', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 111, 12, 1, 3, FALSE, NULL, NULL, 'valor_liquido_ur', 'getnet6')
	, ('Tipo de conta do estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 123, 2, 2, 2, FALSE, NULL, NULL, 'tipo_conta_estabelecimento', 'getnet6')
	, ('Banco do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 125, 3, 1, 3, FALSE, NULL, NULL, 'banco_domicilio_bancario', 'getnet6')
	, ('Agencia do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 128, 6, 1, 3, FALSE, NULL, NULL, 'agencia_domicilio_bancario', 'getnet6')
	, ('Conta do domicilio bancario', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 134, 20, 2, 2, FALSE, NULL, NULL, 'conta_domicilio_bancario', 'getnet6')
	, ('Tipo de movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 154, 1, 2, 2, FALSE, NULL, NULL, 'tipo_movimento', 'getnet6')
	, ('Tipo de participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 155, 3, 2, 2, FALSE, NULL, NULL, 'tipo_participante', 'getnet6')
	, ('ID do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 158, 15, 1, 3, FALSE, NULL, NULL, 'id_participante', 'getnet6')
	, ('Tipo de documento do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 173, 1, 2, 2, FALSE, NULL, NULL, 'tipo_documento_participante', 'getnet6')
	, ('CNPJ/CPF do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 174, 14, 1, 3, FALSE, NULL, NULL, 'cnpj_cpf_participante', 'getnet6')
	, ('Tipo de conta do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 188, 2, 2, 2, FALSE, NULL, NULL, 'tipo_conta_participante', 'getnet6')
	, ('Banco do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 190, 3, 1, 3, FALSE, NULL, NULL, 'banco_participante', 'getnet6')
	, ('Agencia do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 193, 6, 1, 3, FALSE, NULL, NULL, 'agencia_participante', 'getnet6')
	, ('Conta do participante', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 199, 20, 2, 2, FALSE, NULL, NULL, 'conta_participante', 'getnet6')
	, ('Codigo estabelecimento centralizador', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 219, 15, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento_centralizador', 'getnet6')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 3, 234, 167, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'getnet6')

	-- TIPO 9 (Trailer)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 1, 2, 2, FALSE, '9', NULL, 'codigo_registro', 'geral')
	, ('Quantidade de Registros', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 2, 9, 1, 3, FALSE, NULL, NULL, 'quantidade_registros', 'geral')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'getnet_400_posicoes_retorno' AND tipo_arquivo = 2 LIMIT 1), 5, 11, 390, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;


INSERT INTO public.parametro_leiaute_arquivo (
	id_leiaute_arquivo
	, codigo
	, id_empresa
) VALUES 
	(5, '30670050616301300417', '840323395')
	, (6, '30670050616301300417', '840323395')
	, (5, '30670050618301300418', '1425814216')
	, (6, '30670050618301300418', '1425814216')
	, (5, '30670050616501300417', '840337350')
	, (6, '30670050616501300417', '840337350')
	, (5, '30670050608001300414', '944121400')-- tigre
	, (6, '30670050608001300414', '944121400')
	, (5, '30670050617801300418', '1295124229')
	, (6, '30670050617801300418', '1295124229')
	, (5, '30670050613001300415', '1396819091')
	, (6, '30670050613001300415', '1396819091')
	, (5, '30670049928301300416', '841505212')
	, (6, '30670049928301300416', '841505212')
	, (5, '30670050612401300415', '766250907')
	, (6, '30670050612401300415', '766250907')
	, (5, '02860936744601300768', '813932469')
	, (6, '02860936744601300768', '813932469')
	, (5, '30670050611601300415', '1178242677')
	, (6, '30670050611601300415', '1178242677')
	, (5, '30670050615701300416', '1550546534')
	, (6, '30670050615701300416', '1550546534')
	, (5, '30670051216901300419', '683779262')
	, (6, '30670051216901300419', '683779262')
	, (5, '30670051216301300419', '1477536414')
	, (6, '30670051216301300419', '1477536414')
	, (5, '30670050615401300416', '245604581')
	, (6, '30670050615401300416', '245604581');

INSERT INTO public.parametro_leiaute_arquivo (
	id_leiaute_arquivo
	, codigo
	, id_empresa
) VALUES 
	(5, '30670050610701300415', '1691876755') -- divisao
	, (6, '30670050610701300415', '1691876755') 
	, (5, '30670050610201300414', '816119136') -- sao paulo
	, (6, '30670050610201300414', '816119136')
	, (5, '02860937050101300769', '813936419') -- presidente
	, (6, '02860937050101300769', '813936419')
	, (5, '30670050610501300414', '824181013') -- nelore
	, (6, '30670050610501300414', '824181013')
	, (5, '30670056278801300424', '1557318529') -- vereda verde
	, (6, '30670056278801300424', '1557318529');

-- ==============================================
-- LAYOUT: retorno_cartao_bradesco
-- ==============================================
INSERT INTO public.leiaute_arquivo (
	denominacao
	, tipo_arquivo
	, quantidade_caracteres
	, extensao_arquivo
	, versao_leiaute
) 
SELECT 'retorno_cartao_bradesco', 2, 400, 1, 'V1'
WHERE NOT EXISTS (
	SELECT 1 FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2
);

INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo
	, posicao_inicial
	, tamanho
	, tipo_valor
	, preenchimento
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
	, grupo
) VALUES
	-- TIPO 0 (Header)
	('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 1, 1, 2, 2, FALSE, '0', NULL, 'codigo_registro', 'geral')
	, ('Codigo do Estabelecimento / Convenio', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 2, 18, 2, 2, TRUE, NULL, NULL, 'codigo_estabelecimento', 'geral')
	, ('Nome do Beneficiario / Empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 74, 60, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario', 'geral')
	, ('Data de Geracao do Arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 134, 8, 2, 2, FALSE, NULL, NULL, 'data_geracao_arquivo', 'geral')
	, ('Data de Referencia do Movimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 142, 8, 2, 2, FALSE, NULL, NULL, 'data_referencia_movimento', 'geral')
	, ('Sequencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 150, 4, 1, 3, FALSE, NULL, NULL, 'sequencia', 'geral')
	, ('Codigo do Adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 154, 7, 2, 2, FALSE, NULL, NULL, 'codigo_adquirente', 'geral')
	, ('CNPJ do Adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 161, 15, 2, 2, FALSE, NULL, NULL, 'cnpj_adquirente', 'geral')
	, ('Data Criacao Arquivo / Vencimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 176, 8, 2, 2, FALSE, NULL, NULL, 'data_criacao_arquivo', 'geral')
	, ('Hora Criacao Arquivo / Fechamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 184, 8, 2, 2, FALSE, NULL, NULL, 'hora_criacao_arquivo', 'geral')
	, ('Versao Layout / Abertura', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 192, 8, 2, 2, FALSE, NULL, NULL, 'versao_layout', 'geral')
	, ('Reservado para Uso Futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 1, 200, 15, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')

	-- TIPO 2 (Movimento - Transacoes - Destino: movimento_cartao_retorno_bradesco)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 1, 1, 2, 2, FALSE, '2', NULL, 'codigo_registro', 'cartao_bradesco')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 2, 18, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'cartao_bradesco')
	, ('Numero do Cartao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 21, 16, 2, 2, FALSE, NULL, NULL, 'numero_cartao', 'cartao_bradesco')
	, ('Numero de Parcelas', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 37, 3, 1, 3, FALSE, NULL, NULL, 'numero_parcelas', 'cartao_bradesco')
	, ('NSU do adquirente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 40, 23, 2, 2, FALSE, NULL, NULL, 'nsu_adquirente', 'cartao_bradesco')
	, ('Data da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 63, 12, 2, 2, FALSE, NULL, NULL, 'data_transacao', 'cartao_bradesco')
	, ('Valor da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 75, 18, 2, 2, FALSE, NULL, NULL, 'valor_transacao', 'cartao_bradesco')
	, ('Valor da Parcela / Faturado', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 93, 15, 2, 2, FALSE, NULL, NULL, 'valor_faturado', 'cartao_bradesco')
	, ('Data do Pagamento / Vencimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 108, 8, 2, 2, FALSE, NULL, NULL, 'data_pagamento', 'cartao_bradesco')
	, ('Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 116, 3, 2, 2, FALSE, NULL, NULL, 'moeda', 'cartao_bradesco')
	, ('Localidade / Cidade do Estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 119, 15, 2, 2, FALSE, NULL, NULL, 'cidade_estabelecimento', 'cartao_bradesco')
	, ('Nome do Estabelecimento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 134, 70, 2, 2, FALSE, NULL, NULL, 'nome_estabelecimento', 'cartao_bradesco')
	, ('MCC', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 204, 5, 2, 2, FALSE, NULL, NULL, 'mcc', 'cartao_bradesco')
	, ('MCC Categoria', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 209, 32, 2, 2, FALSE, NULL, NULL, 'categoria_mcc', 'cartao_bradesco')
	, ('Simbolo Moeda', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 241, 2, 2, 2, FALSE, NULL, NULL, 'simbolo_moeda', 'cartao_bradesco')
	, ('Sinal da transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 243, 1, 2, 2, FALSE, NULL, NULL, 'sinal_transacao', 'cartao_bradesco')
	, ('Data do Cambio / Cotacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 244, 8, 2, 2, FALSE, NULL, NULL, 'data_cotacao', 'cartao_bradesco')
	, ('Taxa de Conversao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 252, 4, 2, 2, FALSE, NULL, NULL, 'taxa_conversao', 'cartao_bradesco')
	, ('Reservado para o futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 256, 10, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'cartao_bradesco')
	, ('Valor Convertido BRL', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 266, 4, 2, 2, FALSE, NULL, NULL, 'valor_reais', 'cartao_bradesco')
	, ('Pais da Transacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 376, 3, 2, 2, FALSE, NULL, NULL, 'pais_transacao', 'cartao_bradesco')
	, ('Registro de Postagem', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 3, 379, 18, 2, 2, FALSE, NULL, NULL, 'registro_postagem', 'cartao_bradesco')

	-- TIPO 9 (Trailer - Totais)
	, ('Tipo de Registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 5, 1, 1, 2, 2, FALSE, '9', NULL, 'codigo_registro', 'geral')
	, ('Quantidade de Registros / Cartoes', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 5, 63, 7, 1, 3, FALSE, NULL, NULL, 'quantidade_registros', 'geral')
	, ('Reservado para uso futuro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1), 5, 138, 263, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;

INSERT INTO public.parametro_leiaute_arquivo (
	id_leiaute_arquivo
	, codigo
	, id_empresa
)
SELECT 
	(SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1)
	, 'C-0041090635000104'
	, 841505212
WHERE NOT EXISTS (
	SELECT 1 FROM public.parametro_leiaute_arquivo 
	WHERE id_leiaute_arquivo = (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1)
	  AND codigo = 'C-0041090635000104'
);

INSERT INTO public.parametro_leiaute_arquivo (
	id_leiaute_arquivo
	, codigo
	, id_empresa
)
SELECT 
	(SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1)
	, 'C-0003951672000170'
	, 104429567
WHERE NOT EXISTS (
	SELECT 1 FROM public.parametro_leiaute_arquivo 
	WHERE id_leiaute_arquivo = (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1)
	  AND codigo = 'C-0003951672000170'
);