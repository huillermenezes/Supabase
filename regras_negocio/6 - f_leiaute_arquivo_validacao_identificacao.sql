DROP FUNCTION IF EXISTS public.f_leiaute_arquivo_validacao_identificacao() CASCADE;

CREATE OR REPLACE FUNCTION public.f_leiaute_arquivo_validacao_identificacao()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	VRecord RECORD;
	VLeiauteID BIGINT;
	VListaParametros BIGINT[];
	VParametroID BIGINT;
BEGIN
	-- Confirma o leiaute pelo campo_identificacao e localiza o parametro correspondente
	-- em parametro_leiaute_arquivo. Só chega aqui quem passou pelas duas validações
	-- anteriores, portanto há exatamente 1 leiaute candidato.
	-- Lista vazia ou mais de um = erro, arquivo movido para erro/.
	-- Exatamente 1 = sucesso, arquivo movido para backup/.
	FOR VRecord IN
		SELECT
			ra.id AS id_registro_arquivo
			, ra.id_arquivo
			, ra.nome_arquivo
			, ra.linha_arquivo
			, ra.conteudo_jsonb
			, o.name AS caminho_origem
			, REPLACE(
				(SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'url_storage')
				, '/object/authenticated/', '/object/move'
			) AS url_move
			, (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'storage_auth_key') AS auth_key
		FROM public.registro_arquivo ra
			INNER JOIN storage.objects o ON CAST(o.metadata ->> 'id' AS BIGINT) = ra.id_arquivo
		WHERE ra.numero_linha = 1
		AND ra.mensagem_erro IS NULL   -- sem erro registrado
		AND NOT NULLIF(TRIM(ra.conteudo_jsonb ->> 'lista_id_leiaute_arquivo'), '') IS NULL  -- já tem candidatos de tamanho e constantes
	LOOP
		-- Pega o único leiaute candidato
		IF COALESCE(jsonb_array_length(VRecord.conteudo_jsonb -> 'lista_id_leiaute_arquivo'), 0) <> 1 THEN
			-- Se por algum motivo tiver 0 ou múltiplos candidatos, gera erro
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Ambiguidade na identificação: múltiplos ou nenhuns leiautes candidatos.'
			WHERE id = VRecord.id_registro_arquivo;

			UPDATE storage.objects
			SET metadata = jsonb_concat(
				metadata,
				jsonb_build_object('mensagem_erro', 'Ambiguidade na identificação: múltiplos ou nenhuns leiautes candidatos.')
			)
			WHERE CAST(metadata ->> 'id' AS BIGINT) = VRecord.id_arquivo;

			PERFORM net.http_post(
				url := VRecord.url_move
				, headers := jsonb_build_object(
					'apikey', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key)
					, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key))
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'sourceKey', VRecord.caminho_origem
					, 'destinationKey', CONCAT('error/', VRecord.nome_arquivo)
				)
			);
			CONTINUE;
		END IF;

		VLeiauteID := (VRecord.conteudo_jsonb -> 'lista_id_leiaute_arquivo' ->> 0)::BIGINT;

		-- Busca os parâmetros de leiaute correspondentes
		SELECT ARRAY_AGG(pla.id) INTO VListaParametros
		FROM public.parametro_leiaute_arquivo pla
		INNER JOIN public.leiaute_campo_arquivo lca ON lca.id_leiaute_arquivo = pla.id_leiaute_arquivo
		WHERE pla.id_leiaute_arquivo = VLeiauteID
		  AND lca.tipo_campo = 1 -- Header Arquivo
		  AND lca.campo_identificacao = TRUE
		  -- COMPARAÇÃO INTELIGENTE (Trata espaços e zeros à esquerda se forem numéricos)
		  AND (
			TRIM(BOTH ' ' FROM pla.codigo) = TRIM(BOTH ' ' FROM SUBSTRING(VRecord.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER))
			OR
			(
				pla.codigo ~ '^[0-9\s]+$' 
				AND SUBSTRING(VRecord.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER) ~ '^[0-9\s]+$'
				AND TRIM(BOTH ' ' FROM pla.codigo)::NUMERIC = TRIM(BOTH ' ' FROM SUBSTRING(VRecord.linha_arquivo, lca.posicao_inicial::INTEGER, lca.tamanho::INTEGER))::NUMERIC
			)
		  );

		IF COALESCE(CARDINALITY(VListaParametros), 0) = 0 THEN
			-- Erro: Nenhum parâmetro identificado
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Nenhum parametro identificado pelo campo de identificacao do header.'
			WHERE id = VRecord.id_registro_arquivo;

			UPDATE storage.objects
			SET metadata = jsonb_concat(
				metadata,
				jsonb_build_object('mensagem_erro', 'Nenhum parametro identificado pelo campo de identificacao do header.')
			)
			WHERE CAST(metadata ->> 'id' AS BIGINT) = VRecord.id_arquivo;

			PERFORM net.http_post(
				url := VRecord.url_move
				, headers := jsonb_build_object(
					'apikey', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key)
					, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key))
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'sourceKey', VRecord.caminho_origem
					, 'destinationKey', CONCAT('error/', VRecord.nome_arquivo)
				)
			);
		ELSIF COALESCE(CARDINALITY(VListaParametros), 0) > 1 THEN
			-- Erro: Múltiplos parâmetros identificados
			UPDATE public.registro_arquivo
			SET mensagem_erro = 'Multiplos parametros de leiaute identificados pelo campo de identificacao.'
			WHERE id = VRecord.id_registro_arquivo;

			UPDATE storage.objects
			SET metadata = jsonb_concat(
				metadata,
				jsonb_build_object('mensagem_erro', 'Multiplos parametros de leiaute identificados pelo campo de identificacao.')
			)
			WHERE CAST(metadata ->> 'id' AS BIGINT) = VRecord.id_arquivo;

			PERFORM net.http_post(
				url := VRecord.url_move
				, headers := jsonb_build_object(
					'apikey', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key)
					, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key))
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'sourceKey', VRecord.caminho_origem
					, 'destinationKey', CONCAT('error/', VRecord.nome_arquivo)
				)
			);
		ELSE
			-- Sucesso!
			VParametroID := VListaParametros[1];

			-- Atualiza registro_arquivo
			UPDATE public.registro_arquivo
			SET conteudo_jsonb = jsonb_concat(
				VRecord.conteudo_jsonb,
				jsonb_build_object(
					'id_leiaute_arquivo', VLeiauteID,
					'id_parametro_leiaute_arquivo', VParametroID
				)
			)
				, mensagem_erro = NULL
			WHERE id = VRecord.id_registro_arquivo;

			-- Atualiza os metadados do storage com o leiaute final aprovado
			UPDATE storage.objects
			SET metadata = jsonb_concat(
				metadata,
				jsonb_build_object(
					'id_leiaute_arquivo', VLeiauteID,
					'id_parametro_leiaute_arquivo', VParametroID,
					'mensagem_erro', NULL
				)
			)
			WHERE CAST(metadata ->> 'id' AS BIGINT) = VRecord.id_arquivo;

			-- Move o arquivo processado com sucesso para backup/
			PERFORM net.http_post(
				url := VRecord.url_move
				, headers := jsonb_build_object(
					'apikey', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key)
					, 'Authorization', CONCAT('Bearer ', TRIM(BOTH E' \r\n\t' FROM VRecord.auth_key))
					, 'Content-Type', 'application/json'
				)
				, body := jsonb_build_object(
					'bucketId', 'hetzner_files'
					, 'sourceKey', VRecord.caminho_origem
					, 'destinationKey', CONCAT('backup/', VRecord.nome_arquivo)
				)
			);
		END IF;
	END LOOP;
END;
$$;
