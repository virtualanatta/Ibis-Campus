# Modelo de seguridad

## Principios

- **Sin exposición a Internet.** Ningún puerto abierto en el router; acceso remoto solo por Tailscale.
- **Defensa en capas.** Router, VPN, firewall del host y aislamiento de redes Docker.
- **Superficie mínima.** Solo el proxy y los paneles de administración publican puertos; bases de datos y APIs quedan en redes internas.
- **Identidad centralizada.** Cuentas gestionadas desde Authentik.
- **Secretos fuera del código.** Ficheros `.env` con permisos 600, excluidos de Git.
- **Visibilidad.** Alertas por Telegram de accesos SSH y del estado de los servicios.

## Capas

| Capa | Control |
|---|---|
| Perímetro | Router sin reenvío de puertos, UPnP y DMZ desactivados |
| Red | Tailscale (WireGuard) y UFW con entrada denegada por defecto |
| Host | SSH solo con clave, sin login de root, fail2ban, actualizaciones automáticas |
| Contenedores | Redes Docker separadas, sin puertos publicados salvo los necesarios |
| Aplicación | Contraseñas con bcrypt, JWT con caducidad, SSO por OIDC |
| Datos | DAS en RAID 1, backups semanales en otro disco |

## Limitaciones conocidas

- Los puertos publicados por Docker no pasan por UFW ([04-firewall-ufw.md](../02-infraestructura/04-firewall-ufw.md)).
- Los certificados autofirmados obligan a desactivar la verificación TLS entre algunos servicios.
- Los backups se guardan en el mismo servidor; no hay copia externa.
- El token del campus se almacena en `localStorage`.
