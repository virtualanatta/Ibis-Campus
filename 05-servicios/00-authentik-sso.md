# Authentik

Proveedor de identidad de la plataforma. Centraliza las cuentas y ofrece login único por OIDC al campus y a Nextcloud.

## Despliegue

Se usa el compose oficial de Authentik (servidor, worker y PostgreSQL), con los secretos en `.env`:

```bash
cd /mnt/TFG_CRIMSA/services/authentik
echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" >> .env
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
docker compose up -d
```

El servidor se publica en el proxy como `auth.ibis.local`. La configuración inicial se completa en `https://auth.ibis.local/if/flow/initial-setup/`.

## Aplicaciones

Para el campus y para Nextcloud se crea en Authentik un *provider* OAuth2/OIDC con su *application*. En Nextcloud, la URI de redirección es `https://nube.ibis.local/apps/oidc_login/oidc`.

Cada servicio recibe el *client ID*, el *client secret* y la URL de descubrimiento:

```
https://auth.ibis.local/application/o/<slug>/.well-known/openid-configuration
```

Mattermost Team Edition no admite OIDC genérico; ver [02-mattermost-chat.md](02-mattermost-chat.md).

## Incidencia: prefijo en el nombre de usuario

Tras conectar los servicios, el login SSO fallaba porque el nombre de usuario que llegaba desde Authentik incluía un prefijo que no coincidía con el de las cuentas ya creadas en cada servicio. Las cuentas afectadas se corrigieron con un `UPDATE` directo sobre la tabla de usuarios de la base de datos de Authentik, tras lo cual los identificadores coincidieron y el login funcionó en todos los servicios.

Antes de modificar la base de datos de Authentik conviene hacer un volcado:

```bash
docker compose exec postgresql pg_dump -U authentik authentik > authentik_$(date +%F).sql
```
