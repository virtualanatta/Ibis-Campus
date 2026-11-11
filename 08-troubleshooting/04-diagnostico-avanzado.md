# Diagnóstico

## Logs

```bash
docker compose logs -f --tail 50 --timestamps <servicio>
docker compose logs <servicio> 2>&1 | grep -iE 'error|fatal'
journalctl -u docker --since "1 hour ago"
tail -f /mnt/TFG_CRIMSA/05_LOGS/*.log
```

## Estado

```bash
docker stats --no-stream
docker events --since 30m
docker inspect <contenedor>
df -h /mnt/TFG_CRIMSA
free -h
```

## Conectividad desde dentro

```bash
docker exec global-proxy curl -sI http://crisma_back:3005/api
docker exec global-proxy getent hosts crisma_front
```

## Limpieza

```bash
docker container prune
docker image prune
```

`docker system prune --volumes` elimina volúmenes no usados; no ejecutarlo sin revisar antes qué se va a borrar.
