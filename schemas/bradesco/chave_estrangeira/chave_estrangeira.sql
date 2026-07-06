-- =================================================================================
-- SCHEMA BRADESCO: CHAVES ESTRANGEIRAS
-- =================================================================================

-- 1. LEIAUTE CAMPO ARQUIVO -> LEIAUTE ARQUIVO
ALTER TABLE bradesco.leiaute_campo_arquivo
	DROP CONSTRAINT IF EXISTS fk_bradesco_leiaute_campo_arquivo_leiaute_arquivo;

ALTER TABLE bradesco.leiaute_campo_arquivo
	ADD CONSTRAINT fk_bradesco_leiaute_campo_arquivo_leiaute_arquivo
	FOREIGN KEY (id_leiaute_arquivo)
	REFERENCES bradesco.leiaute_arquivo (id);

-- 2. PARÂMETRO LEIAUTE ARQUIVO -> LEIAUTE ARQUIVO
ALTER TABLE bradesco.parametro_leiaute_arquivo
	DROP CONSTRAINT IF EXISTS fk_bradesco_parametro_leiaute_arquivo_leiaute_arquivo;

ALTER TABLE bradesco.parametro_leiaute_arquivo
	ADD CONSTRAINT fk_bradesco_parametro_leiaute_arquivo_leiaute_arquivo
	FOREIGN KEY (id_leiaute_arquivo)
	REFERENCES bradesco.leiaute_arquivo (id);

-- 3. HEADER ARQUIVO -> REGISTRO ARQUIVO
ALTER TABLE bradesco.cartao_credito_header_arquivo
	DROP CONSTRAINT IF EXISTS fk_cartao_credito_header_arquivo_registro_arquivo;

ALTER TABLE bradesco.cartao_credito_header_arquivo
	ADD CONSTRAINT fk_cartao_credito_header_arquivo_registro_arquivo
	FOREIGN KEY (id_arquivo, numero_linha)
	REFERENCES public.registro_arquivo (id_arquivo, numero_linha);

-- 4. DETALHE PORTADOR -> REGISTRO ARQUIVO
ALTER TABLE bradesco.cartao_credito_detalhe_portador
	DROP CONSTRAINT IF EXISTS fk_cartao_credito_detalhe_portador_registro_arquivo;

ALTER TABLE bradesco.cartao_credito_detalhe_portador
	ADD CONSTRAINT fk_cartao_credito_detalhe_portador_registro_arquivo
	FOREIGN KEY (id_arquivo, numero_linha)
	REFERENCES public.registro_arquivo (id_arquivo, numero_linha);

-- 5. MOVIMENTO ARQUIVO -> REGISTRO ARQUIVO
ALTER TABLE bradesco.cartao_credito_movimento_arquivo
	DROP CONSTRAINT IF EXISTS fk_cartao_credito_movimento_arquivo_registro_arquivo;

ALTER TABLE bradesco.cartao_credito_movimento_arquivo
	ADD CONSTRAINT fk_cartao_credito_movimento_arquivo_registro_arquivo
	FOREIGN KEY (id_arquivo, numero_linha)
	REFERENCES public.registro_arquivo (id_arquivo, numero_linha);

-- 6. TRAILER ARQUIVO -> REGISTRO ARQUIVO
ALTER TABLE bradesco.cartao_credito_trailer_arquivo
	DROP CONSTRAINT IF EXISTS fk_cartao_credito_trailer_arquivo_registro_arquivo;

ALTER TABLE bradesco.cartao_credito_trailer_arquivo
	ADD CONSTRAINT fk_cartao_credito_trailer_arquivo_registro_arquivo
	FOREIGN KEY (id_arquivo, numero_linha)
	REFERENCES public.registro_arquivo (id_arquivo, numero_linha);
