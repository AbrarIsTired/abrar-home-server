# Architecture Overview

## High-Level Design

The environment consists of two physical servers, separated by workload type:

1. Media & File Services  
2. Game Server Infrastructure

This separation ensures that CPU-intensive game workloads do not impact file storage or media streaming performance.

---

## Workload Allocation

### Primary Server (Media / Storage)

Handles:
- Samba file sharing (LAN)
- Jellyfin media hosting
- Syncthing file synchronization
- Discord bot monitoring utility

These services are primarily I/O-bound and low CPU intensity.  
Managed using CasaOS for simplified container lifecycle control.

---

### Secondary Server (Games)

Handles:
- Minecraft server (Fabric + performance mods)
- Terraria server
- CraftyController management dashboard

Game servers are CPU-intensive and require consistent uptime. Hosting them on a higher-spec system prevents resource contention.  
Also managed using CasaOS for simplified container lifecycle control.

---

## Network & Remote Access

- No WAN port forwarding is configured.  
- Remote access is handled exclusively through Tailscale VPN.  
- LAN devices access services directly on the internal network.

### VPN Provisioning

Remote users are manually onboarded:

1. Tailscale client is installed on the device.  
2. Device is authenticated through a dedicated member account managed by the administrator.  
3. ACL tags restrict access to only the required game server ports (25565 for Minecraft, 7777 for Terraria).  

This approach provides:

- Encrypted, authenticated remote access  
- Centralized access management  
- Controlled, revocable permissions  
- No exposure of infrastructure services to the public internet

Port forwarding was avoided due to router passthrough instability in the mesh network and administrative restrictions.
