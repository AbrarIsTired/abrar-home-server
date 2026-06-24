# Homelab Server Documentation

Documentation and update logs for my personal home server project — two repurposed machines turned into a small Linux server cluster, set up from a clean install.

## What this is

A laptop and a mini-PC, networked together, running as Linux servers for self-hosted services (media server, dashboard, file sharing, Minecraft hosting, monitoring). One server acts as the gateway, sharing its WiFi connection with the rest of the network over a switch.

## Skills demonstrated

- Linux server administration (Ubuntu Server, headless/no-GUI install)
- Networking: static IP configuration via netplan, NAT/IP forwarding, firewall rules (ufw)
- VPN setup (Tailscale) to work around network limitations
- Docker & Docker Compose (multi-container service deployment)
- Samba/SMB file sharing and disk mounting (fstab, permissions)
- Troubleshooting (AP isolation, WiFi power saving, suspend-on-lid-close)
- Documentation habits — this repo

## Devices

| Device | Nickname | IP | Role |
|---|---|---|---|
| Dell Precision 5530 (Laptop) | Server B | 192.168.50.1 | NAT gateway, game server host |
| Dell Optiplex 3050 (Mini-PC) | Server A | 192.168.50.2 | SMB share, main services host |
| Custom Build PC | Gaming PC | 192.168.50.3 | Client/workstation |

## Docs

- [01 — Network Setup](01-network-setup.md): netplan, NAT/gateway config, Tailscale
- [02 — Server Provisioning](02-server-provisioning.md): OS install, Samba, disk mounting, Docker install
- [03 — Services](03-services/): one file per self-hosted service
- [04 — Tailscale ACL](04-tailscale-acl.md): access control policy for friend/admin access over Tailscale
- [05 — Backups](05-backups.md): automated backup script, schedule, and debugging notes
- [CHANGELOG](CHANGELOG.md): dated log of work done

## Quick links (LAN only)

| Service | URL |
|---|---|
| Homarr Dashboard (Server A) | http://192.168.50.2:7575 |
| Homarr Dashboard (Server B) | http://192.168.50.1:7575 |
