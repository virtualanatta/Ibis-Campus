#!/usr/bin/env bash
# Escribe el estado del sistema en JSON para el panel del campus.

set -uo pipefail

ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
# shellcheck source=/dev/null
source "$ENV_FILE"

DB_CONTAINER="${DB_CONTAINER:-crisma_db}"
DB_USER="${DB_USER:-Crisma}"
DB_NAME="${DB_NAME:-danet}"
DATA_MOUNT="/mnt/TFG_CRIMSA"
SALIDA="$DATA_MOUNT/01_PROYECTO/CODIGO/frontend/public/estado_sistema.json"

read -r DISK_TOTAL DISK_USED DISK_PERC < <(df -k --output=size,used,pcent "$DATA_MOUNT" | tail -1 | tr -d '%')
read -r RAM_TOTAL RAM_DISP < <(free -m | awk '/^Mem:/ {print $2, $7}')
RAM_PERC=$(( RAM_DISP * 100 / RAM_TOTAL ))

if docker exec "$DB_CONTAINER" pg_isready -h localhost -U "$DB_USER" -q 2>/dev/null; then
  DB_STATUS="operational"
  TABLAS=$(docker exec -e PGPASSWORD="${DB_PASSWORD:-}" "$DB_CONTAINER" \
    psql -U "$DB_USER" -d "$DB_NAME" -tA \
    -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null)
else
  DB_STATUS="down"
fi
TABLAS="${TABLAS:-0}"

# Escritura atómica para que el frontend nunca lea un fichero a medias
cat > "$SALIDA.tmp" <<JSON
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "storage": {
    "total_mb": $(( DISK_TOTAL / 1024 )),
    "used_mb": $(( DISK_USED / 1024 )),
    "percent": $DISK_PERC
  },
  "ram": {
    "total_mb": $RAM_TOTAL,
    "available_mb": $RAM_DISP,
    "available_percent": $RAM_PERC
  },
  "database": {
    "status": "$DB_STATUS",
    "tables_count": $TABLAS
  }
}
JSON
mv "$SALIDA.tmp" "$SALIDA"
