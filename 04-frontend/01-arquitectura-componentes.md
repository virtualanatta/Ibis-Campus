# Arquitectura

## Páginas

| Página | Uso |
|---|---|
| `LoginPage` | Inicio de sesión |
| `DashboardPage` | Resumen tras el login |
| `AlumnoPage` | Cursos, tareas y entregas del alumno |
| `ProfesorPage` | Gestión de cursos y tareas |
| `AdminPage` | Usuarios y estado del sistema |

## Componentes

`Navbar`, `Sidebar`, `Card`, `Modal`, `Form` y `Table`, compartidos por todas las vistas.

## Estado de sesión

`AuthContext` expone el usuario y las acciones de sesión al resto de la aplicación:

```javascript
const { user, token, isAuthenticated, login, logout } = useContext(AuthContext);
// user: { id, email, nombre, role }
```
