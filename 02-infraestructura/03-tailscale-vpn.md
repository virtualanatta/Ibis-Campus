# Tailscale

Única vía de acceso remoto al servidor. Evita abrir puertos en el router y cifra el tráfico con WireGuard.

## Servidor

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
tailscale ip -4
```

La IP asignada (`100.x.y.z`) es la que usan los clientes en su fichero `hosts` y la que aparece en el resto de la documentación.

## Clientes

Cliente oficial de [tailscale.com/download](https://tailscale.com/download), con sesión en la misma tailnet.

```bash
tailscale status
ping 100.x.y.z
```
