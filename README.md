# Home Server Infrastructure

Personal homelab environment built on refurbished hardware running Ubuntu Server 24.04 LTS.

Designed to provide secure remote access, centralized storage, media hosting, and multiplayer game infrastructure while maintaining strict network isolation and zero public port exposure.

---

## Infrastructure Overview

The environment is divided across two physical servers:

- Primary Server – Media & File Infrastructure
- Secondary Server – Game Infrastructure

Workloads are separated to prevent CPU-intensive game services from impacting storage and media performance.

All remote access is handled through Tailscale VPN. No services are exposed directly to the public internet.

---

# Primary Server – Media & File Infrastructure

**Hardware**
- Dell Optiplex 3050
- Intel Core i5-6500T
- 8GB DDR4
- 256GB NVMe

**OS:** Ubuntu Server 24.04 LTS  
**Management/Dashboard:** CasaOS

## Services

### Samba (Network File Storage)
Provides centralized file storage across LAN devices. Used for document management, media storage, and local backups. Accessible internally only.

### Jellyfin (Media Hosting)
Self-hosted media server used to stream personal digital media across the LAN or via secure VPN connection. Eliminates reliance on third-party streaming services.

### Syncthing (Automated Synchronization)
Continuous file synchronization tool used to replicate important directories (music library, notes, project files) across devices for redundancy.

### [Discord Bot](https://github.com/AbrarIsTired/vector-discord-bot) (Python Utility)
Custom Python-based bot running persistently in a virtual environment.  
Includes server monitoring command (`v!status`) which checks game server ports (25565 and 7777) and returns an embedded status response (online/offline).

---

# Secondary Server – Game Infrastructure

**Hardware**
- Dell Precision 5530
- Intel Core i7-8850H
- 32GB DDR4
- 512GB NVMe

**OS:** Ubuntu Server 24.04 LTS
**Management/Dashboard:** CasaOS

## Services

### CraftyController (Game Management Dashboard)
Web-based management interface for Minecraft server administration. Provides centralized player management, configuration control, and server monitoring.

### Minecraft Server (Fabric + Performance Mods)
Dedicated Minecraft server running Fabric mod loader with performance-focused mods. Hosts 8+ concurrent players with stable resource allocation.

### Terraria Server
Persistent Terraria server running in a managed screen session. Designed for continuous uptime without interfering with other workloads.

---

# Network & Access Model

- No router port forwarding configured.
- All remote access handled via Tailscale VPN.
- UFW enabled with deny-by-default firewall policy.
- Friends restricted to game server ports only (25565, 7777).
- Infrastructure services are not accessible to non-admin users.

---

# Project Goals

- Gain hands-on infrastructure management experience.
- Implement layered security controls.
- Separate workloads based on hardware capability.
- Maintain a reproducible and documented deployment model.
