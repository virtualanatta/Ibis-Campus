# Firewall y red

## Capas

```
Internet
  │  Router: sin puertos abiertos, sin DMZ, UPnP desactivado
  ▼
Tailscale (WireGuard)
  │
  ▼
UFW: entrada denegada por defecto
  │
  ▼
Redes Docker: solo el proxy publica puertos
```

## Reglas aplicadas

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

```
$ sudo ufw status
To                         Action      From
--                         ------      ----
Anywhere on tailscale0     ALLOW       Anywhere
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
```

Las reglas de SSH, HTTP y HTTPS permiten además el acceso desde la red local del centro. Desde Internet no hay ruta posible porque el router no reenvía ningún puerto.

## Docker y UFW

Docker inserta sus propias reglas en iptables y los puertos publicados con `ports:` **no pasan por UFW**. Por eso el modelo se apoya en no publicar puertos innecesarios, y no en UFW. Para restringir un puerto publicado a la VPN hay dos opciones:

```yaml
ports:
  - "100.x.y.z:81:81"
```

o filtrar en la cadena `DOCKER-USER`.

## Puertos

| Servicio | Contenedor | Puerto | Acceso |
|---|---|---|---|
| Nginx Proxy Manager | `global-proxy` | 80, 443 | Publicado |
| Panel de NPM | `global-proxy` | 81 | Publicado, uso desde VPN |
| Mailcow | `nginx-mailcow` | 8181, 8444 | Publicado, enrutado por el proxy |
| n8n | `n8n_ibis` | 5678 | Publicado, uso desde VPN |
| Frontend | `crisma_front` | 8080 | Red Docker |
| API | `crisma_back` | 3005 | Red Docker |
| PostgreSQL | `crisma_db` | 5432 | Red Docker |
| Authentik | `authentik-server` | 9000 | Red Docker |
| Nextcloud | `nextcloud-mailcow` | 80 | Red Docker |
| Mattermost | `sphynxchat` | 8065 | Red Docker |

## Incidencia: bloqueo al activar UFW

UFW se activó en remoto sin la regla de `tailscale0` y el servidor quedó inaccesible, también por SSH. Se recuperó con acceso físico:

```bash
sudo ufw allow in on tailscale0
sudo ufw reload
```

Desde entonces, la regla de la interfaz de la VPN se añade siempre antes de `ufw enable`.
