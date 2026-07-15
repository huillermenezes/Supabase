DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao_tamanho();

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao_tamanho()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	-- Identifica leiautes cujo quantidade_caracteres bate com o tamanho da linha do header.
	-- Lista vazia = nenhum leiaute compatível → erro.
	-- Filtro: mensagem_erro IS NULL AND conteudo_jsonb IS NULL = ainda não processado.
	FOR VRecord IN
		SELECT
			ra.id AS id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, LENGTH(ra.linha_arquivo) AS tamanho_linha
			, (
				SELECT ARRAY_AGG(la.id)
				FROM public.leiaute_arquivo la
				WHERE la.registro_ativo = TRUE
				AND la.quantidade_caracteres = LENGTH(ra.linha_arquivo)
			) AS lista_id_leiaute_arquivo
		FROM public.registro_arquivo ra
		WHERE ra.numero_linha = 1
		  AND ra.mensagem_erro IS NULL   -- sem erro registrado
		  AND ra.conteudo_jsonb IS NULL  -- ainda não processado
		ORDER BY ra.id_arquivo ASC
		LIMIT 300
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_id_leiaute_arquivo), 0) = 0 THEN
			-- Registra o erro na linha 1 do arquivo
			UPDATE	public.registro_arquivo
			SET	mensagem_erro = CONCAT('Nenhum leiaute encontrado para tamanho ', VRecord.tamanho_linha, '.')
			WHERE	id = VRecord.id_registro_arquivo;
		ELSE 
			-- Registra a lista de leiautes encontrados e limpa mensagens de erro
			UPDATE public.registro_arquivo
			SET conteudo_jsonb = jsonb_build_object('lista_id_leiaute_arquivo', VRecord.lista_id_leiaute_arquivo)
				, mensagem_erro =  NULL
			WHERE id = VRecord.id_registro_arquivo;
		END IF;
	END LOOP;
END;
$$;
