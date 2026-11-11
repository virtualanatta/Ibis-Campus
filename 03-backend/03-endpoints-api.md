# Endpoints

Base: `https://ibis.local/api` (internamente `http://crisma_back:3005/api`). Todas las rutas salvo `/login` y `/register` requieren `Authorization: Bearer <token>`.

## Usuarios

| Método | Ruta | Descripción |
|---|---|---|
| POST | `/login` | Inicio de sesión |
| POST | `/register` | Alta de usuario |
| GET | `/users` | Listado (administración) |
| GET | `/users/:id` | Detalle |
| PUT | `/users/:id` | Modificación |
| DELETE | `/users/:id` | Baja |

## Cursos

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/cursos` | Cursos del usuario |
| GET | `/cursos/:id` | Detalle |
| POST | `/cursos` | Creación (profesorado) |
| PUT | `/cursos/:id` | Modificación |
| DELETE | `/cursos/:id` | Baja |

## Tareas y entregas

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/tareas` | Tareas de los cursos del usuario |
| POST | `/tareas` | Publicación (profesorado) |
| GET | `/entregas` | Entregas del alumno |
| POST | `/entregas` | Entrega de una tarea |

## Ejemplo

```bash
curl -k -X POST https://ibis.local/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"alumno@ibis.local","password":"..."}'
```

```json
{
  "token": "eyJhbGciOi...",
  "usuario": { "id": 1, "nombre": "Alumno" }
}
```
