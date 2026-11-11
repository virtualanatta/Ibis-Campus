# Instalación de Docker

Instalación desde el repositorio oficial de Docker. El procedimiento completo y las convenciones del proyecto están en [02-docker-introduccion.md](../02-infraestructura/02-docker-introduccion.md).

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"
newgrp docker

docker --version
docker compose version
```

Pertenecer al grupo `docker` equivale en la práctica a tener acceso root. Solo se añadió el usuario de administración.
