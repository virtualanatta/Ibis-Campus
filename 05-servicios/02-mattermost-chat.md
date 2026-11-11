# Mattermost

Chat del centro, con canales por asignatura.

## Despliegue

```yaml
services:
  db-mattermost:
    image: postgres:13-alpine
    container_name: db_mattermost
    restart: unless-stopped
    environment:
      POSTGRES_USER: mmuser
      POSTGRES_PASSWORD: ${MM_DB_PASSWORD}
      POSTGRES_DB: mattermost
    volumes:
      - /mnt/TFG_CRIMSA/services/mattermost/db:/var/lib/postgresql/data

  mattermost:
    image: mattermost/mattermost-team-edition:latest
    container_name: sphynxchat
    restart: unless-stopped
    depends_on: [db-mattermost]
    environment:
      MM_SQLSETTINGS_DRIVERNAME: postgres
      MM_SQLSETTINGS_DATASOURCE: postgres://mmuser:${MM_DB_PASSWORD}@db-mattermost:5432/mattermost?sslmode=disable
      MM_SERVICESETTINGS_SITEURL: https://chat.ibis.local
    volumes:
      - /mnt/TFG_CRIMSA/services/mattermost/config:/mattermost/config
      - /mnt/TFG_CRIMSA/services/mattermost/data:/mattermost/data
      - /mnt/TFG_CRIMSA/services/mattermost/logs:/mattermost/logs
```

La imagen se ejecuta con UID 2000, así que los volúmenes necesitan ese propietario:

```bash
sudo chown -R 2000:2000 /mnt/TFG_CRIMSA/services/mattermost
```

## Organización

Equipo `CRIMSA` con los canales `general`, `anuncios`, `preguntas`, `seguridad`, `servicios-red` y `administracion-so`.

## Usuarios: aprovisionamiento por API

Team Edition solo admite GitLab como proveedor OAuth, no OIDC genérico, por lo que no puede delegar el login en Authentik. Para mantener las mismas cuentas en toda la plataforma, los usuarios se dieron de alta de forma masiva con la API REST. Esquema del proceso a partir de un CSV:

```bash
MM=https://chat.ibis.local
TOKEN=<token-de-administrador>

while IFS=, read -r usuario email nombre; do
  curl -sk -X POST "$MM/api/v4/users" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$usuario\",\"email\":\"$email\",\"first_name\":\"$nombre\",\"password\":\"$(openssl rand -base64 18)\"}"
done < usuarios.csv
```

Las contraseñas deben cumplir la política del servidor; si no, la API responde `INVALID_PASSWORD`.

## Avisos automáticos

Los anuncios desde n8n y desde el campus llegan por *incoming webhooks* (*Integrations → Incoming Webhooks*), asociados al canal `anuncios`:

```bash
curl -sk -X POST https://chat.ibis.local/hooks/<id> \
  -H 'Content-Type: application/json' \
  -d '{"text":"Nueva tarea publicada"}'
```

## Incidencias

| Síntoma | Solución |
|---|---|
| Los mensajes no aparecen hasta recargar | Cabeceras de WebSocket en el proxy ([05-nginx-proxy.md](../02-infraestructura/05-nginx-proxy.md)) |
| Error de escritura en `config` | `chown -R 2000:2000` sobre los volúmenes |
