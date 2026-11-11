# Auditoría de accesos

## Aviso de inicio de sesión SSH

Cada sesión interactiva en el servidor envía un aviso al chat de administración por Telegram.

`/usr/local/bin/notificar_ssh.sh`:

```bash
#!/usr/bin/env bash
source "$HOME/.config/crimsa/env"

IP="${SSH_CONNECTION%% *}"
MSG="SSH login
Usuario: $(whoami)
IP: ${IP:-local}
Hora: $(date '+%d/%m/%Y %H:%M')"

curl -fsS -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
  -d "chat_id=${ID_CHAT}" --data-urlencode "text=${MSG}" > /dev/null
```

Al final de `/etc/profile`:

```bash
[[ $- == *i* ]] && /usr/local/bin/notificar_ssh.sh
```

Solo cubre shells interactivas. Para registrar también sesiones sin terminal (por ejemplo, `ssh host comando`) habría que engancharlo a PAM con `pam_exec`.

## Registro de conexiones

Las conexiones se registran en `/mnt/TFG_CRIMSA/05_LOGS/historial_conexiones.log` con fecha, usuario, IP y estado del DAS. El fichero se marca como *append-only*:

```bash
sudo chattr +a /mnt/TFG_CRIMSA/05_LOGS/historial_conexiones.log
```

Con `+a` se puede añadir contenido pero no modificar ni borrar el existente, ni siquiera como root sin retirar antes el atributo.

## Línea abierta

Se planteó analizar los logs automáticamente con n8n y un modelo local (Ollama con Phi-3). No llegó a implementarse.
