# Backups

## Contenido

`ejecutar_backup.sh` genera cada domingo a las 03:00 un directorio `~/Backups/semanal_AAAAMMDD_HHMM/`:

```
semanal_20260503_0300/
├── db/
│   ├── danet_completo.sql    volcado de la base de datos
│   ├── roles_globales.sql    roles de PostgreSQL
│   └── estadisticas.txt      tamaño por tabla
├── codigo/                   backend y frontend
├── uploads/                  entregas del alumnado
└── backup.log
```

Si el volcado ocupa menos de 10 KB se envía un aviso, ya que suele indicar un fallo silencioso de `pg_dump`. Al terminar se notifica el tamaño total por Telegram.

## Retención

- `ejecutar_backup.sh` conserva los 5 backups más recientes.
- `limpiar_backups.sh` elimina además cualquiera de más de 30 días.

Los backups se guardan en el SSD del servidor y los datos en el DAS, de forma que un fallo de cualquiera de los dos dispositivos no se lleva ambos. No hay copia fuera del servidor.

## Restauración

```bash
B=~/Backups/semanal_20260503_0300

# Roles y base de datos
docker exec -i crisma_db psql -U Crisma -d postgres < "$B/db/roles_globales.sql"
docker exec crisma_db dropdb -U Crisma --if-exists danet
docker exec crisma_db createdb -U Crisma danet
docker exec -i crisma_db psql -U Crisma -d danet < "$B/db/danet_completo.sql"

# Entregas
rsync -a "$B/uploads/" /mnt/TFG_CRIMSA/uploads/
```

Detener antes `crisma_back` para que la API no escriba durante la restauración.
