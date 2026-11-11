# Planificación

Crontab del usuario de administración:

```cron
S=/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts

*/5  * * * *  $S/monitor.sh
*/10 * * * *  $S/generar_dashboard.sh
*/15 * * * *  $S/check_and_fix_db.sh
0    3 * * 0  $S/ejecutar_backup.sh
0    4 * * 0  $S/limpiar_backups.sh
```

```bash
crontab -e
crontab -l
grep CRON /var/log/syslog | tail -20
```

Cron ejecuta con un entorno mínimo: los scripts usan rutas absolutas y cargan su configuración desde `~/.config/crimsa/env`.
