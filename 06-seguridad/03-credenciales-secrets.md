# Secretos

## Dónde viven

| Secreto | Ubicación |
|---|---|
| Base de datos, JWT | `/mnt/TFG_CRIMSA/01_PROYECTO/.env` |
| Telegram y credenciales de los scripts | `~/.config/crimsa/env` |
| Servicios con compose propio | `.env` en el directorio de cada servicio |

Todos con permisos 600 y fuera del repositorio:

```bash
chmod 600 .env
echo ".env" >> .gitignore
```

## Uso desde compose

```yaml
environment:
  POSTGRES_PASSWORD: ${DB_PASSWORD}
```

## Generación

```bash
openssl rand -base64 32
```

## Reglas

- Ninguna contraseña en el código ni en los scripts. Se cargan desde el fichero de entorno.
- Nada sensible en URLs ni en logs.
- Las credenciales por defecto de cada imagen se cambian en el primer acceso.
- Un secreto que haya llegado a un repositorio se considera comprometido y se rota, aunque se elimine después.

## Siguiente paso

Docker *secrets* o un gestor como Vaultwarden o HashiCorp Vault, para no depender de variables de entorno visibles con `docker inspect`.
