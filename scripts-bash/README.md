# Scripts de operación

Monitorización, backups y alertas del servidor de Ibis Campus. La descripción funcional de cada script está en [07-automatizacion](../07-automatizacion).

| Script | Función |
|---|---|
| `bot.sh` | Envío de mensajes a Telegram |
| `monitor.sh` | Alertas de caída y recuperación de los contenedores del campus |
| `check_and_fix_db.sh` | Comprobación de PostgreSQL y reinicio si no responde |
| `generar_dashboard.sh` | Estado del sistema en JSON para el frontend |
| `ejecutar_backup.sh` | Backup semanal con rotación |
| `limpiar_backups.sh` | Borrado de backups de más de 30 días |

## Instalación

```bash
DEST=/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts
mkdir -p "$DEST"
cp *.sh "$DEST/" && chmod 750 "$DEST"/*.sh

mkdir -p ~/.config/crimsa
cp env.example ~/.config/crimsa/env
chmod 600 ~/.config/crimsa/env
```

Completar `~/.config/crimsa/env` y comprobar el envío:

```bash
"$DEST/bot.sh" "Prueba de notificación"
```

La planificación con cron está en [04-cron-scheduling.md](../07-automatizacion/04-cron-scheduling.md).

## Logs

| Fichero | Script |
|---|---|
| `05_LOGS/ibis_monitor.log` | `monitor.sh` |
| `05_LOGS/db_check.log` | `check_and_fix_db.sh` |
| `05_LOGS/limpieza_backups.log` | `limpiar_backups.sh` |
| `~/Backups/semanal_*/backup.log` | `ejecutar_backup.sh` |
