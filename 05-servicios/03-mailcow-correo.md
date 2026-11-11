# Mailcow

Correo institucional del dominio `ibis.local`: SMTP, IMAP, webmail (SOGo), antispam y DKIM.

## Instalación

```bash
cd /mnt/TFG_CRIMSA/services
git clone https://github.com/mailcow/mailcow-dockerized mailcow
cd mailcow
./generate_config.sh      # FQDN: mail.ibis.local, zona horaria Europe/Madrid
```

## `mailcow.conf`

```ini
HTTP_PORT=8181
HTTPS_PORT=8444
HTTP_BIND=0.0.0.0
SKIP_CLAMD=y
```

- **Puertos.** El proxy ya ocupa 80 y 443, así que la interfaz web de Mailcow se movió a 8181/8444 y se publica a través del proxy como `mail.ibis.local`.
- **ClamAV desactivado.** Ahorra unos 2 GB de RAM.

```bash
docker compose pull
docker compose up -d
```

El panel queda en `https://mail.ibis.local`. La contraseña inicial del administrador se cambia en el primer acceso.

## Buzones

Desde el panel (*Mailboxes → Add mailbox*) o por API:

```bash
curl -sk -X POST https://mail.ibis.local/api/v1/add/mailbox \
  -H "X-API-Key: $MAILCOW_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"local_part":"alumno1","domain":"ibis.local","name":"Alumno 1","password":"...","password2":"...","quota":"51200","active":"1"}'
```

La cuota se indica en MiB. Con el espacio del DAS se asignaron 50 GB por buzón.

## DKIM y SPF

Mailcow genera la clave DKIM del dominio (*Configuration → ARC/DKIM keys*). Al ser un dominio interno no se publicaron registros DNS; con un dominio real se añadirían el registro DKIM y uno SPF del tipo `v=spf1 mx -all`.

## Incidencias

| Síntoma | Causa | Solución |
|---|---|---|
| `mysql-mailcow` en bucle de reinicios (*Errno 13*) | Permisos del directorio de datos | Restaurar el propietario esperado por la imagen y reiniciar con `docker compose up -d` |
| Bucle de redirecciones en SOGo | La cookie de sesión no se valida al entrar por IP | Acceder siempre por nombre (`mail.ibis.local`) |
| El backend no podía enviar correo | Envío sin autenticar | SMTP autenticado en el puerto 587 ([04-integracion-servicios.md](../03-backend/04-integracion-servicios.md)) |

Nunca usar `docker compose down -v` en Mailcow para corregir un problema: elimina los volúmenes con los buzones.
