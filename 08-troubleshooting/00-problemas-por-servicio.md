# Problemas por servicio

## Campus

| Síntoma | Causa | Solución |
|---|---|---|
| `502 Bad Gateway` | El proxy no alcanza `crisma_front` | Comprobar que el contenedor está en `codigo_default` y el nombre/puerto del host |
| Error de CORS en el navegador | Frontend en desarrollo con otro origen | Origen permitido en `cors()` de la API |
| Credenciales rechazadas | Hash o usuario inexistente | Revisar la tabla `usuarios` |

## Authentik

| Síntoma | Causa | Solución |
|---|---|---|
| Login SSO rechazado por los servicios | Prefijo en el nombre de usuario enviado | `UPDATE` sobre la base de datos de Authentik ([detalle](../05-servicios/00-authentik-sso.md)) |

## Nextcloud

| Síntoma | Causa | Solución |
|---|---|---|
| *Access through untrusted domain* | Dominio no registrado | `occ config:system:set trusted_domains` |
| Error interno al subir | Volúmenes sin permisos para `www-data` | `chown -R 33:33` |
| `413 Request Entity Too Large` | Límite del proxy | `client_max_body_size 512M` |

## Mattermost

| Síntoma | Causa | Solución |
|---|---|---|
| Mensajes que no aparecen hasta recargar | WebSockets cortados en el proxy | Cabeceras `Upgrade` y `Connection` |
| Fallo de escritura en `config` | Volúmenes sin permisos para UID 2000 | `chown -R 2000:2000` |
| `INVALID_PASSWORD` al crear usuarios | Política de contraseñas | Contraseñas que cumplan la política |

## Mailcow

| Síntoma | Causa | Solución |
|---|---|---|
| No arranca: puertos ocupados | 80/443 en uso por el proxy | `HTTP_PORT=8181`, `HTTPS_PORT=8444` |
| `mysql-mailcow` en bucle (*Errno 13*) | Permisos del directorio de datos | Restaurar propietario y `docker compose up -d` |
| Redirecciones infinitas en SOGo | Acceso por IP | Acceder por `mail.ibis.local` |
| El backend no envía correo | Envío sin autenticar | SMTP autenticado en 587 |

## Proxy

| Síntoma | Causa | Solución |
|---|---|---|
| `502 Bad Gateway` | Destino caído o en otra red | `docker logs global-proxy` y `docker exec global-proxy ping <destino>` |
| Aviso de certificado | Certificado autofirmado | Esperado; regenerar si ha caducado |
