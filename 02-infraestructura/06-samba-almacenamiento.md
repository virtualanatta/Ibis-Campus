# Samba

Acceso al DAS como unidad de red desde los equipos de administración, limitado a la interfaz de Tailscale.

## Instalación

```bash
sudo apt install -y samba
sudo smbpasswd -a gerard
```

## `/etc/samba/smb.conf`

```ini
[global]
   interfaces = lo tailscale0
   bind interfaces only = yes
   server min protocol = SMB3

[TFG_CRIMSA]
   path = /mnt/TFG_CRIMSA
   valid users = gerard
   read only = no
   create mask = 0755
```

```bash
testparm
sudo systemctl restart smbd
```

## Acceso

```
\\100.x.y.z\TFG_CRIMSA
```

## Incidencia: el recurso no aparecía en la red

Con la VPN activa, el servidor no se veía en el explorador de red. El router del centro bloqueaba NetBIOS, que es lo que usa Windows para descubrir equipos. Conectando directamente por la IP de Tailscale el recurso funciona con normalidad.
