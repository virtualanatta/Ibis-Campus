# Docker

## El contenedor no arranca

```bash
docker compose ps -a
docker logs --tail 100 <contenedor>
```

Si el puerto está ocupado:

```bash
sudo ss -tlnp | grep :8080
```

## Sin conectividad entre contenedores

```bash
docker inspect -f '{{json .NetworkSettings.Networks}}' <contenedor> | jq 'keys'
docker network inspect codigo_default
docker exec <origen> ping -c1 <destino>
```

Si la red externa no existe:

```bash
docker network create codigo_default
```

## Permisos en volúmenes

El propietario del directorio del host debe coincidir con el UID con el que corre la imagen:

| Imagen | UID |
|---|---|
| Nextcloud (`www-data`) | 33 |
| Mattermost | 2000 |
| Node (`node`) | 1000 |

```bash
sudo chown -R 33:33 /mnt/TFG_CRIMSA/services/nextcloud/data
```

## Consumo de recursos

```bash
docker stats --no-stream
```

Límites por servicio en compose:

```yaml
deploy:
  resources:
    limits:
      memory: 2g
      cpus: "1.5"
```
