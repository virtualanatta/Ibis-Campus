# PostgreSQL

## Conexión

```bash
docker exec -it crisma_db psql -U Crisma -d danet
```

## psql

```
\l          bases de datos
\c danet    conectar
\dt         tablas
\d+ tabla   estructura
\du         roles
\q          salir
```

## Consultas útiles

```sql
SELECT relname, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;

SELECT pid, usename, state, query_start, query
FROM pg_stat_activity WHERE datname = 'danet';
```

## Volcado y restauración

```bash
docker exec crisma_db pg_dump -U Crisma --no-owner danet > danet.sql
docker exec -i crisma_db psql -U Crisma -d danet < danet.sql
```
