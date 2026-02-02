# Home Server Infrastructure

A personal homelab built on refurbished hardware running Ubuntu Server and CasaOS. Server features services such as centralized file storage, media hosting, game servers, and automated backups.

---

## Primary Server - Media & File Infrastructure

**Hardware:**
- Dell Optiplex 3050 (07A3)
- Intel Core i5-6500T
- 8GB DDR4 SODIMM 2667MHz
- 256GB NVMe

**OS:** Ubuntu Server 24.04 LTS  
**Dashboard:** CasaOS

### Services

**Samba (NAS/File Sharing)**
Network-attached storage for centralized file management and backup across devices on the LAN. Provides secure, accessible storage for documents, media, and project files.

**Jellyfin (Media Hosting)**
Self-hosted media server for remote access to personal digital media library and film collection on the local network without relying on third-party streaming services.

**Syncthing (Automated Backups)**
Continuous file synchronization tool that automatically backs up the music library, obsidian markdown notes and Python Discord bot project across devices, ensuring data redundancy.

**Discord Bot (Python)**
Custom Python-based Discord bot running persistently in a virtual environment, providing utility functions and server status checks for personal use.

**Tailscale VPN**
Secure remote access layer enabling WAN connectivity to home server resources from outside the local network with ACL-based access control.

---

## Secondary Server - Game Infrastructure

**Hardware:**
- Dell Precision 5530 (087D)
- Intel Core i7-8850H
- 32GB DDR4 SODIMM 2400MHz
- 512GB NVMe

**OS:** Ubuntu Server 24.04 LTS

### Services

**CraftyController (Game Server Management)**
Self-hosted web dashboard for centralized management of Minecraft server, including player management, plugin/mod configuration, and server monitoring from a single interface.

**Minecraft Server (Fabric + Performance Mods)**
Dedicated game server running the Fabric mod loader with performance optimization mods (Sodium and others), hosting 10+ players with centralized management via CraftyController dashboard.

**Terraria Server**
Persistent Terraria game server instance running in a screen session, providing continuous uptime for invited players without resource conflicts with other services.

**Tailscale VPN**
Secure remote access with ACL-based restrictions limiting friend access to game server ports (25565 for Minecraft, 7777 for Terraria) while isolating internal infrastructure services.

---
## Why This Setup

Built to learn infrastructure management hands-on while creating a reliable, secure system for personal use. The separation of services across two servers allows for optimized resource allocation. Media and file services on the lower-spec machine, resource-intensive game servers on the higher-spec hardware.
