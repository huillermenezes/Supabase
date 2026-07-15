DROP FUNCTION IF EXISTS public.f_converter_numerico(TEXT, INTEGER);

CREATE OR REPLACE FUNCTION public.f_converter_numerico(
	p_valor TEXT,
	p_escala INTEGER DEFAULT 2
)
RETURNS NUMERIC
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
	V_limpo TEXT;
BEGIN
	V_limpo := TRIM(p_valor);
	
	IF V_limpo IS NULL OR V_limpo = '' OR V_limpo ~ '^\s*/*\s*$' OR V_limpo ~ '^\s*,*\s*$' THEN
		RETURN NULL;
	END IF;

	-- Remove sinal de positivo se houver no início
	IF SUBSTRING(V_limpo FROM 1 FOR 1) = '+' THEN
		V_limpo := SUBSTRING(V_limpo FROM 2);
	END IF;

	-- Caso possua separador decimal explícito (vírgula ou ponto)
	IF POSITION(',' IN V_limpo) > 0 OR POSITION('.' IN V_limpo) > 0 THEN
		-- Trata formato brasileiro (onde o ponto é milhar e a vírgula é decimal)
		IF POSITION(',' IN V_limpo) > 0 AND POSITION('.' IN V_limpo) > 0 THEN
			V_limpo := REPLACE(REPLACE(V_limpo, '.', ''), ',', '.');
		ELSIF POSITION(',' IN V_limpo) > 0 THEN
			V_limpo := REPLACE(V_limpo, ',', '.');
		END IF;
		RETURN CAST(V_limpo AS NUMERIC);
	ELSE
		-- Sem separador: trata como decimal implícito (divide por 10^escala)
		RETURN CAST(V_limpo AS NUMERIC) / POWER(10, p_escala);
	END IF;
EXCEPTION WHEN OTHERS THEN
	RETURN NULL;
END;
$$;
