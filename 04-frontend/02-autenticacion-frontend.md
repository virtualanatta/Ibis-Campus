# Autenticación en el frontend

## Login

```javascript
const handleLogin = async (email, password) => {
  const { data } = await api.post('/login', { email, password });
  localStorage.setItem('token', data.token);
  setUser(data.usuario);
  navigate('/dashboard');
};

const logout = () => {
  localStorage.removeItem('token');
  setUser(null);
  navigate('/login');
};
```

## Rutas protegidas

```javascript
function ProtectedRoute({ children }) {
  const { isAuthenticated } = useContext(AuthContext);
  return isAuthenticated ? children : <Navigate to="/login" />;
}
```

## Almacenamiento del token

El token se guarda en `localStorage` por simplicidad. Cualquier script que se ejecute en la página puede leerlo, de modo que un XSS permitiría robar la sesión. La alternativa es que la API lo entregue en una cookie `HttpOnly`, `Secure` y `SameSite=Strict`.
