# Pruebas con curl

## API del campus

```bash
TOKEN=$(curl -sk -X POST https://ibis.local/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"usuario@ibis.local","password":"..."}' | jq -r .token)

curl -sk https://ibis.local/api/cursos -H "Authorization: Bearer $TOKEN" | jq .
```

## Mailcow

```bash
curl -sk https://mail.ibis.local/api/v1/get/mailbox/all -H "X-API-Key: $MAILCOW_API_KEY" | jq .
```

## Mattermost

```bash
curl -sk https://chat.ibis.local/api/v4/system/ping
```

## Opciones habituales

| Opción | Uso |
|---|---|
| `-k` | Aceptar certificados autofirmados |
| `-s` | Sin barra de progreso |
| `-I` | Solo cabeceras |
| `-v` | Detalle de la conexión y TLS |
| `-H` | Cabecera |
| `-d` | Cuerpo de la petición |
| `-F 'file=@f.pdf'` | Envío de ficheros |
