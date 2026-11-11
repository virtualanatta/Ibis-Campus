# Monitorización de contenedores

## `monitor.sh`

Vigila `crisma_db`, `crisma_back` y `crisma_front`. Para cada uno distingue tres estados: en ejecución, detenido o inexistente.

- Avisa por Telegram solo en los **cambios de estado**: al caer y al recuperarse. Un fichero de marca por contenedor evita repetir la alerta cada cinco minutos.
- No reinicia contenedores; de eso se encarga la política `restart: unless-stopped` de Docker. El script detecta los casos que esa política no resuelve, como un contenedor que entra en bucle de reinicios o que se ha eliminado.
- Registra los eventos en `05_LOGS/ibis_monitor.log` y recorta el log a las últimas 500 líneas cuando supera las 1000.

## `check_and_fix_db.sh`

Un contenedor puede estar en marcha con PostgreSQL sin aceptar conexiones. Este script lo comprueba con `pg_isready`:

1. Si el contenedor no está en ejecución, alerta y termina.
2. Si no responde, alerta y reinicia el contenedor.
3. Tras el reinicio vuelve a comprobar y notifica si se ha recuperado o si hace falta intervención manual.

## Panel del campus

`generar_dashboard.sh` escribe `estado_sistema.json` en el directorio `public/` del frontend con el uso del DAS, la RAM disponible, el estado de PostgreSQL y el número de tablas. El frontend lo sirve como fichero estático y lo muestra en la vista de administración. Ejemplo de salida:

```json
{
  "timestamp": "2026-05-04T10:00:00Z",
  "storage":  { "total_mb": 1907723, "used_mb": 412330, "percent": 22 },
  "ram":      { "total_mb": 31941, "available_mb": 18220, "available_percent": 57 },
  "database": { "status": "operational", "tables_count": 5 }
}
```
