# Jellyfin — Server A

Self-hosted media server.

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "Jellyfin"
cd "Jellyfin"
touch docker-compose.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml for Jellyfin
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    ports:
      - 8096:8096/tcp
      - 7359:7359/udp
    volumes:
      - /Abrar_SMB/AppData/jellyfin/config:/config
      - /Abrar_SMB/AppData/jellyfin/cache:/cache
      - type: bind
        source: /Abrar_SMB/AppData/jellyfin/media
        target: /media
    restart: unless-stopped
    extra_hosts:
      - 'host.docker.internal:host-gateway'
```

```bash
docker compose up -d
sudo ufw allow 8096
```

Access: `192.168.50.2:8096`
