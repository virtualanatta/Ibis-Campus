# Docker

## Contenedores

```bash
docker ps -a
docker logs -f <c>
docker exec -it <c> sh
docker restart <c>
docker inspect <c>
docker stats --no-stream
```

## Compose

```bash
docker compose up -d
docker compose up -d --build <servicio>
docker compose ps
docker compose logs -f <servicio>
docker compose pull && docker compose up -d
docker compose down
```

## Imágenes, redes y volúmenes

```bash
docker images
docker image prune
docker network ls
docker network inspect <red>
docker volume ls
```
