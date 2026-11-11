# Certificados

## Situación del proyecto

Certificados autofirmados generados por Nginx Proxy Manager para cada host. El tráfico va cifrado, pero los navegadores muestran un aviso y los servicios que se validan entre sí necesitan desactivar la verificación.

## Alternativas

| Opción | Requisito | Comentario |
|---|---|---|
| Let's Encrypt (HTTP-01) | Dominio público y puerto 80 accesible | Incompatible con no exponer el servidor |
| Let's Encrypt (DNS-01) | Dominio público con API DNS | Certificados válidos sin abrir puertos |
| Certificados de Tailscale | HTTPS activado en la tailnet | Válidos para `*.ts.net` |
| CA interna (step-ca) | Distribuir la CA a los clientes | Control total en una red cerrada |

Nginx Proxy Manager renueva automáticamente los certificados de Let's Encrypt antes de su caducidad a los 90 días.
