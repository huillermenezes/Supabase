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
	('codigo do banco na compensacao', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 1, 1, 3, 1, NULL, TRUE, '237')
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
--	, ('uso exclusivo febraban', (SELECT id FROM public.leiaute_arquivo WHERE denominacao = 'folha_pagamento_bradesco_240_posicoes' AND tipo_arquivo = 1 LIMIT 1), 2, 212, 29, 2, NULL, FALSE, '                             ');

	

INSERT INTO public.leiaute_arquivo (denominacao, tipo_arquivo, quantidade_caracteres, extensao_arquivo, versao_leiaute)
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

