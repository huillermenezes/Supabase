DROP FUNCTION IF EXISTS bradesco.f_processar_retorno_cartao_scheduler();

CREATE OR REPLACE FUNCTION bradesco.f_processar_retorno_cartao_scheduler()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_rec RECORD;
BEGIN
	-- Busca todos os arquivos Bradesco (BVXB) que estão em registro_arquivo mas ainda não têm cabeçalho processado
	FOR V_rec IN 
		SELECT DISTINCT ra.id_arquivo 
		FROM public.registro_arquivo ra
		WHERE (ra.nome_arquivo LIKE 'BVXB%' OR ra.nome_arquivo LIKE 'bvxb%')
		  AND NOT EXISTS (
			  SELECT 1 
			  FROM bradesco.cartao_credito_header_arquivo ha 
			  WHERE ha.id_arquivo = ra.id_arquivo
		  )
	LOOP
		PERFORM bradesco.f_processar_retorno_cartao(V_rec.id_arquivo);
	END LOOP;
END;
$$;
