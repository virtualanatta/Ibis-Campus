# IbisScripts

Scripts Bash de operación del servidor. El código está en [`scripts-bash/`](../scripts-bash) y en el servidor se instalan en `/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/`.

| Script | Función | Frecuencia |
|---|---|---|
| `bot.sh` | Envía un mensaje al chat de administración | Lo usan los demás |
| `monitor.sh` | Detecta caídas y recuperaciones de los contenedores del campus | 5 min |
| `check_and_fix_db.sh` | Comprueba PostgreSQL y lo reinicia si no responde | 15 min |
| `generar_dashboard.sh` | Escribe el estado del sistema en JSON para el panel del campus | 10 min |
| `ejecutar_backup.sh` | Backup semanal de base de datos, código y entregas | Domingo 03:00 |
| `limpiar_backups.sh` | Elimina backups de más de 30 días | Domingo 04:00 |

## Configuración común

Todos leen `~/.config/crimsa/env` (permisos 600):

```bash
TELEGRAM_TOKEN=...
ID_CHAT=...
DB_CONTAINER=crisma_db
DB_USER=Crisma
DB_PASSWORD=...
DB_NAME=danet
```

Las rutas de logs y backups tienen valores por defecto que se pueden sobrescribir desde ese mismo fichero (`LOG_DIR`, `BACKUP_ROOT`).
