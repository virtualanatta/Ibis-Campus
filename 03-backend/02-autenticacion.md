# Autenticación

## Login

1. `POST /api/login` con email y contraseña.
2. Búsqueda del usuario por email.
3. Comparación con `bcrypt.compare` contra `password_hash`.
4. Emisión de un JWT firmado con `JWT_SECRET`, válido 8 horas.

```javascript
const usuario = await db.query('SELECT * FROM usuarios WHERE email = $1', [email]);
const valido = usuario && await bcrypt.compare(password, usuario.password_hash);
if (!valido) return res.status(401).json({ error: 'Credenciales inválidas' });

const token = jwt.sign(
  { userId: usuario.id, email: usuario.email, role: usuario.role_id },
  process.env.JWT_SECRET,
  { expiresIn: '8h' }
);
res.json({ token, usuario: { id: usuario.id, nombre: usuario.nombre } });
```

## Middleware

```javascript
function auth(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No autorizado' });

  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Token inválido' });
  }
}
```

## Contraseñas

```javascript
const hash = await bcrypt.hash(password, 10);
```

## SSO

El login unificado con el resto de servicios se resuelve con Authentik como proveedor OIDC. Ver [00-authentik-sso.md](../05-servicios/00-authentik-sso.md).
