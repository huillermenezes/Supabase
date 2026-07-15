DROP FUNCTION IF EXISTS public.f_registro_arquivo_set_id_leiaute_arquivo();

CREATE OR REPLACE FUNCTION public.f_registro_arquivo_set_id_leiaute_arquivo()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	-- Dentre os que passaram na validação de tamanho, mantém apenas os leiautes cujos
	-- campos de valor_padrao do header (tipo_campo = 1) batem com a posição na linha.
	-- Lista vazia = nenhum leiaute reconheceu o header → erro.
	-- Mais de um = ambiguidade (remessa e retorno têm literais distintos, deve sobrar 1) → erro.
	-- Filtro: mensagem_erro IS NULL AND conteudo_jsonb IS NOT NULL = passou no tamanho.
	FOR VRecord IN
		SELECT
			ra.id AS id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, (
				SELECT ARRAY_AGG(id_cand)
				FROM (
					SELECT elem::bigint AS id_cand
					FROM jsonb_array_elements_text(ra.conteudo_jsonb -> 'lista_id_leiaute_arquivo') AS elem
				) c
				WHERE NOT EXISTS (
					SELECT 1
					FROM public.leiaute_campo_arquivo lca
					WHERE lca.id_leiaute_arquivo = c.id_cand
					  AND lca.tipo_campo = 1 -- Header Arquivo
					  AND lca.valor_padrao IS NOT NULL
					  AND lca.valor_padrao <> SUBSTRING(ra.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER)
				)
			) AS lista_leiaute_constante
		FROM public.registro_arquivo ra
		WHERE ra.numero_linha = 1
		  AND ra.mensagem_erro IS NULL   -- sem erro registrado
		  AND NOT NULLIF(TRIM(ra.conteudo_jsonb ->> 'lista_id_leiaute_arquivo'), '') IS NULL  -- já tem candidatos de tamanho
		  AND ra.conteudo_jsonb ->> 'id_leiaute_arquivo' IS NULL -- ainda não identificado de forma definitiva
		ORDER BY ra.id_arquivo ASC
		LIMIT 300
	LOOP
		IF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) = 0 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Nenhum leiaute identificado pelos campos constantes do header.'
			WHERE id = VRecord.id_registro_arquivo;

		ELSIF COALESCE(CARDINALITY(VRecord.lista_leiaute_constante), 0) > 1 THEN
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Multiplos leiautes identificados pelos campos constantes do header.'
			WHERE id = VRecord.id_registro_arquivo;
		ELSE
			-- Registra a lista de leiautes atualizada com o único candidato sobrevivente
			UPDATE public.registro_arquivo
			SET conteudo_jsonb = jsonb_build_object('lista_id_leiaute_arquivo', VRecord.lista_leiaute_constante)
				, mensagem_erro =  NULL
			WHERE id = VRecord.id_registro_arquivo;
		END IF;
	END LOOP;
END;
$$;
