#!/usr/bin/env bash
# Vigila los contenedores del campus y avisa en cada cambio de estado.

set -uo pipefail

DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
BOT="$DIR/bot.sh"
ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
# shellcheck source=/dev/null
[[ -r "$ENV_FILE" ]] && source "$ENV_FILE"

LOG_DIR="${LOG_DIR:-/mnt/TFG_CRIMSA/05_LOGS}"
LOG_FILE="$LOG_DIR/ibis_monitor.log"
FLAG_DIR="/var/tmp/crimsa_flags"
mkdir -p "$LOG_DIR" "$FLAG_DIR"

declare -A CONTENEDORES=(
  [crisma_db]="PostgreSQL"
  [crisma_back]="API"
  [crisma_front]="Frontend"
)

log() { echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"; }

for c in "${!CONTENEDORES[@]}"; do
  nombre="${CONTENEDORES[$c]}"
  flag="$FLAG_DIR/$c.flag"

  if ! estado=$(docker inspect -f '{{.State.Running}}' "$c" 2>/dev/null); then
    estado="missing"
  fi

  if [[ "$estado" == "true" ]]; then
    if [[ -f "$flag" ]]; then
      bash "$BOT" "[RECUPERADO] $nombre ($c) vuelve a estar en ejecución"
      log "$c recuperado"
      rm -f "$flag"
    fi
  elif [[ ! -f "$flag" ]]; then
    if [[ "$estado" == "missing" ]]; then
      bash "$BOT" "[CRÍTICO] $nombre ($c) no existe"
      log "$c no existe"
    else
      bash "$BOT" "[CAÍDA] $nombre ($c) está detenido"
      log "$c detenido"
    fi
    touch "$flag"
  fi
done

# Recorta el log a 500 líneas cuando supera las 1000
if [[ -f "$LOG_FILE" ]] && (( $(wc -l < "$LOG_FILE") > 1000 )); then
  tail -n 500 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi
