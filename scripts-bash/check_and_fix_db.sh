#!/usr/bin/env bash
# Comprueba que PostgreSQL acepta conexiones y lo reinicia si no responde.

set -uo pipefail

DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
BOT="$DIR/bot.sh"
ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
# shellcheck source=/dev/null
source "$ENV_FILE"

DB_CONTAINER="${DB_CONTAINER:-crisma_db}"
DB_USER="${DB_USER:-Crisma}"
LOG_DIR="${LOG_DIR:-/mnt/TFG_CRIMSA/05_LOGS}"
LOG_FILE="$LOG_DIR/db_check.log"
mkdir -p "$LOG_DIR"

log() { echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"; }
db_ready() { docker exec "$DB_CONTAINER" pg_isready -h localhost -U "$DB_USER" -q 2>/dev/null; }

if [[ "$(docker inspect -f '{{.State.Running}}' "$DB_CONTAINER" 2>/dev/null)" != "true" ]]; then
  log "$DB_CONTAINER no está en ejecución"
  bash "$BOT" "[CRÍTICO] PostgreSQL ($DB_CONTAINER) no está en ejecución"
  exit 1
fi

if db_ready; then
  log "PostgreSQL operativo"
  exit 0
fi

log "PostgreSQL no responde, reiniciando"
bash "$BOT" "[AVISO] PostgreSQL no responde, reiniciando $DB_CONTAINER"
docker restart "$DB_CONTAINER" > /dev/null

for _ in {1..6}; do
  sleep 5
  if db_ready; then
    log "PostgreSQL recuperado tras el reinicio"
    bash "$BOT" "[RECUPERADO] PostgreSQL vuelve a aceptar conexiones"
    exit 0
  fi
done

log "PostgreSQL sigue sin responder"
bash "$BOT" "[CRÍTICO] PostgreSQL sigue sin responder tras el reinicio. Requiere intervención manual."
exit 1
