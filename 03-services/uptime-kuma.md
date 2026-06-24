# Uptime Kuma — Server A

Self-hosted uptime/monitoring tool for tracking whether other services are up.

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "Uptime Kuma"
cd "Uptime Kuma"
touch docker-compose.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml for Uptime Kuma
services:
  uptime-kuma:
    image: louislam/uptime-kuma:2
    container_name: uptime-kuma
    restart: always
    ports:
      - "3001:3001"  # Maps container port 3001 to host port 3001
    volumes:
      - /Abrar_SMB/AppData/uptimekuma/data:/app/data  # Persistent storage
    environment:
      - TZ=EST       # Set to your local timezone so monitoring times match
      - UMASK=0022   # File permissions
    networks:
      - kuma_network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001"]
      interval: 30s
      retries: 3
      start_period: 10s
      timeout: 5s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

networks:
  kuma_network:
    driver: bridge
```

```bash
docker compose up -d
```

Setup happens in the web UI: `192.168.50.2:3001`
