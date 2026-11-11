# n8n

Motor de automatización que conecta el campus con el resto de servicios.

## Despliegue

```bash
docker run -d \
  --name n8n_ibis \
  --restart unless-stopped \
  -p 5678:5678 \
  -e GENERIC_TIMEZONE=Europe/Madrid \
  -v /mnt/TFG_CRIMSA/services/n8n:/home/node/.n8n \
  n8nio/n8n
```

Accesible solo desde la VPN en `http://100.x.y.z:5678`.

## Flujos

| Flujo | Webhook | Función |
|---|---|---|
| Validar login | `/webhook/validar-login` | Valida credenciales contra los hashes bcrypt de PostgreSQL |
| Crear buzón | `/webhook/crear-buzon` | Crea el buzón en Mailcow y la cuenta en Mattermost para un usuario nuevo |
| Notificar material | | Publica en Mattermost cuando el profesorado sube material |
| Filtro de lenguaje | | Moderación básica de mensajes en el chat |

Los flujos se revisaron y corrigieron en la fase final del proyecto, junto con la integración SSO.

## Exportación

```bash
docker exec n8n_ibis n8n export:workflow --all --output=/home/node/.n8n/backup/ --separate
```
