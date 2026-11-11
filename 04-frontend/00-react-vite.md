# React y Vite

## Estructura

```
frontend/
├── src/
│   ├── main.jsx
│   ├── App.jsx
│   ├── pages/        vistas por rol
│   ├── components/   componentes reutilizables
│   ├── context/      AuthContext
│   ├── services/     cliente de la API
│   └── styles/
├── public/
│   └── estado_sistema.json   generado por scripts-bash/generar_dashboard.sh
├── index.html
└── vite.config.js
```

## Ejecución

```bash
npm install
npm run dev       # desarrollo
npm run build     # build de producción en dist/
```

## Contenedor

En el servidor, el contenedor `crisma_front` ejecutaba el servidor de Vite expuesto en la red Docker:

```yaml
frontend:
  build: ./frontend
  container_name: crisma_front
  command: npm run dev -- --host 0.0.0.0 --port 8080
  networks: [codigo_default]
```

Para producción, lo adecuado es servir `dist/` con nginx en una imagen multietapa.
