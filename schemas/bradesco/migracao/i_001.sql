-- =================================================================================
-- SCHEMA BRADESCO: INSERTS DE CONFIGURAÇÃO E MAPEAMENTO DE CARTÃO DE CRÉDITO
-- =================================================================================

-- 1. Inserção de Leiaute do Arquivo de Retorno de Cartão Bradesco
INSERT INTO bradesco.leiaute_arquivo (
	denominacao
	, tipo_arquivo
	, quantidade_caracteres
	, extensao_arquivo
	, versao_leiaute
) 
SELECT 'retorno_cartao_bradesco', 2, 400, 1, 'V1'
WHERE NOT EXISTS (
	SELECT 1 FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2
);

-- 2. Mapeamento dos Campos do Leiaute (Header, Detalhe/Movimento e Trailer)
INSERT INTO bradesco.leiaute_campo_arquivo (
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
	('Tipo de Registro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 1, 1, 2, 2, FALSE, '0', NULL, 'codigo_registro', 'geral')
	, ('Codigo do Estabelecimento / Convenio', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 2, 18, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'geral')
	, ('Nome do Beneficiario / Empresa', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 74, 60, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario', 'geral')
	, ('Data de Geracao do Arquivo', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 134, 8, 2, 2, FALSE, NULL, NULL, 'data_geracao_arquivo', 'geral')
	, ('Data de Referencia do Movimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 142, 8, 2, 2, FALSE, NULL, NULL, 'data_referencia_movimento', 'geral')
	, ('Sequencia', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 150, 4, 1, 3, FALSE, NULL, NULL, 'sequencia', 'geral')
	, ('Codigo do Adquirente', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 154, 7, 2, 2, FALSE, NULL, NULL, 'codigo_adquirente', 'geral')
	, ('CNPJ do Estabelecimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 161, 18, 2, 2, TRUE, NULL, NULL, 'cnpj_estabelecimento', 'geral')
	, ('Data Criacao Arquivo / Vencimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 176, 8, 2, 2, FALSE, NULL, NULL, 'data_criacao_arquivo', 'geral')
	, ('Hora Criacao Arquivo / Fechamento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 184, 8, 2, 2, FALSE, NULL, NULL, 'hora_criacao_arquivo', 'geral')
	, ('Versao Layout / Abertura', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 192, 8, 2, 2, FALSE, NULL, NULL, 'versao_layout', 'geral')
	, ('Reservado para Uso Futuro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 200, 15, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')

	-- TIPO 2 (Movimento - Transacoes)
	, ('Tipo de Registro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 1, 1, 2, 2, FALSE, '2', NULL, 'codigo_registro', 'cartao_bradesco')
	, ('Codigo do estabelecimento comercial', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 2, 18, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'cartao_bradesco')
	, ('Numero do Cartao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 21, 16, 2, 2, FALSE, NULL, NULL, 'numero_cartao', 'cartao_bradesco')
	, ('Numero da Parcela relacionada', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 75, 3, 1, 3, FALSE, NULL, NULL, 'numero_parcela_relacionada', 'cartao_bradesco')
	, ('Numero de Parcelas', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 78, 2, 1, 3, FALSE, NULL, NULL, 'numero_parcelas', 'cartao_bradesco')
	, ('NSU do adquirente', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 40, 23, 2, 2, FALSE, NULL, NULL, 'nsu_adquirente', 'cartao_bradesco')
	, ('Data da Transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 63, 12, 2, 2, FALSE, NULL, NULL, 'data_transacao', 'cartao_bradesco')
	, ('Valor da Transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 80, 13, 2, 2, FALSE, NULL, NULL, 'valor_transacao', 'cartao_bradesco')
	, ('Valor da Parcela / Faturado', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 93, 15, 2, 2, FALSE, NULL, NULL, 'valor_faturado', 'cartao_bradesco')
	, ('Data do Pagamento / Vencimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 108, 8, 2, 2, FALSE, NULL, NULL, 'data_pagamento', 'cartao_bradesco')
	, ('Moeda', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 116, 3, 2, 2, FALSE, NULL, NULL, 'moeda', 'cartao_bradesco')
	, ('Localidade / Cidade do Estabelecimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 119, 15, 2, 2, FALSE, NULL, NULL, 'cidade_estabelecimento', 'cartao_bradesco')
	, ('Nome do Estabelecimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 134, 70, 2, 2, FALSE, NULL, NULL, 'nome_estabelecimento', 'cartao_bradesco')
	, ('MCC', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 204, 5, 2, 2, FALSE, NULL, NULL, 'mcc', 'cartao_bradesco')
	, ('MCC Categoria', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 209, 32, 2, 2, FALSE, NULL, NULL, 'categoria_mcc', 'cartao_bradesco')
	, ('Simbolo Moeda', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 241, 2, 2, 2, FALSE, NULL, NULL, 'simbolo_moeda', 'cartao_bradesco')
	, ('Sinal da transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 243, 1, 2, 2, FALSE, NULL, NULL, 'sinal_transacao', 'cartao_bradesco')
	, ('Data do Cambio / Cotacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 244, 8, 2, 2, FALSE, NULL, NULL, 'data_cotacao', 'cartao_bradesco')
	, ('Taxa de Conversao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 252, 4, 2, 2, FALSE, NULL, NULL, 'taxa_conversao', 'cartao_bradesco')
	, ('Reservado para o futuro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 256, 10, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'cartao_bradesco')
	, ('Valor Convertido BRL', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 266, 4, 2, 2, FALSE, NULL, NULL, 'valor_reais', 'cartao_bradesco')
	, ('Pais da Transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 376, 3, 2, 2, FALSE, NULL, NULL, 'pais_transacao', 'cartao_bradesco')
	, ('Registro de Postagem', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 379, 18, 2, 2, FALSE, NULL, NULL, 'registro_postagem', 'cartao_bradesco')

	-- TIPO 9 (Trailer)
	, ('Tipo de Registro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 1, 1, 2, 2, FALSE, '9', NULL, 'codigo_registro', 'geral')
	, ('Quantidade de Registros / Cartoes', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 63, 7, 1, 3, FALSE, NULL, NULL, 'quantidade_registros', 'geral')
	, ('Reservado para uso futuro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 138, 263, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')
ON CONFLICT (id_leiaute_arquivo, tipo_campo, grupo, nome_coluna) DO UPDATE SET
	denominacao = EXCLUDED.denominacao
	, posicao_inicial = EXCLUDED.posicao_inicial
	, tamanho = EXCLUDED.tamanho
	, tipo_valor = EXCLUDED.tipo_valor
	, preenchimento = EXCLUDED.preenchimento
	, campo_identificacao = EXCLUDED.campo_identificacao
	, valor_padrao = EXCLUDED.valor_padrao
	, expressao_valor = EXCLUDED.expressao_valor;

-- 3. Parâmetros do Leiaute (Associação por CNPJ Corrido do Estabelecimento com Empresas)
WITH leiaute AS (
	SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2 LIMIT 1
)
INSERT INTO bradesco.parametro_leiaute_arquivo (
	id_leiaute_arquivo
	, codigo
	, id_empresa
)
SELECT 
	l.id
	, v.codigo
	, v.id_empresa
FROM leiaute l
CROSS JOIN (
	VALUES 
		('041090635000104', 841505212)
		, ('0003951672000170', 104429567)
		, ('0029907570000141', 816119136)   -- São Paulo
		, ('0057460770000134', 1621110542)  -- Brazlandia
		, ('0052802525000144', 1396819091)  -- Orizona
		, ('0035257918000103', 1178242677)  -- Simolandia
		, ('0031912144000148', 1557318529)  -- Vereda Verde
		, ('0046309350000135', 1069817262)  -- Recanto
		, ('0029483998000104', 1043634970)  -- Du Figueredo II
		, ('0037639036000120', 824181013)   -- Nelore
		, ('0043153039000151', 1691876755)  -- Divisão
		, ('0044658468000143', 1069832113)  -- Alv de Primavera
		, ('0023049249000197', 245604581)   -- Aliança
		, ('0052995302000140', 1425814216)  -- Zero Oitenta
		, ('0035273451000187', 633516807)   -- Alvorada
		, ('0050534195000128', 1295124229)  -- Itiquira
		, ('0043288248000102', 1170823392)  -- Correa 020
		, ('0001427744000150', 103916199)   -- Sao Bernardo
		, ('0041090687000180', 866962735)   -- Conquista
		, ('0000641761000122', 816081637)   -- Planaltina
		, ('0028932629000199', 824183215)   -- Esplanada
		, ('0058114626000109', 1711073617)  -- Vendinha
) AS v(codigo, id_empresa)
WHERE NOT EXISTS (
	SELECT 1 FROM bradesco.parametro_leiaute_arquivo pla
	WHERE pla.id_leiaute_arquivo = l.id
	  AND pla.codigo = v.codigo
);
