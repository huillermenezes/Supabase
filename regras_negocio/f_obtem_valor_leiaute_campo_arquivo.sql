DROP FUNCTION IF EXISTS public.f_obtem_valor_leiaute_campo_arquivo(
	PDenominacao TEXT
) CASCADE;

CREATE OR REPLACE FUNCTION public.f_obtem_valor_leiaute_campo_arquivo(
	PDenominacao TEXT
)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
	VRecord RECORD;
BEGIN
	SELECT CASE
		-- A. Se tiver aspas duplas, extrai o valor esperado
		WHEN substring(PDenominacao from '"([^"]+)"') IS NOT NULL THEN
			CASE 
				WHEN substring(PDenominacao from '"([^"]+)"') ~* '^g[0-9]+' OR substring(PDenominacao from '"([^"]+)"') ~* '^\*g[0-9]+' THEN NULL
				ELSE substring(PDenominacao from '"([^"]+)"')
			END
		-- B. Se não tiver aspas, limpa e pega o valor após o '--'
		ELSE
			CASE
				WHEN trim(split_part(split_part(trim(split_part(PDenominacao, '--', 2)), '*', 1), ' ', 1)) = '' THEN NULL
				WHEN trim(split_part(split_part(trim(split_part(PDenominacao, '--', 2)), '*', 1), ' ', 1)) ~* '^g[0-9]+' 
				  OR trim(split_part(split_part(trim(split_part(PDenominacao, '--', 2)), '*', 1), ' ', 1)) ~* '^\*g[0-9]+' THEN NULL
				ELSE trim(split_part(split_part(trim(split_part(PDenominacao, '--', 2)), '*', 1), ' ', 1))
			END
	END AS valor INTO VRecord;

	RETURN VRecord.valor;
END;
$$;
