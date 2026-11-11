# Node.js y Express

## Estructura

```
backend/
├── src/
│   ├── index.js         arranque del servidor
│   ├── routes/          definición de rutas
│   ├── controllers/     lógica de cada recurso
│   ├── middleware/      autenticación y validación
│   ├── services/        correo, Mattermost, Nextcloud
│   └── models/          acceso a datos
├── Dockerfile
└── package.json
```

## Dependencias principales

`express`, `pg`, `bcryptjs`, `jsonwebtoken`, `cors`, `nodemailer`, `axios`.

## Ejecución

En el servidor, la API corre en el contenedor `crisma_back`, escucha en el puerto 3005 y solo es accesible a través del proxy en `ibis.local/api/`.

```bash
docker compose up -d --build backend
docker compose logs -f backend
```

En local:

```bash
npm install
npm run dev
```

La configuración (base de datos, `JWT_SECRET`) se lee de variables de entorno.
