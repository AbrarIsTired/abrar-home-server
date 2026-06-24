# Homarr — Server A & B

Dashboard / home page for the server. Houses shortcuts to all other services and containers, and has integration with Docker itself.

```bash
cd "/Abrar_SMB/Container Configs"
mkdir Homarr
cd Homarr
touch docker-compose.yml

sudo nano docker-compose.yml
```

```yaml
# docker-compose.yml for Homarr
# Adapted from https://homarr.dev/docs/getting-started/installation/docker/
services:
  homarr:
    container_name: homarr
    image: ghcr.io/homarr-labs/homarr:latest
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock  # Optional, only if you want docker integration
      - /Abrar_SMB/AppData/homarr:/appdata
    environment:
      - SECRET_ENCRYPTION_KEY=GO_TO_HOMARR_WEBSITE_IT_WILL_GIVE_YOU_A_KEY
    ports:
      - '7575:7575'
```

> Watch for extra blank lines or tabs in the YAML — Docker Compose is picky about whitespace.

```bash
docker compose up -d
sudo ufw allow 7575
```

Access:

- http://192.168.50.1:7575/
- http://192.168.50.2:7575/
