# Changelog

Dated log of work done on the server. Setup/explainer content lives in the numbered docs and [03-services/](03-services/); this file is the running history.

## 6/8/2026 — Back Up Important Files

Backed up Server A's important contents from `/DATA` (the SMB folder in root) to a secondary drive.

```bash
cp -rp "Directory" "/DATA/SSD/"
```

## 6/9/2026 — Format/Reset Servers + Setup

- Swapped drives between Server A and B (Server A: 256GB → 512GB NVMe, for more SMB storage; Server B: 512GB → 256GB NVMe)
- Installed Ubuntu Server Minimized on both machines — see [01-network-setup.md](01-network-setup.md) and [02-server-provisioning.md](02-server-provisioning.md)
- Set up NAT/gateway on Server B, installed Tailscale, moved Gaming PC to Ethernet to fix AP isolation

## 6/10/2026 — Samba/File Sharing & Storage

- Set up Samba on both servers, mounted secondary SSD on Server A — see [02-server-provisioning.md](02-server-provisioning.md)

## 6/10/2026 — Docker Setup

- Installed Docker + Compose on both servers
- Deployed Homarr, CraftyController, Jellyfin, Syncthing, Uptime Kuma — see [03-services/](03-services/)

---

This marks the end of initial setup/guide-style entries. The original project goal — SSH access from LAN and WAN, a working dashboard, Samba share, and core containers — is met as of this point. Future entries below (and going forward) are logs of new services, troubleshooting, and changes.

## 6/24/2026 — Backup Script + Cron Setup

- Transferred backup script from previous server to Server A, updating hardcoded paths to match the new `/Abrar_SMB` layout
- Fixed script failing to run due to Windows line endings (CRLF) from prior editing
- Installed missing `zip` dependency
- Debugged a misleading `zip I/O error: Disk quota exceeded` — root cause was the script staging zips in `/tmp` (RAM-backed `tmpfs`), not an actual disk quota; fixed by writing zips directly to the backup destination — see [05-backups.md](05-backups.md)
- Set cron to run `backup.sh` daily at 3 AM
