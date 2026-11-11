# Integración con otros servicios

## Correo (Mailcow)

Notificaciones del campus por SMTP autenticado contra el Postfix de Mailcow.

```javascript
const transporter = nodemailer.createTransport({
  host: 'postfix-mailcow',
  port: 587,
  secure: false,
  auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASSWORD },
  tls: { rejectUnauthorized: false }
});

await transporter.sendMail({
  from: 'noreply@ibis.local',
  to: alumno.email,
  subject: 'Nueva tarea publicada',
  html: `<p>Se ha publicado <strong>${tarea.titulo}</strong>.</p>`
});
```

`rejectUnauthorized: false` es necesario por el certificado autofirmado de Mailcow.

## Chat (Mattermost)

Avisos en canales mediante webhooks entrantes.

```javascript
await axios.post(process.env.MATTERMOST_WEBHOOK_URL, {
  text: 'Nueva tarea publicada en Seguridad'
});
```

## Ficheros (Nextcloud)

Acceso por WebDAV.

```javascript
await axios.get('http://nextcloud-mailcow/remote.php/dav/files/admin/Campus/', {
  auth: { username: process.env.NC_USER, password: process.env.NC_APP_PASSWORD }
});
```
