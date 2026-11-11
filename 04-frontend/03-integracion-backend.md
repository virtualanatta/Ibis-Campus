# Integración con la API

## Cliente

```javascript
import axios from 'axios';

const api = axios.create({ baseURL: '/api' });

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) window.location.href = '/login';
    return Promise.reject(err);
  }
);

export default api;
```

## CORS

En producción, frontend y API comparten origen (`ibis.local` y `ibis.local/api`) a través del proxy, así que no hay peticiones cruzadas. CORS solo es necesario en desarrollo, con Vite en el puerto 5173:

```javascript
app.use(cors({ origin: 'http://localhost:5173', credentials: true }));
```
