-- DROP FUNCTION IF EXISTS public.f_arquivo;

CREATE OR REPLACE FUNCTION public.f_arquivo()
RETURNS TABLE (
    id_arquivo UUID,
    id_storage UUID,
    pasta TEXT,
    nome_arquivo TEXT
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    r RECORD;
    v_pasta TEXT;
    v_nome_arquivo TEXT;
    v_id_arquivo UUID;
BEGIN
    -- 1. Percorre todos os objetos no bucket 'hetzner_files'
    -- que estejam nas pastas 'input/', 'output/' ou 'error/'
    FOR r IN 
        SELECT id, name 
        FROM storage.objects 
        WHERE bucket_id = 'hetzner_files' 
          AND (name LIKE 'input/%' OR name LIKE 'output/%' OR name LIKE 'error/%')
          AND name NOT LIKE '%/' -- Ignora registros que representam apenas pastas
    LOOP
        -- Extrai a pasta (ex: 'input') e o nome do arquivo (tudo que vem após a primeira barra '/')
        v_pasta := split_part(r.name, '/', 1);
        v_nome_arquivo := substring(r.name from position('/' in r.name) + 1);

        -- Se por algum motivo o nome do arquivo for vazio, ignora
        IF v_nome_arquivo IS NULL OR v_nome_arquivo = '' THEN
            CONTINUE;
        END IF;

        -- Verifica se o arquivo com esse id_storage já está cadastrado em public.arquivo
        SELECT a.id_arquivo INTO v_id_arquivo 
        FROM public.arquivo a 
        WHERE a.id_storage = r.id;

        -- Se não estiver cadastrado, faz o insert gerando um novo UUID para id_arquivo
        IF v_id_arquivo IS NULL THEN
            v_id_arquivo := gen_random_uuid();
            
            INSERT INTO public.arquivo (id_arquivo, id_storage, nome_arquivo)
            VALUES (v_id_arquivo, r.id, v_nome_arquivo);
        ELSE
            -- Se já existe, garante que o nome_arquivo está atualizado
            UPDATE public.arquivo 
            SET nome_arquivo = v_nome_arquivo 
            WHERE id_storage = r.id;
        END IF;

        -- Define os valores de retorno
        id_arquivo := v_id_arquivo;
        id_storage := r.id;
        pasta := v_pasta;
        nome_arquivo := v_nome_arquivo;
        
        RETURN NEXT;
    END LOOP;
END;
$$;
