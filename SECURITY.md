
# Security Model

This homelab is designed with layered security principles, focusing on minimizing exposure and controlling access.

---

## Network Isolation

- No services are exposed to the public internet.  
- All remote access is handled through Tailscale VPN.  
- LAN devices access services directly on the internal network.  

---

## Firewall Configuration (UFW)

- Host-based firewall enabled with deny-by-default policy.  
- Allowed ports:  
  - 22 (SSH, admin only)  
  - 25565 (Minecraft)  
  - 7777 (Terraria)  
- All other inbound connections are blocked.

---

## Access Control (Tailscale ACL)

- Users are segmented via tags: `server`, `friends`, `personal-device`.  
- Admins have full access to all services.  
- Friends can only access game server ports (25565, 7777).  
- Personal devices have full access for management purposes.  

---

## SSH Policy

- SSH uses key-based authentication only.  
- Password authentication is disabled.  
- SSH access is restricted to VPN-connected devices and admins only.

---

## Security Philosophy

- Keep infrastructure separate from personal accounts  
- Centralized, revocable access for remote users  
- Simplicity for maintainability
