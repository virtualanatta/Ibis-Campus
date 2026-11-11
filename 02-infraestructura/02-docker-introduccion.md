# Docker en Ibis Campus

## Instalación

Desde el repositorio oficial:

```bash
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"
```

## Convenciones del proyecto

- **Un directorio por servicio** en `/mnt/TFG_CRIMSA/services/`, con su `docker-compose.yml` y sus datos.
- **Bind mounts sobre el DAS** para todo lo persistente. Recrear un contenedor no afecta a los datos.
- **Secretos en `.env`**, referenciados como `${VARIABLE}` desde los ficheros compose.
- **`restart: unless-stopped`** en todos los servicios.
- **Sin puertos publicados** salvo los del proxy y los paneles de administración. El resto de servicios solo es accesible desde la red Docker.

## Redes

El proxy, el campus y su base de datos comparten la red `codigo_default`. Dentro de ella, los contenedores se resuelven por nombre:

```
crisma_back  →  crisma_db:5432
global-proxy →  crisma_front:8080, crisma_back:3005
```

Mailcow, Mattermost y Nextcloud se despliegan cada uno con su propio fichero compose y su propia red.

## Núcleo del campus

```yaml
services:
  database:
    image: postgres:15-alpine
    container_name: crisma_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - /mnt/TFG_CRIMSA/postgres_data:/var/lib/postgresql/data
    networks: [codigo_default]

  backend:
    build: ./backend
    container_name: crisma_back
    restart: unless-stopped
    environment:
      DB_HOST: crisma_db
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      JWT_SECRET: ${JWT_SECRET}
    volumes:
      - /mnt/TFG_CRIMSA/uploads:/app/uploads
    depends_on: [database]
    networks: [codigo_default]

  frontend:
    build: ./frontend
    container_name: crisma_front
    restart: unless-stopped
    depends_on: [backend]
    networks: [codigo_default]

networks:
  codigo_default:
    name: codigo_default
```

## Dockerfile de la API

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
USER node
EXPOSE 3005
CMD ["npm", "start"]
```

Con `.dockerignore`:

```
node_modules
.git
.env
```

## Healthcheck

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
  interval: 30s
  timeout: 5s
  retries: 3
```
