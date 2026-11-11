# Alertas por Telegram

Canal único de notificaciones del servidor. Todas las alertas pasan por `bot.sh`, que lee el token y el chat de `~/.config/crimsa/env`.

| Origen | Evento |
|---|---|
| `/etc/profile` | Inicio de sesión SSH |
| `monitor.sh` | Contenedor caído, recuperado o inexistente |
| `check_and_fix_db.sh` | PostgreSQL sin respuesta, reinicio y resultado |
| `ejecutar_backup.sh` | Backup completado, fallido o sospechosamente pequeño |

Configuración del bot y del aviso SSH en [01-auditoria-activa.md](../06-seguridad/01-auditoria-activa.md).
