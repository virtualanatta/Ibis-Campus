# Nextcloud

Almacenamiento de alumnado y profesorado, con carpetas compartidas por asignatura. Los datos residen en el DAS.

## Despliegue

```yaml
services:
  nextcloud-db:
    image: mariadb:11
    container_name: nextcloud-mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: ${NC_DB_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${NC_DB_ROOT_PASSWORD}
    volumes:
      - /mnt/TFG_CRIMSA/services/nextcloud/db:/var/lib/mysql
    networks: [mailcow-network]

  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud-mailcow
    restart: unless-stopped
    depends_on: [nextcloud-db]
    environment:
      MYSQL_HOST: nextcloud-mysql
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: ${NC_DB_PASSWORD}
      NEXTCLOUD_ADMIN_USER: admin
      NEXTCLOUD_ADMIN_PASSWORD: ${NC_ADMIN_PASSWORD}
    volumes:
      - /mnt/TFG_CRIMSA/services/nextcloud/data:/var/www/html/data
      - /mnt/TFG_CRIMSA/services/nextcloud/config:/var/www/html/config
    networks: [mailcow-network]
```

Nextcloud comparte red con Mailcow, de ahí el nombre del contenedor.

## Configuración

```bash
occ() { docker exec --user www-data nextcloud-mailcow php occ "$@"; }

occ config:system:set trusted_domains 1 --value="nube.ibis.local"
occ config:system:set overwriteprotocol --value="https"
```

## Login con Authentik

Se instala la app `oidc_login` y se configura en `config/config.php`. Parámetros principales:

```php
'oidc_login_provider_url' => 'https://auth.ibis.local/application/o/nextcloud/',
'oidc_login_client_id' => '<client-id>',
'oidc_login_client_secret' => '<client-secret>',
'oidc_login_attributes' => [
    'id' => 'preferred_username',
    'mail' => 'email',
    'name' => 'name',
],
'oidc_login_tls_verify' => false,
```

`oidc_login_tls_verify` está desactivado por el certificado autofirmado de Authentik. El atributo `id` es el que tiene que coincidir con el usuario existente en Nextcloud, y fue uno de los puntos afectados por el problema del prefijo descrito en [00-authentik-sso.md](00-authentik-sso.md).

## Organización

- Un usuario por alumno y profesor.
- *Group folders* por asignatura (p. ej. `2509_ASIX_0378_Seguretat`), con cuota y acceso por grupo.

## Incidencias

| Síntoma | Causa | Solución |
|---|---|---|
| *Access through untrusted domain* | Dominio no registrado | `occ config:system:set trusted_domains` |
| Error interno al subir ficheros | Volúmenes sin permisos para `www-data` | `sudo chown -R 33:33 .../nextcloud/{data,config}` |
| `413 Request Entity Too Large` | Límite de subida del proxy | `client_max_body_size 512M` en el host |
