# Configuración inicial

## Montaje del DAS

Se monta por UUID para que no dependa del orden en que el kernel detecta los discos.

```bash
lsblk -f
sudo blkid /dev/sda1
sudo mkdir -p /mnt/TFG_CRIMSA
```

`/etc/fstab`:

```
UUID=<uuid-del-volumen>  /mnt/TFG_CRIMSA  ext4  defaults,nofail  0  2
```

```bash
sudo mount -a
df -h /mnt/TFG_CRIMSA
```

`nofail` evita que el servidor se quede bloqueado en el arranque si el DAS no está conectado.

## Resolución de nombres en los clientes

Sin DNS interno, cada cliente resuelve los servicios con su fichero `hosts`.

```
100.x.y.z  ibis.local auth.ibis.local nube.ibis.local chat.ibis.local mail.ibis.local
```

- Windows: `C:\Windows\System32\drivers\etc\hosts` (como administrador) y después `ipconfig /flushdns`.
- Linux: `/etc/hosts`.

## Tailscale

Ver [03-tailscale-vpn.md](../02-infraestructura/03-tailscale-vpn.md).

## Firewall

Ver [04-firewall-ufw.md](../02-infraestructura/04-firewall-ufw.md). La regla para `tailscale0` debe existir antes de activar UFW en remoto.
