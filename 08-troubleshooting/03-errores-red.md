# Red

## No resuelve `*.ibis.local`

Comprobar la entrada en el `hosts` del cliente:

```
100.x.y.z  ibis.local auth.ibis.local nube.ibis.local chat.ibis.local mail.ibis.local
```

```bash
ipconfig /flushdns                          # Windows
sudo resolvectl flush-caches                # Linux
```

El sufijo `.local` está reservado para mDNS y algunos sistemas intentan resolverlo por multidifusión antes de leer `hosts`, lo que provoca esperas.

## UFW

```bash
sudo ufw status verbose
sudo ufw allow in on tailscale0
sudo ufw reload
```

## Certificado

```bash
openssl s_client -connect ibis.local:443 -servername ibis.local </dev/null 2>/dev/null \
  | openssl x509 -noout -subject -dates
```

## Tailscale

```bash
tailscale status
tailscale ping 100.x.y.z
sudo tailscale down && sudo tailscale up
```
