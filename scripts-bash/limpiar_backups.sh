#!/usr/bin/env bash
# Elimina los backups semanales con más de 30 días.

set -uo pipefail

ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
# shellcheck source=/dev/null
[[ -r "$ENV_FILE" ]] && source "$ENV_FILE"

BACKUP_ROOT="${BACKUP_ROOT:-$HOME/Backups}"
LOG_DIR="${LOG_DIR:-/mnt/TFG_CRIMSA/05_LOGS}"
DIAS=30
mkdir -p "$LOG_DIR"

{
  echo "=== Limpieza de backups $(date '+%F %T') ==="
  eliminados=0
  while IFS= read -r -d '' dir; do
    echo "Eliminado: $(basename "$dir")"
    rm -rf -- "$dir"
    (( eliminados++ ))
  done < <(find "$BACKUP_ROOT" -maxdepth 1 -type d -name 'semanal_*' -mtime +"$DIAS" -print0)
  echo "Total eliminados: $eliminados"
} | tee -a "$LOG_DIR/limpieza_backups.log"
