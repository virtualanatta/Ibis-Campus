#!/usr/bin/env bash
# Envía un mensaje al chat de administración por Telegram.
# Uso: bot.sh "mensaje"

set -uo pipefail

ENV_FILE="${IBIS_ENV:-$HOME/.config/crimsa/env}"
[[ -r "$ENV_FILE" ]] || { echo "No se puede leer $ENV_FILE" >&2; exit 1; }
# shellcheck source=/dev/null
source "$ENV_FILE"

: "${TELEGRAM_TOKEN:?TELEGRAM_TOKEN no definido}"
: "${ID_CHAT:?ID_CHAT no definido}"
[[ $# -ge 1 ]] || { echo "Uso: $0 \"mensaje\"" >&2; exit 1; }

if ! curl -fsS --max-time 10 -X POST \
    "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    -d "chat_id=${ID_CHAT}" \
    --data-urlencode "text=$1" > /dev/null; then
  echo "Error al enviar la notificación" >&2
  exit 1
fi
