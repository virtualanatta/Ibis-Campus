# Certificados en el proxy

Todos los hosts de Nginx Proxy Manager usan certificado autofirmado con *Force SSL*. La política de certificados y sus alternativas están en [04-ssl-certificados.md](../06-seguridad/04-ssl-certificados.md).

1. Host → pestaña *SSL*.
2. Certificado autofirmado.
3. *Force SSL* activado.

Los servicios que validan TLS entre sí (Nextcloud contra Authentik, el backend contra Mailcow) tienen la verificación desactivada por este motivo.
