# PostgreSQL

## La API no conecta

```bash
docker ps --filter name=crisma_db
docker logs --tail 50 crisma_db
docker exec crisma_db pg_isready -U Crisma -d danet
docker exec -it crisma_db psql -U Crisma -d danet
```

## Contraseña desincronizada

La variable `POSTGRES_PASSWORD` solo se aplica al crear el volumen. Si se cambia después en `.env`, hay que cambiarla también en la base de datos:

```sql
ALTER USER "Crisma" WITH PASSWORD '<nueva>';
```

El usuario se creó con mayúscula, así que en SQL va entre comillas dobles.

## Consultas lentas

```sql
EXPLAIN ANALYZE SELECT * FROM entregas WHERE alumno_id = 1;
CREATE INDEX idx_entregas_alumno ON entregas(alumno_id);
ANALYZE entregas;
```

## Espacio

```sql
SELECT datname, pg_size_pretty(pg_database_size(datname)) FROM pg_database;
```
