# Hardware

## Servidor

| Componente | Especificación |
|---|---|
| Equipo | Intel NUC |
| CPU | Intel Core i5/i7, 12.ª generación |
| RAM | 32 GB |
| Disco | SSD NVMe 512 GB (sistema y Docker) |
| Red | Gigabit Ethernet |

## Almacenamiento

| Componente | Especificación |
|---|---|
| Equipo | DAS QNAP |
| Discos | 2 × 2 TB |
| Configuración | RAID 1 (espejo), 2 TB útiles |
| Conexión | USB 3 |
| Punto de montaje | `/mnt/TFG_CRIMSA` |

El SSD aloja el sistema, las imágenes de Docker y los backups. El DAS aloja los datos de todos los servicios.

## Red

El servidor está conectado al router del centro sin puertos abiertos ni reenvíos. El acceso remoto se hace exclusivamente por Tailscale.
