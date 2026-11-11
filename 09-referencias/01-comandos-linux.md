# Linux

## Servicios y logs

```bash
systemctl status <servicio>
sudo systemctl restart <servicio>
journalctl -u <servicio> -f
```

## Disco y memoria

```bash
df -h
du -sh /mnt/TFG_CRIMSA/* | sort -h
lsblk -f
free -h
```

## Red

```bash
ip -br addr
ss -tlnp
sudo ufw status verbose
tailscale status
```

## Permisos

```bash
chmod 600 <fichero>
sudo chown -R <uid>:<gid> <directorio>
lsattr <fichero>
```
