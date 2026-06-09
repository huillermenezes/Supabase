INSERT INTO public.leiaute_arquivo (
	denominacao
	, tipo_arquivo
	, quantidade_caracteres
	, extensao_arquivo
	, versao_leiaute
)
VALUES
	('folha_pagamento_bradesco_240_posicoes', 1, 240, 2, 'VERSÃO 8.0 DE 31/08/2004');

INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial
	, tamanho
	, tipo_valor -- 1 = numerico, 2 = texto
	, preenchimento -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, campo_identificacao
	, valor_padrao
)
VALUES
		-- HEADER ARQUIVO
	('codigo do banco na compensacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 1, 3, 1, NULL, FALSE, '237')
	, ('lote de servico', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 4, 4, 1, NULL, FALSE, '0000')
	, ('tipo de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 8, 1, 1, NULL, FALSE, '0')
	, ('uso exclusivo febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 9, 9, 2, NULL, FALSE, '         ')
	, ('tipo de inscricao da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 18, 1, 1, NULL, FALSE, '2')
	, ('numero de inscricao da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 19, 14, 1, 3, FALSE, NULL)
	, ('codigo do convenio', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 33, 20, 2, 2, TRUE, NULL)
	, ('agencia mantenedora da conta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 53, 5, 1, 3, FALSE, NULL)
	, ('digito verificador da agencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 58, 1, 2, NULL, FALSE, NULL)
	, ('numero da conta corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 59, 12, 1, 3, FALSE, NULL)
	, ('digito verificador da conta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 71, 1, 2, NULL, FALSE, NULL)
	, ('digito verificador da agencia conta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 72, 1, 2, NULL, FALSE, NULL)
	, ('nome da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 73, 30, 2, 2, FALSE, NULL)
	, ('nome do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 103, 30, 2, 2, FALSE, 'BANCO BRADESCO                ')
	, ('uso exclusivo febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 133, 10, 2, NULL, FALSE, '          ')
	, ('arquivo codigo codigo remessa / retorno', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 143, 1, 1, NULL, FALSE, NULL)
	, ('data de geracao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 144, 8, 1, NULL, FALSE, NULL)
	, ('hora de geracao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 152, 6, 1, NULL, FALSE, NULL)
	, ('numero sequencial do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 158, 6, 1, 3, FALSE, NULL)
	, ('versao do layout do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 164, 3, 1, 3, FALSE, '080')
	, ('densidade de gravacao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 167, 5, 1, 3, FALSE, NULL)
	, ('para uso reservado do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 172, 20, 2, NULL, FALSE, '                    ')
	, ('para uso reservado da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 192, 20, 2, NULL, FALSE, '                    ')
	, ('uso exclusivo febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 212, 29, 2, NULL, FALSE, '                             ');
		--HEADER LOTE
		/*
	('codigo do banco na compensacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 1, 3, 1, NULL, FALSE, '237')
	, ('lote de servico', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 4, 4, 1, NULL, FALSE, NULL)
	, ('tipo de registro', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 8, 1, 1, NULL, FALSE, '1')
	, ('tipo da operacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 9, 1, 2, NULL, FALSE, 'C')
	, ('tipo ddo servico', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 10, 2, 1, NULL, FALSE, NULL)
	, ('forma de lancamento', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 12, 2, 1, NULL, FALSE, NULL)
	, ('n da versao do layout do lote', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 14, 3, 1, NULL, FALSE, '040')
	, ('uso exclusivo da febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 17, 1, 2, NULL, FALSE, ' ')
	, ('tipo de inscricao da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 18, 1, 1, NULL, FALSE, NULL)
	, ('numero de inscricao da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 19, 14, 1, 3, FALSE, NULL)
	, ('codigo do convenio no banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 33, 20, 2, NULL, FALSE, NULL)
	, ('agencia mantenedora da conta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 53, 5, 1, 3, FALSE, NULL)
	, ('digito verificador da agencia', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 58, 1, 2, NULL, FALSE, NULL)
	, ('numero conta corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 59, 12, 1, 3, FALSE, NULL)
	, ('digito verificador da conta corrente', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 71, 1, 2, NULL, FALSE, NULL)
	, ('digito verificador da agencia/conta', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 72, 1, 2, NULL, FALSE, NULL)
	, ('nome da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 73, 30, 2, 2, FALSE, NULL)
	, ('mensagem', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 103, 40, 2, NULL, FALSE, NULL)
	, ('nome da rua, av, pca, etc', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 143, 30, 2, 2, FALSE, NULL)
--	, ('versao do layout do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 164, 3, 1, 3, FALSE, '080')
--	, ('densidade de gravacao do arquivo', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 167, 5, 1, 3, FALSE, NULL)
--	, ('para uso reservado do banco', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 172, 20, 2, NULL, FALSE, '                    ')
--	, ('para uso reservado da empresa', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 192, 20, 2, NULL, FALSE, '                    ')
--	, ('uso exclusivo febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 212, 29, 2, NULL, FALSE, '                             ');*/

INSERT INTO parametro_leiaute_arquivo(
	id_leiaute_arquivo
	, codigo
) VALUES
	((SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1);

/*INSERT INTO public.leiaute_arquivo (denominacao, tipo_arquivo, quantidade_caracteres, extensao_arquivo, versao_leiaute)
VALUES
	('folha_pagamento_240_posicoes', 1, 240, 2, '')
	, ('cobranca', 1, 400, 2, '')
	, ('multipag', 1, 240, 2, '');

INSERT INTO public.leiaute_campo_arquivo (id_leiaute_arquivo, tipo_campo, posicao_inicial, tamanho, tipo_valor, denominacao, campo_identificacao)
VALUES
	-- folha_pagamento_240_posicoes
	(1, 1, 001, 003, 1, 'codigo do banco -- g001', FALSE)
	, (1, 1, 004, 004, 1, 'lote de servico -- "0000" *g002', FALSE)
	, (1, 1, 008, 001, 1, 'tipo de registro -- "0" *g003', FALSE)
	, (1, 1, 009, 009, 2, 'uso exclusivo febraban -- brancos g004', FALSE)
	, (1, 1, 018, 001, 1, 'tipo de inscricao da empresa -- *g005', FALSE)
	, (1, 1, 019, 014, 1, 'numero de inscricao da empresa -- *g006', TRUE)
	, (1, 1, 033, 020, 2, 'codigo do convenio -- *g007', FALSE)
	, (1, 1, 053, 005, 1, 'conta corrente agencia codigo agencia mantenedora da conta -- *g008', FALSE)
	, (1, 1, 058, 001, 2, 'digito verificador da agencia -- *g009', FALSE)
	, (1, 1, 059, 012, 1, 'conta numero numero da conta corrente -- *g010', FALSE)
	, (1, 1, 071, 001, 2, 'digito verificador da conta -- *g011', FALSE)
	, (1, 1, 072, 001, 2, 'digito verificador da agencia conta -- *g012', FALSE)
	, (1, 1, 073, 030, 2, 'nome nome da empresa -- g013', FALSE)
	, (1, 1, 103, 030, 2, 'nome do banco nome do banco -- g014', FALSE)
	, (1, 1, 133, 010, 2, 'uso exclusivo febraban -- brancos g004', FALSE)
	, (1, 1, 143, 001, 1, 'arquivo codigo codigo remessa / retorno -- g015', FALSE)
	, (1, 1, 144, 008, 1, 'data de geracao do arquivo -- g016', FALSE)
	, (1, 1, 152, 006, 1, 'hora de geracao do arquivo -- g017', FALSE)
	, (1, 1, 158, 006, 1, 'numero sequencial do arquivo -- *g018', FALSE)
	, (1, 1, 164, 003, 1, 'versao do layout do arquivo -- "080" *g019', FALSE)
	, (1, 1, 167, 005, 1, 'densidade de gravacao do arquivo -- g020', FALSE)
	, (1, 1, 172, 020, 2, 'para uso reservado do banco -- g021', FALSE)
	, (1, 1, 192, 020, 2, 'para uso reservado da empresa -- g022', FALSE)
	, (1, 1, 212, 029, 2, 'uso exclusivo febraban -- brancos g004', FALSE)
	-- cobranca
	, (2, 1, 001, 001, 1, 'tipo de registro -- 0', FALSE)
	, (2, 1, 002, 001, 1, 'identificacao do arquivo-remessa -- 1', FALSE)
	, (2, 1, 003, 007, 1, 'literal remessa -- remessa', FALSE)
	, (2, 1, 010, 002, 1, 'codigo de servico -- 01', FALSE)
	, (2, 1, 012, 015, 1, 'literal servico -- cobranca', FALSE)
	, (2, 1, 027, 020, 1, 'codigo do convenio -- será fornecido pelo bradesco, quando do cadastramento', TRUE)
	, (2, 1, 047, 030, 1, 'nome da empresa -- razao social', FALSE)
	, (2, 1, 077, 003, 1, 'codigo do banco -- 237', FALSE)
	, (2, 1, 080, 015, 1, 'nome do banco -- bradesco', FALSE)
	, (2, 1, 095, 006, 1, 'data da gravacao do arquivo -- ddmmaa', FALSE)
	, (2, 1, 101, 008, 1, 'branco -- branco', FALSE)
	, (2, 1, 109, 002, 1, 'identificacao do sistema -- mx', FALSE)
	, (2, 1, 111, 007, 1, 'numero sequencial do arquivo -- sequencial', FALSE)
	, (2, 1, 118, 277, 1, 'branco -- branco', FALSE)
	, (2, 1, 395, 006, 1, 'numero sequencial do registro de um em um -- 000001', FALSE)
	-- multipag
	, (3, 1, 001, 003, 1, 'codigo do banco -- g001', FALSE)
	, (3, 1, 004, 004, 1, 'lote de servico -- "0000" *g002', FALSE)
	, (3, 1, 008, 001, 1, 'tipo de registro -- "0" *g003', FALSE)
	, (3, 1, 009, 009, 2, 'uso exclusivo febraban -- brancos g004', FALSE)
	, (3, 1, 018, 001, 1, 'tipo de inscricao da empresa -- *g005', FALSE)
	, (3, 1, 019, 014, 1, 'numero de inscricao da empresa -- *g006', TRUE)
	, (3, 1, 033, 020, 2, 'codigo do convenio -- *g007', FALSE)
	, (3, 1, 053, 005, 1, 'conta corrente agencia codigo agencia mantenedora da conta -- *g008', FALSE)
	, (3, 1, 058, 001, 2, 'digito verificador da agencia -- *g009', FALSE)
	, (3, 1, 059, 012, 1, 'conta numero numero da conta corrente -- *g010', FALSE)
	, (3, 1, 071, 001, 2, 'digito verificador da conta -- *g011', FALSE)
	, (3, 1, 072, 001, 2, 'digito verificador da agencia conta -- *g012', FALSE)
	, (3, 1, 073, 030, 2, 'nome nome da empresa -- g013', FALSE)
	, (3, 1, 103, 030, 2, 'nome do banco nome do banco -- g014', FALSE)
	, (3, 1, 133, 010, 2, 'uso exclusivo febraban -- brancos g004', FALSE)
	, (3, 1, 143, 001, 1, 'arquivo codigo codigo remessa / retorno -- g015', FALSE)
	, (3, 1, 144, 008, 1, 'data de geracao do arquivo -- g016', FALSE)
	, (3, 1, 152, 006, 1, 'hora de geracao do arquivo -- g017', FALSE)
	, (3, 1, 158, 006, 1, 'numero sequencial do arquivo -- *g018', FALSE)
	, (3, 1, 164, 003, 1, 'versao do layout do arquivo -- "089" *g019', FALSE)
	, (3, 1, 167, 005, 1, 'densidade de gravacao do arquivo -- g020', FALSE)
	, (3, 1, 172, 020, 2, 'para uso reservado do banco -- g021', FALSE)
	, (3, 1, 192, 020, 2, 'para uso reservado da empresa -- g022', FALSE)
	, (3, 1, 212, 029, 2, 'uso exclusivo febraban -- brancos g004', FALSE);

*/


INSERT INTO public.leiaute_arquivo (
	denominacao
	, tipo_arquivo
	, quantidade_caracteres
	, extensao_arquivo
	, versao_leiaute
)VALUES
	('cobranca_remessa', 1, 400, 2, 'V 2.37 Fev/2026');

INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial
	, tamanho
	, tipo_valor -- 1 = numerico, 2 = texto
	, preenchimento -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
) VALUES
	('Código do Registro', 1, 1, 001, 001, 1, NULL, FALSE, '0', NULL, 'codigo_registro')
	, ('Código da Remessa', 1, 1, 002, 001, 1, NULL, FALSE, '1', NULL, 'codigo_remessa')
	, ('Literal de Transmissão', 1, 1, 003, 007, 2, NULL, FALSE, 'REMESSA', NULL, 'literal_transmissao')
	, ('Código do Tipo Serviço ', 1, 1, 010, 002, 1, NULL, FALSE, '01', NULL, 'codigo_tipo_servico')
	, ('Literal de Serviço', 1, 1, 012, 015, 2, NULL, FALSE, 'COBRANCA       ', NULL, 'literal_servico')
	, ('Código de Transmissão', 1, 1, 027, 020, 1, 4, TRUE, NULL, NULL, 'codigo_transmissao')
	, ('Nome do Beneficiário', 1, 1, 047, 030, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario')
	, ('Código do Banco', 1, 1, 077, 003, 1, NULL, FALSE, '033', NULL, 'codigo_banco')
	, ('Nome do Banco', 1, 1, 080, 015, 2, NULL, FALSE, 'BANCO SANTANDER', NULL, 'nome_banco')
	, ('Data da Gravação do Arquivo', 1, 1, 095, 006, 1, NULL, FALSE, NULL, NULL, 'data_geracao_arquivo')
	, ('Reservado (uso Banco) ', 1, 1, 101, 016, 1, NULL, FALSE, '0000000000000000', NULL, 'reservado_banco_1')
	, ('Mensagem 1', 1, 1, 117, 047, 2, 2, FALSE, NULL, NULL, 'mensagem_1')
	, ('Mensagem 2', 1, 1, 164, 047, 2, 2, FALSE, NULL, NULL, 'mensagem_2')
	, ('Mensagem 3', 1, 1, 211, 047, 2, 2, FALSE, NULL, NULL, 'mensagem_3')
	, ('Mensagem 4', 1, 1, 258, 047, 2, 2, FALSE, NULL, NULL, 'mensagem_4')
	, ('Mensagem 5', 1, 1, 305, 047, 2, 2, FALSE, NULL, NULL, 'mensagem_5')
	, ('Reservado (uso Banco)', 1, 1, 352, 034, 2, 2, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Reservado (uso Banco)', 1, 1, 386, 006, 2, 2, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Nº sequencial do arquivo', 1, 1, 392, 003, 1, NULL, FALSE, NULL, NULL, 'numero_sequencial_arquivo')
	, ('Nº sequencial do registro no arquivo ', 1, 1, 395, 006, 1, 3, FALSE, '000001', NULL, 'numero_sequencial_registro');

INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo -- 1 = Header Arquivo, 2 = Header Lote, 3 = Movimento, 4 = Trailer Lote, 5 = Trailer Arquivo
	, posicao_inicial
	, tamanho
	, tipo_valor -- 1 = numerico, 2 = texto
	, preenchimento -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
) VALUES
	('Código do Registro', 1, 3, 1, 1, 1, NULL, FALSE, '1', NULL, 'codigo_registro')
	, ('Tipo de inscrição do beneficiário', 1, 3, 2, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_beneficiario')
	, ('Inscrição do beneficiário', 1, 3, 4, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_beneficiario')
	, ('Código da agência beneficiária', 1, 3, 18, 4, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_beneficiaria')
	, ('Conta movimento beneficiário', 1, 3, 22, 8, 1, NULL, FALSE, NULL, NULL, 'conta_movimento_beneficiario')
	, ('Conta cobrança beneficiário', 1, 3, 30, 8, 1, NULL, FALSE, NULL, NULL, 'conta_cobranca_beneficiario')
	, ('Identificação do boleto na empresa', 1, 3, 38, 25, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_empresa')
	, ('Identificação do boleto no banco', 1, 3, 63, 8, 1, NULL, FALSE, NULL, NULL, 'nosso_numero')
	, ('Data do desconto 2', 1, 3, 71, 6, 1, NULL, FALSE, NULL, NULL, 'data_desconto_2')
	, ('Reservado (uso banco)', 1, 3, 77, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_1')
	, ('Código de Multa', 1, 3, 78, 1, 1, NULL, FALSE, NULL, NULL, 'codigo_multa')
	, ('Percentual de Multa', 1, 3, 79, 4, 1, NULL, FALSE, NULL, NULL, 'percentual_multa')
	, ('Código da Moeda', 1, 3, 83, 2, 1, NULL, FALSE, '00', NULL, 'codigo_moeda')
	, ('Valor do boleto em outra unidade', 1, 3, 85, 13, 1, NULL, FALSE, NULL, NULL, 'valor_boleto_outra_unidade')
	, ('Reservado (uso banco)', 1, 3, 98, 4, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_2')
	, ('Data da Multa', 1, 3, 102, 6, 1, NULL, FALSE, NULL, NULL, 'data_multa')
	, ('Tipo de Cobrança', 1, 3, 108, 1, 1, NULL, FALSE, NULL, NULL, 'tipo_cobranca')
	, ('Código de movimento remessa', 1, 3, 109, 2, 1, NULL, FALSE, NULL, NULL, 'codigo_movimento_remessa')
	, ('Nº do documento', 1, 3, 111, 10, 2, NULL, FALSE, NULL, NULL, 'numero_documento')
	, ('Data de vencimento do boleto', 1, 3, 121, 6, 1, NULL, FALSE, NULL, NULL, 'data_vencimento_boleto')
	, ('Valor nominal do boleto', 1, 3, 127, 13, 1, NULL, FALSE, NULL, NULL, 'valor_nominal_boleto')
	, ('Número do banco cobrador', 1, 3, 140, 3, 1, NULL, FALSE, '033', NULL, 'numero_banco_cobrador')
	, ('Código agência Cobradora', 1, 3, 143, 5, 1, NULL, FALSE, NULL, NULL, 'codigo_agencia_cobradora')
	, ('Espécie do boleto', 1, 3, 148, 2, 1, NULL, FALSE, NULL, NULL, 'especie_boleto')
	, ('Identificação boleto aceite / não aceite', 1, 3, 150, 1, 2, NULL, FALSE, NULL, NULL, 'identificacao_boleto_aceite')
	, ('Data de emissão do boleto', 1, 3, 151, 6, 1, NULL, FALSE, NULL, NULL, 'data_emissao_boleto')
	, ('Primeira instrução', 1, 3, 157, 2, 1, NULL, FALSE, NULL, NULL, 'primeira_instrucao')
	, ('Segunda instrução', 1, 3, 159, 2, 1, NULL, FALSE, NULL, NULL, 'segunda_instrucao')
	, ('Valor de Mora dia', 1, 3, 161, 13, 1, NULL, FALSE, NULL, NULL, 'valor_mora_dia')
	, ('Data Limite para concessão do desconto', 1, 3, 174, 6, 1, NULL, FALSE, NULL, NULL, 'data_limite_desconto')
	, ('Valor do desconto a ser concedido', 1, 3, 180, 13, 1, NULL, FALSE, NULL, NULL, 'valor_desconto')
	, ('Percentual do IOF a ser recolhido', 1, 3, 193, 13, 1, NULL, FALSE, NULL, NULL, 'percentual_iof')
	, ('Valor do abatimento ou Valor do segundo desconto', 1, 3, 206, 13, 1, NULL, FALSE, NULL, NULL, 'valor_abatimento')
	, ('Tipo de inscrição do Pagador', 1, 3, 219, 2, 1, NULL, FALSE, NULL, NULL, 'tipo_inscricao_pagador')
	, ('Inscrição do Pagador', 1, 3, 221, 14, 2, NULL, FALSE, NULL, NULL, 'inscricao_pagador')
	, ('Nome do Pagador', 1, 3, 235, 40, 2, NULL, FALSE, NULL, NULL, 'nome_pagador')
	, ('Endereço do Pagador', 1, 3, 275, 40, 2, NULL, FALSE, NULL, NULL, 'endereco_pagador')
	, ('Bairro do Pagador', 1, 3, 315, 12, 2, NULL, FALSE, NULL, NULL, 'bairro_pagador')
	, ('Cep do Pagador', 1, 3, 327, 5, 1, NULL, FALSE, NULL, NULL, 'cep_pagador')
	, ('Sufixo do Cep do Pagador', 1, 3, 332, 3, 1, NULL, FALSE, NULL, NULL, 'sufixo_cep_pagador')
	, ('Cidade do Pagador', 1, 3, 335, 15, 2, NULL, FALSE, NULL, NULL, 'cidade_pagador')
	, ('Unidade de Federação do Pagador', 1, 3, 350, 2, 2, NULL, FALSE, NULL, NULL, 'uf_pagador')
	, ('Reservado (uso banco)', 1, 3, 352, 30, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_3')
	, ('Reservado (uso banco)', 1, 3, 382, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_4')
	, ('Identificador do complemento', 1, 3, 383, 1, 2, NULL, FALSE, NULL, NULL, 'identificador_complemento')
	, ('Complemento', 1, 3, 384, 2, 1, NULL, FALSE, NULL, NULL, 'complemento')
	, ('Reservado (uso banco)', 1, 3, 386, 6, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_5')
	, ('Número de dias corridos para Protesto', 1, 3, 392, 2, 1, NULL, FALSE, NULL, NULL, 'numero_dias_protesto')
	, ('Reservado (uso banco)', 1, 3, 394, 1, 2, NULL, FALSE, NULL, NULL, 'reservado_banco_6')
	, ('Número sequencial do registro no arquivo', 1, 3, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro');

INSERT INTO public.leiaute_campo_arquivo (
	denominacao
	, id_leiaute_arquivo
	, tipo_campo -- 5 = Trailer Arquivo
	, posicao_inicial
	, tamanho
	, tipo_valor -- 1 = numerico, 2 = texto
	, preenchimento -- 1 = brancos a esquerda, 2 = brancos a direita, 3 = zeros a esquerda, 4 = zeros a direita
	, campo_identificacao
	, valor_padrao
	, expressao_valor
	, nome_coluna
) VALUES
	('Código do Registro', 1, 5, 1, 1, 1, NULL, FALSE, '9', NULL, 'codigo_registro')
	, ('Quantidade de registros', 1, 5, 2, 6, 1, NULL, FALSE, NULL, NULL, 'quantidade_registros')
	, ('Valor Total dos boletos', 1, 5, 8, 13, 1, NULL, FALSE, NULL, NULL, 'valor_total_boletos')
	, ('Reservado (uso banco)', 1, 5, 21, 374, 1, NULL, FALSE, NULL, NULL, 'reservado_banco')
	, ('Número sequencial de registro no arquivo', 1, 5, 395, 6, 1, 3, FALSE, NULL, NULL, 'numero_sequencial_registro');



-- 01REMESSA01COBRANCA       30670054971201300421POSTO DU FIGUEIREDO II LTDA   033BANCO SANTANDER0508250000000000000000                                                                                                                                                                                                                                                                                   093000001