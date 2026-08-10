# Grafana + Prometheus — Server A & B

Monitoring stack for hardware/resource stats (CPU, RAM, disk, network, temps) across both servers. Prometheus + Grafana run as containers on Server A only; Server B just runs a lightweight Node Exporter container that Prometheus scrapes remotely.

## Server A (Prometheus + Grafana + Node Exporter)

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "Grafana + Prometheus"
cd "Grafana + Prometheus"
touch docker-compose.yml prometheus.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml
# Docker Compose for Grafana + Prometheus
# Monitoring Stack: Prometheus + Grafana + Node Exporter
# Home Server: 192.168.50.2
services:
  prometheus:
    container_name: prometheus
    image: prom/prometheus:latest
    restart: unless-stopped
    volumes:
      - /Abrar_SMB/AppData/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - /Abrar_SMB/AppData/prometheus/data:/prometheus
    ports:
      - '9090:9090'

  grafana:
    container_name: grafana
    image: grafana/grafana:latest
    restart: unless-stopped
    volumes:
      - /Abrar_SMB/AppData/grafana:/var/lib/grafana
    ports:
      - '3000:3000'
    depends_on:
      - prometheus

  node-exporter:
    container_name: node-exporter
    image: prom/node-exporter:latest
    restart: unless-stopped
    network_mode: host
    pid: host
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
```

```bash
sudo nano prometheus.yml
```

```yaml
# prometheus.yml
# Home Server: 192.168.50.2
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets:
          - '192.168.50.2:9100'   # Server A (this box)
          - '192.168.50.1:9100'   # Server B (game server)
```

Prometheus and Grafana both read config/data from `/Abrar_SMB/AppData/`, not the folder next to `docker-compose.yml` — copy `prometheus.yml` there before first run:

```bash
mkdir -p /Abrar_SMB/AppData/prometheus/data
mkdir -p /Abrar_SMB/AppData/grafana
cp prometheus.yml /Abrar_SMB/AppData/prometheus/prometheus.yml
```

Grafana (UID `472`) and Prometheus (UID `65534`, "nobody") both need write access to their AppData folders, or they'll crash-loop on permission errors:

```bash
sudo chown -R 472:472 /Abrar_SMB/AppData/grafana
sudo chown -R 65534:65534 /Abrar_SMB/AppData/prometheus/data
```

```bash
docker compose up -d
sudo ufw allow 3000
sudo ufw allow 9090
sudo ufw allow from 192.168.50.1 to any port 9100
```

## Server B (Node Exporter only)

Server B doesn't run Prometheus or Grafana — just the exporter that feeds metrics to Server A's Prometheus instance.

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "Node Exporter"
cd "Node Exporter"
touch docker-compose.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml
# Node Exporter: Metrics for Prometheus (Game Server)
# Game Server: 192.168.50.1
services:
  node-exporter:
    container_name: node-exporter
    image: prom/node-exporter:latest
    restart: unless-stopped
    network_mode: host
    pid: host
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
```

```bash
docker compose up -d
sudo ufw allow from 192.168.50.2 to any port 9100
```

## Temperature sensors (both servers)

Node Exporter's `hwmon` collector reads temps from the host, but only if `lm-sensors` is installed and configured on the host OS itself — not something the container can do on its own.

```bash
sudo apt install lm-sensors -y
sudo sensors-detect   # accept defaults (YES) at each prompt
sensors                # confirm output shows real temps
```

Verify Node Exporter is actually exposing the data:

```bash
curl http://localhost:9100/metrics | grep hwmon_temp
```

## Grafana setup (web UI)

Access: `http://192.168.50.2:3000` (default login `admin`/`admin`, prompts for a new password on first login)

1. **Connections → Data sources → Add data source → Prometheus**
   URL: `http://prometheus:9090` (container name resolves since Grafana and Prometheus share the same Docker network)
2. **Dashboards → New → Import → ID `1860`** (Node Exporter Full) → select the Prometheus data source → Import
3. Use the `nodename` (or `instance`) dropdown at the top of the dashboard to switch between `abrar-home-server` and `abrar-game-server`

Only one Prometheus data source is needed in Grafana — both servers' metrics flow through it since `prometheus.yml` scrapes both Node Exporter targets.
