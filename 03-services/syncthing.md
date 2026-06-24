# Syncthing — Server A

File sync service, used to keep music and Obsidian vaults synced across devices.

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "Syncthing"
cd "Syncthing"
touch docker-compose.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml for Syncthing
services:
  syncthing:
    image: lscr.io/linuxserver/syncthing:latest
    container_name: syncthing
    hostname: syncthing-server  # Unique identifier for this instance
    environment:
      - PUID=1000          # Matches file permissions to your host user
      - PGID=1000          # Matches file permissions to your host group
      - TZ=America/New_York
    volumes:
      - /Abrar_SMB/AppData/syncthing/config:/config  # App configuration and database
      - /Abrar_SMB/AppData/syncthing/data:/data1     # Default sync folder path
      - /Abrar_SMB:/Abrar_SMB
    ports:
      - 8384:8384       # Web UI
      - 22000:22000/tcp # TCP sync protocol traffic
      - 22000:22000/udp # QUIC sync protocol traffic
      - 21027:21027/udp # Local discovery broadcasts
    restart: unless-stopped
```

```bash
mkdir "Syncs"
cd "Syncs"
mkdir "Obsidian Vault"
```

Setup happens in the web UI: `192.168.50.2:8384`
