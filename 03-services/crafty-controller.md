# CraftyController — Server B

Web-based control panel for hosting and managing Minecraft servers (Java + Bedrock).

```bash
cd "/Abrar_SMB/Container Configs"
mkdir "CraftyController"
cd "CraftyController"
touch docker-compose.yml
sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml for CraftyController
services:
    crafty:
        container_name: crafty_container
        image: registry.gitlab.com/crafty-controller/crafty-4:latest
        restart: always
        environment:
            - TZ=Etc/UTC
        ports:
            - "8443:8443"            # HTTPS
            - "8123:8123"            # Dynmap
            - "19132:19132/udp"      # Bedrock
            - "25500-25600:25500-25600"  # MC server port range
        volumes:
            - /Abrar_SMB/AppData/crafty/backups:/crafty/backups
            - /Abrar_SMB/AppData/crafty/logs:/crafty/logs
            - /Abrar_SMB/AppData/crafty/servers:/crafty/servers
            - /Abrar_SMB/AppData/crafty/config:/crafty/app/config
            - /Abrar_SMB/AppData/crafty/import:/crafty/import
```

```bash
docker compose up -d
sudo ufw allow 8443
```

Access: `192.168.50.1:8443`

Stock login details: `/Abrar_SMB/AppData/crafty/config/default-creds.txt`
