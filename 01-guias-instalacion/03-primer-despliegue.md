# Primer despliegue

## Proxy inverso

El primer contenedor es Nginx Proxy Manager, ya que el resto de servicios se publica a través de él. La definición completa está en [05-nginx-proxy.md](../02-infraestructura/05-nginx-proxy.md).

```bash
mkdir -p /mnt/TFG_CRIMSA/services/nginx_proxy/{data,letsencrypt}
cd /mnt/TFG_CRIMSA/services/nginx_proxy
docker compose up -d
docker ps --filter name=global-proxy
```

El panel queda en `http://100.x.y.z:81`. Las credenciales iniciales son las de la imagen y se cambian en el primer acceso.

## Orden de despliegue

| Orden | Servicio | Motivo |
|---|---|---|
| 1 | Nginx Proxy Manager | Punto de entrada del resto |
| 2 | PostgreSQL (`crisma_db`) | Lo necesita la API |
| 3 | API (`crisma_back`) | Depende de la base de datos |
| 4 | Frontend (`crisma_front`) | Consume la API |
| 5 | Authentik | Proveedor de identidad para los servicios siguientes |
| 6 | Mailcow | Buzones para los usuarios |
| 7 | Nextcloud | Almacenamiento, con login OIDC |
| 8 | Mattermost | Chat |
| 9 | n8n | Automatiza sobre los servicios anteriores |

Tras cada paso, comprobar el contenedor con `docker compose ps` y `docker compose logs -f` y dar de alta su host en el proxy antes de seguir con el siguiente.
