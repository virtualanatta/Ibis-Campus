# Requisitos previos

## Hardware

| Componente | Usado en el proyecto | Mínimo razonable |
|---|---|---|
| Servidor | Intel NUC (Core i5/i7, 12.ª gen.) | Core i5 |
| RAM | 32 GB | 16 GB |
| Disco del sistema | SSD NVMe 512 GB | 256 GB |
| Almacenamiento de datos | DAS QNAP, 2 × 2 TB en RAID 1 (2 TB útiles) | 1 TB útil |

Con 16 GB la plataforma arranca, pero Mailcow, Nextcloud y Mattermost juntos dejan poco margen. Desactivar ClamAV en Mailcow libera unos 2 GB.

## Software

| Herramienta | Versión |
|---|---|
| Ubuntu Server | 24.04 LTS |
| Docker Engine | 27 o superior |
| Docker Compose (plugin) | 2.20 o superior |
| Git, curl | Las de los repositorios de Ubuntu |

## Cuentas y credenciales

- **Tailscale.** Una cuenta para registrar el servidor y los clientes.
- **Bot de Telegram.** Token creado con `@BotFather` y el ID del chat de administración (se obtiene con `@userinfobot`).
- **Dominio (opcional).** Solo necesario para certificados Let's Encrypt. El proyecto usó dominios `.local` con certificados autofirmados.

## Estructura en el DAS

```bash
sudo mkdir -p /mnt/TFG_CRIMSA/{01_PROYECTO/{CODIGO/{backend,frontend},scripts/IbisScripts},services,postgres_data,uploads,05_LOGS}
sudo chown -R "$USER:$USER" /mnt/TFG_CRIMSA
```

```
/mnt/TFG_CRIMSA/
├── 01_PROYECTO/
│   ├── CODIGO/           backend y frontend del campus
│   ├── scripts/          scripts de operación
│   └── .env
├── services/             un directorio por servicio: compose y datos
├── postgres_data/        datos de crisma_db
├── uploads/              entregas de los alumnos
└── 05_LOGS/
```

Los servicios se instalan siempre sobre el DAS, nunca sobre el SSD del sistema. Los backups semanales se guardan en el SSD (`~/Backups`), de modo que datos y copias quedan en discos distintos.

## Variables de entorno

Partir de [`.env.example`](../.env.example):

```bash
cp .env.example /mnt/TFG_CRIMSA/01_PROYECTO/.env
chmod 600 /mnt/TFG_CRIMSA/01_PROYECTO/.env
```

Generar los secretos en lugar de inventarlos:

```bash
openssl rand -base64 32   # DB_PASSWORD, JWT_SECRET
```

## Comprobación

- [ ] Ubuntu Server 24.04 instalado y con SSH
- [ ] DAS montado en `/mnt/TFG_CRIMSA`
- [ ] Docker y Compose funcionando
- [ ] Servidor y cliente unidos a Tailscale
- [ ] `.env` creado con permisos 600
- [ ] Token y chat de Telegram disponibles
