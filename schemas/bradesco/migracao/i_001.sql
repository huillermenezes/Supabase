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
	, ('Nome do Beneficiario / Empresa', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 74, 59, 2, 2, FALSE, NULL, NULL, 'nome_beneficiario', 'geral')
	, ('Data de Geracao do Arquivo', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 133, 8, 2, 2, FALSE, NULL, NULL, 'data_geracao_arquivo', 'geral')
	, ('Data de Referencia do Movimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 141, 8, 2, 2, FALSE, NULL, NULL, 'data_referencia_movimento', 'geral')
	, ('Sequencia', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 149, 4, 1, 3, FALSE, NULL, NULL, 'sequencia', 'geral')
	, ('Codigo do Adquirente', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 154, 7, 2, 2, FALSE, NULL, NULL, 'codigo_adquirente', 'geral')
	, ('CNPJ do Estabelecimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 161, 14, 2, 2, TRUE, NULL, NULL, 'cnpj_estabelecimento', 'geral')
	, ('Data Criacao Arquivo / Vencimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 176, 8, 2, 2, FALSE, NULL, NULL, 'data_criacao_arquivo', 'geral')
	, ('Hora Criacao Arquivo / Fechamento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 184, 8, 2, 2, FALSE, NULL, NULL, 'hora_criacao_arquivo', 'geral')
	, ('Versao Layout / Abertura', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 192, 8, 2, 2, FALSE, NULL, NULL, 'versao_layout', 'geral')
	, ('Reservado para Uso Futuro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 1, 200, 15, 2, 2, FALSE, NULL, NULL, 'reservado_futuro', 'geral')

	-- TIPO 1 (Detalhe Portador)
	, ('Tipo de Registro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 1, 1, 2, 2, FALSE, '1', NULL, 'codigo_registro', 'geral')
	, ('Codigo do estabelecimento', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 2, 18, 2, 2, FALSE, NULL, NULL, 'codigo_estabelecimento', 'geral')
	, ('Numero do Cartao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 21, 16, 2, 2, FALSE, NULL, NULL, 'numero_cartao', 'geral')
	, ('Nome do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 63, 30, 2, 2, FALSE, NULL, NULL, 'nome_portador', 'geral')
	, ('Endereco do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 93, 40, 2, 2, FALSE, NULL, NULL, 'endereco_portador', 'geral')
	, ('Numero do Endereco', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 133, 5, 2, 2, FALSE, NULL, NULL, 'numero_endereco', 'geral')
	, ('Bairro do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 138, 15, 2, 2, FALSE, NULL, NULL, 'bairro_portador', 'geral')
	, ('Cidade do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 153, 28, 2, 2, FALSE, NULL, NULL, 'cidade_portador', 'geral')
	, ('UF do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 181, 2, 2, 2, FALSE, NULL, NULL, 'uf_portador', 'geral')
	, ('CEP do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 183, 9, 2, 2, FALSE, NULL, NULL, 'cep_portador', 'geral')
	, ('CPF/CNPJ do Portador', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 2, 192, 19, 2, 2, FALSE, NULL, NULL, 'cpf_cnpj_portador', 'geral')

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
	, ('MCC', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 205, 5, 2, 2, FALSE, NULL, NULL, 'mcc', 'cartao_bradesco')
	, ('MCC Categoria', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 210, 30, 2, 2, FALSE, NULL, NULL, 'categoria_mcc', 'cartao_bradesco')
	, ('Simbolo Moeda', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 240, 3, 2, 2, FALSE, NULL, NULL, 'simbolo_moeda', 'cartao_bradesco')
	, ('Sinal da transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 243, 1, 2, 2, FALSE, NULL, NULL, 'sinal_transacao', 'cartao_bradesco')
	, ('Data do Cambio / Cotacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 244, 8, 2, 2, FALSE, NULL, NULL, 'data_cotacao', 'cartao_bradesco')
	, ('Taxa de Conversao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 252, 4, 2, 2, FALSE, NULL, NULL, 'taxa_conversao', 'cartao_bradesco')
	, ('Valor Convertido BRL', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 256, 15, 2, 2, FALSE, NULL, NULL, 'valor_reais', 'cartao_bradesco')
	, ('Pais da Transacao', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 376, 3, 2, 2, FALSE, NULL, NULL, 'pais_transacao', 'cartao_bradesco')
	, ('Registro de Postagem', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 3, 379, 18, 2, 2, FALSE, NULL, NULL, 'registro_postagem', 'cartao_bradesco')

	-- TIPO 9 (Trailer)
	, ('Tipo de Registro', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 1, 1, 2, 2, FALSE, '9', NULL, 'codigo_registro', 'geral')
	, ('Total Registros Tipo 1', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 63, 7, 1, 3, FALSE, NULL, NULL, 'total_registros_tipo1', 'geral')
	, ('Total Registros Tipo 2', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 70, 7, 1, 3, FALSE, NULL, NULL, 'total_registros_tipo2', 'geral')
	, ('Total Registros Arquivo', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 77, 7, 1, 3, FALSE, NULL, NULL, 'total_registros_arquivo', 'geral')
	, ('Valor Total Transações', (SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2), 5, 86, 15, 2, 2, FALSE, NULL, NULL, 'valor_total_transacoes', 'geral')
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
	SELECT id FROM bradesco.leiaute_arquivo WHERE denominacao = 'retorno_cartao_bradesco' AND tipo_arquivo = 2
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
		('41090635000104', 841505212)
		, ('003951672000170', 104429567)
		, ('029907570000141', 816119136)   -- São Paulo
		, ('057460770000134', 1621110542)  -- Brazlandia
		, ('052802525000144', 1396819091)  -- Orizona
		, ('035257918000103', 1178242677)  -- Simolandia
		, ('031912144000148', 1557318529)  -- Vereda Verde
		, ('046309350000135', 1069817262)  -- Recanto
		, ('029483998000104', 1043634970)  -- Du Figueredo II
		, ('037639036000120', 824181013)   -- Nelore
		, ('043153039000151', 1691876755)  -- Divisão
		, ('044658468000143', 1069832113)  -- Alv de Primavera
		, ('023049249000197', 245604581)   -- Aliança
		, ('052995302000140', 1425814216)  -- Zero Oitenta
		, ('035273451000187', 633516807)   -- Alvorada
		, ('050534195000128', 1295124229)  -- Itiquira
		, ('043288248000102', 1170823392)  -- Correa 020
		, ('001427744000150', 103916199)   -- Sao Bernardo
		, ('041090687000180', 866962735)   -- Conquista
		, ('000641761000122', 816081637)   -- Planaltina
		, ('028932629000199', 824183215)   -- Esplanada
		, ('058114626000109', 1711073617)  -- Vendinha
		, ('55031261000160', 1477536414) -- Caminhoneiro
) AS v(codigo, id_empresa)
WHERE NOT EXISTS (
	SELECT 1 FROM bradesco.parametro_leiaute_arquivo pla
	WHERE pla.id_leiaute_arquivo = l.id
	  AND pla.codigo = v.codigo
);
