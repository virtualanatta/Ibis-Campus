#!/usr/bin/env bash
# Backup semanal: base de datos, roles, código del campus y entregas.

set -uo pipefail

DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
BOT="$DIR/bot.sh"
ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
# shellcheck source=/dev/null
source "$ENV_FILE"

: "${DB_PASSWORD:?DB_PASSWORD no definido en $ENV_FILE}"
DB_CONTAINER="${DB_CONTAINER:-crisma_db}"
DB_USER="${DB_USER:-Crisma}"
DB_NAME="${DB_NAME:-danet}"
PROYECTO="/mnt/TFG_CRIMSA/01_PROYECTO/CODIGO"
UPLOADS="/mnt/TFG_CRIMSA/uploads"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/Backups}"
RETENCION=5

DESTINO="$BACKUP_ROOT/semanal_$(date +%Y%m%d_%H%M)"
LOG="$DESTINO/backup.log"
mkdir -p "$DESTINO"/{db,codigo,uploads}

log() { echo "[$(date '+%F %T')] $*" >> "$LOG"; }
psql_exec() { docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_CONTAINER" "$@"; }

log "Inicio del backup en $DESTINO"

# 1. Base de datos
DUMP="$DESTINO/db/${DB_NAME}_completo.sql"
if ! psql_exec pg_dump -U "$DB_USER" --format=plain --no-owner --no-acl "$DB_NAME" > "$DUMP"; then
  log "Error en pg_dump"
  bash "$BOT" "[BACKUP FALLIDO] Error al volcar la base de datos $DB_NAME"
  exit 1
fi

if (( $(wc -c < "$DUMP") < 10000 )); then
  log "Volcado inferior a 10 KB"
  bash "$BOT" "[AVISO] El volcado de $DB_NAME ocupa menos de 10 KB. Revisar el backup."
fi

# 2. Roles y estadísticas
psql_exec pg_dumpall -U "$DB_USER" --roles-only > "$DESTINO/db/roles_globales.sql"
psql_exec psql -U "$DB_USER" -d "$DB_NAME" -c "
  SELECT tablename,
         pg_size_pretty(pg_total_relation_size(quote_ident(tablename)::regclass)) AS size
  FROM pg_tables WHERE schemaname = 'public'
  ORDER BY pg_total_relation_size(quote_ident(tablename)::regclass) DESC;" \
  > "$DESTINO/db/estadisticas.txt"

# 3. Código y entregas
cp -a "$PROYECTO/backend" "$PROYECTO/frontend" "$DESTINO/codigo/" 2>> "$LOG"
[[ -d "$UPLOADS" ]] && cp -a "$UPLOADS/." "$DESTINO/uploads/" 2>> "$LOG"

# 4. Rotación
find "$BACKUP_ROOT" -maxdepth 1 -type d -name 'semanal_*' -printf '%T@ %p\n' \
  | sort -rn | tail -n +$(( RETENCION + 1 )) | cut -d' ' -f2- \
  | while read -r antiguo; do
      rm -rf -- "$antiguo"
      log "Eliminado $antiguo"
    done

TAMANO=$(du -sh "$DESTINO" | cut -f1)
log "Backup completado ($TAMANO)"
bash "$BOT" "$(printf '[BACKUP] Semanal completado\nTamaño: %s\nRuta: %s' "$TAMANO" "$DESTINO")"
