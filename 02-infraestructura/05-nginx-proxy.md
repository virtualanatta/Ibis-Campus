# Nginx Proxy Manager

Proxy inverso único de la plataforma. Se eligió frente a nginx manual o Traefik por la rapidez para gestionar hosts y certificados desde su interfaz, a cambio de algo menos de control.

## Despliegue

```yaml
services:
  nginx-proxy:
    image: jc21/nginx-proxy-manager:latest
    container_name: global-proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    volumes:
      - /mnt/TFG_CRIMSA/services/nginx_proxy/data:/data
      - /mnt/TFG_CRIMSA/services/nginx_proxy/letsencrypt:/etc/letsencrypt
    networks: [codigo_default]

networks:
  codigo_default:
    external: true
```

## Hosts

| Dominio | Destino | Opciones |
|---|---|---|
| `ibis.local` | `crisma_front:8080` | `/api/` → `crisma_back:3005` |
| `auth.ibis.local` | `authentik-server:9000` | |
| `nube.ibis.local` | `nextcloud-mailcow:80` | Límite de subida ampliado |
| `chat.ibis.local` | `sphynxchat:8065` | WebSockets |
| `mail.ibis.local` | `100.x.y.z:8181` | |

Todos con certificado autofirmado y *Force SSL*.

Como alternativa a editar el fichero `hosts` de cada cliente se probó nip.io, que resuelve nombres del tipo `campus.100.x.y.z.nip.io` hacia la IP incluida en el propio nombre.

## Configuración avanzada

Aplicada en la pestaña *Advanced* de los hosts que la necesitan:

```nginx
client_max_body_size 512M;
proxy_connect_timeout 600s;
proxy_send_timeout 600s;
proxy_read_timeout 600s;

proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

- **WebSockets.** Sin las tres últimas líneas, Mattermost envía los mensajes pero el resto de usuarios no los ve hasta recargar la página.
- **Subidas.** Sin `client_max_body_size`, Nextcloud devuelve `413 Request Entity Too Large` en ficheros grandes.

## Equivalente en nginx

Configuración resultante para el campus, como referencia:

```nginx
server {
    listen 443 ssl;
    server_name ibis.local;

    client_max_body_size 512M;

    location / {
        proxy_pass http://crisma_front:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/ {
        proxy_pass http://crisma_back:3005/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Verificación

```bash
curl -kI https://ibis.local
curl -kI https://nube.ibis.local
curl -kI https://chat.ibis.local
docker logs -f global-proxy
```

Para los WebSockets: herramientas de desarrollo del navegador → *Network* → *WS*, con una conexión abierta hacia `chat.ibis.local`.
