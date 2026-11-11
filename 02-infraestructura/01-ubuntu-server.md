# Ubuntu Server 24.04

## Instalación

Instalación estándar desde la ISO oficial con:

- LVM sobre el SSD
- OpenSSH Server
- Actualizaciones de seguridad automáticas (`unattended-upgrades`)

## Configuración base

```bash
sudo hostnamectl set-hostname ibis-campus
sudo timedatectl set-timezone Europe/Madrid
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git htop fail2ban
```

## SSH

`/etc/ssh/sshd_config`:

```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

```bash
sudo sshd -t && sudo systemctl restart ssh
```

Antes de desactivar las contraseñas, comprobar que el inicio de sesión con clave funciona desde otra terminal.

## fail2ban

Instalado con la configuración por defecto, que protege `sshd`. Con el servidor sin exposición a Internet su papel es secundario, pero cubre intentos desde la red local.
