# Workspace Agent Rules

- Nunca utilizar `CASCADE` em instruções `DROP FUNCTION` ou `DROP TABLE` no PostgreSQL/Supabase.
- Nunca utilizar `LIMIT 1` em consultas de regras de negócio, buscas de IDs ou relacionamentos; utilizar chaves únicas e filtros determinísticos para garantir a integridade.
