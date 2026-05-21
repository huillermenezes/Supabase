DROP FUNCTION IF EXISTS public.f_storage_objects_download_processamento() CASCADE;

CREATE OR REPLACE FUNCTION public.f_storage_objects_download_processamento()
RETURNS TABLE (
	id_arquivo		UUID
	, nome_arquivo	TEXT
	, status_final	INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	FOR VRecord IN
		SELECT
			sod.id_storage_objects_download
			, sod.id_arquivo
			, sod.nome_arquivo
			, sod.caminho_origem
			, r.status_code
			, r.body
			, r.error_msg
			, CASE
				WHEN r.status_code = 200 AND NOT r.timed_out AND r.error_msg IS NULL THEN 3 -- 3 = 'baixado'
				ELSE 4 -- 4 = 'erro_download'
			END AS calculado_status
			, CASE
				WHEN r.status_code = 200 AND NOT r.timed_out AND r.error_msg IS NULL THEN NULL
				ELSE 'Erro HTTP ' || r.status_code || ': ' || COALESCE(r.error_msg, 'Falha ao realizar download do arquivo.')
			END AS calculado_mensagem_erro
		FROM public.storage_objects_download sod
		INNER JOIN net._http_response r ON r.id = sod.request_id_leitura
		WHERE sod.status = 2 -- 2 = 'baixando'
	LOOP
		-- 1. Se o download foi bem sucedido (status = 3), inserir as linhas em registro_arquivo
		IF VRecord.calculado_status = 3 THEN
			INSERT INTO public.registro_arquivo (
				id_arquivo, nome_arquivo, numero_linha, linha_arquivo
			)
			SELECT
				VRecord.id_arquivo
				, VRecord.nome_arquivo
				, lines.num_linha
				, rtrim(lines.linha, E'\r')
			FROM (
				SELECT
					row_number() OVER () AS num_linha
					, linha
				FROM unnest(string_to_array(VRecord.body, E'\n')) AS linha
			) lines
			WHERE lines.linha IS NOT NULL
			AND rtrim(lines.linha, E'\r') != ''
			ON CONFLICT (id_arquivo, numero_linha) DO NOTHING;
		END IF;

		-- 2. Atualizar o status na fila de download
		-- O leiaute e a movimentação física ficam a cargo de f_leiaute_arquivo_validacao
		UPDATE public.storage_objects_download
		SET status = VRecord.calculado_status
			, mensagem_erro = VRecord.calculado_mensagem_erro
			, atualizado_em = now()
		WHERE id_storage_objects_download = VRecord.id_storage_objects_download;
	END LOOP;

	-- Retorna os arquivos processados nesta execução (baixados ou com erro de download)
	RETURN QUERY
	SELECT sod.id_arquivo, sod.nome_arquivo, sod.status
	FROM public.storage_objects_download sod
	WHERE sod.status IN (3, 4)
	  AND sod.atualizado_em >= now() - INTERVAL '5 seconds';
END;
$$;
