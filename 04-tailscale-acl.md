# Tailscale ACLs

Access control policy for the Tailscale network connecting both home servers. Mainly used so friends can reach the game servers without exposing them to the open internet — most actual traffic on this is to the Minecraft/game server, with Jellyfin as secondary.

## Design

- **Admin** (`autogroup:admin`) — full access to everything. This is me.
- **Personal devices** (`tag:personal-device`) — also full access. Covers my own other devices (phone, gaming PC, etc.) that aren't the servers themselves.
- **Friends** (`tag:friends`) — locked down to specific ports only:
  - `25565` — Minecraft
  - `7777` — Terraria
  - `8096` — Jellyfin
  - Friends can also see each other, but nothing else.

This means a friend's device on the tailnet can reach the game servers and Jellyfin, but can't touch SSH, the Samba share, or any other service running on the boxes.

## Policy file

```json
{
	"tagOwners": {
		"tag:server":          ["autogroup:admin"],
		"tag:friends":         ["autogroup:admin"],
		"tag:personal-device": ["autogroup:admin"],
	},
	"acls": [
		// Admin can access everything
		{
			"action": "accept",
			"src":    ["autogroup:admin"],
			"dst":    ["*:*"],
		},
		// Personal devices can access everything too
		{
			"action": "accept",
			"src":    ["tag:personal-device"],
			"dst":    ["*:*"],
		},
		// Friends can see Port 25565 for MC
		{
			"action": "accept",
			"src":    ["tag:friends"],
			"dst":    ["tag:server:25565"],
		},
		// Friends can see Port 7777 for Terraria
		{
			"action": "accept",
			"src":    ["tag:friends"],
			"dst":    ["tag:server:7777"],
		},
		// Friends can see Port 8096 for Jellyfin
		{
			"action": "accept",
			"src":    ["tag:friends"],
			"dst":    ["tag:server:8096"],
		},
		// Friends can see each other
		{
			"action": "accept",
			"src":    ["tag:friends"],
			"dst":    ["tag:friends:*"],
		},
	],
	"ssh": [
		// Allow all users to SSH into their own devices in check mode.
		{
			"action": "check",
			"src":    ["autogroup:member"],
			"dst":    ["autogroup:self"],
			"users":  ["autogroup:nonroot", "root"],
		},
	],
}
```

> Trimmed commented-out default sections (groups, grants, postures, tests) that aren't in use. Full default template is in [Tailscale's docs](https://tailscale.com/kb/1018/acls).
