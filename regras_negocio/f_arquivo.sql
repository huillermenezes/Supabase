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
BEGIN
    -- 1. Insere na tabela public.arquivo todos os arquivos do storage que ainda não existem.
    -- O id_arquivo é gerado dinamicamente usando gen_random_uuid().
    -- O ON CONFLICT (id_storage) DO NOTHING garante que não duplicamos registros.
    INSERT INTO public.arquivo (id_arquivo, id_storage, nome_arquivo)
    SELECT 
        gen_random_uuid(),
        s.id,
        substring(s.name from position('/' in s.name) + 1)
    FROM 
        storage.objects s
    WHERE 
        s.bucket_id = 'hetzner_files'
        AND (s.name LIKE 'input/%' OR s.name LIKE 'output/%' OR s.name LIKE 'error/%')
        AND s.name NOT LIKE '%/' -- Ignora registros que representam apenas pastas
        AND substring(s.name from position('/' in s.name) + 1) IS NOT NULL
        AND substring(s.name from position('/' in s.name) + 1) <> ''
    ON CONFLICT (id_storage) DO NOTHING;

    -- 2. Atualiza o nome dos arquivos existentes caso tenham sido renomeados no storage
    UPDATE public.arquivo a
    SET nome_arquivo = substring(s.name from position('/' in s.name) + 1)
    FROM storage.objects s
    WHERE a.id_storage = s.id
      AND s.bucket_id = 'hetzner_files'
      AND a.nome_arquivo <> substring(s.name from position('/' in s.name) + 1);

    -- 3. Retorna a lista unificada e atualizada dos arquivos
    RETURN QUERY
    SELECT 
        a.id_arquivo,
        a.id_storage,
        split_part(s.name, '/', 1) AS pasta,
        a.nome_arquivo
    FROM 
        public.arquivo a
    JOIN 
        storage.objects s ON a.id_storage = s.id
    WHERE 
        s.bucket_id = 'hetzner_files';
END;
$$;