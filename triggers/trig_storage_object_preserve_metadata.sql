-- =================================================================================
-- INDEX E TRIGGER PARA PRESERVAR METADADOS CUSTOMIZADOS DO STORAGE NAS MOVIMENTAÇÕES
-- =================================================================================

-- 1. Cria índice parcial na tabela registro_arquivo para otimizar a busca do trigger
CREATE INDEX IF NOT EXISTS idx_registro_arquivo_nome_arquivo 
ON public.registro_arquivo (nome_arquivo) 
WHERE numero_linha = 1;

-- 2. Cria a função de trigger que intercepta inserções/atualizações de arquivos
CREATE OR REPLACE FUNCTION public.fn_storage_objects_preserve_metadata()
RETURNS TRIGGER AS $$
DECLARE
	V_id_arquivo BIGINT;
BEGIN
	-- Só executa para o nosso bucket específico
	IF NEW.bucket_id = 'hetzner_files' THEN
		-- Busca o ID correspondente ao nome do arquivo
		SELECT id_arquivo INTO V_id_arquivo
		FROM public.registro_arquivo
		WHERE nome_arquivo = storage.filename(NEW.name)
		  AND numero_linha = 1
		LIMIT 1;

		-- Se encontramos o ID, nós mesclamos ele de volta na coluna metadata
		IF V_id_arquivo IS NOT NULL THEN
			NEW.metadata = jsonb_concat(
				COALESCE(NEW.metadata, '{}'::jsonb), 
				jsonb_build_object('id', V_id_arquivo)
			);
		END IF;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Cria o Trigger associado à tabela storage.objects
DROP TRIGGER IF EXISTS trg_storage_objects_preserve_metadata ON storage.objects;

CREATE TRIGGER trg_storage_objects_preserve_metadata
BEFORE INSERT OR UPDATE ON storage.objects
FOR EACH ROW
EXECUTE FUNCTION public.fn_storage_objects_preserve_metadata();
