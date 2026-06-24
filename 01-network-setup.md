# Network Setup

## Context

Original setup: Server A and Server B connected via a network switch, which was also connected to a Powerline Adapter. The Powerline Adapter ran through the house wiring to a second Powerline Adapter plugged into a Netgear Nighthawk Mesh Node.

Actual throughput over the powerline link was poor — about 6 Mbps for transfers to a Samba share, and 8–16 Mbps even for Steam downloads on the client/workstation machine, despite the WiFi connection itself supporting 180–250 Mbps (From Motherboard Wi-Fi, MSI B450i. Decided to skip the powerline link entirely: since Server B is a laptop with a WiFi card, it could connect to WiFi directly and share that connection with the rest of the devices on the switch over Ethernet.

## Part 1: Ubuntu Server Install — Server B (Laptop)

Installed Ubuntu Server Minimized. No GUI, so network config is handled through netplan (a YAML file defining network interfaces).

`ip addr` lists all interfaces. Relevant ones on Server B:

- `wlp59s0` — built-in WiFi card, assigned `10.0.0.36` by the router via DHCP
- `enx5c628b74a9c1` — USB-to-Ethernet adapter, manually assigned `192.168.50.1`

Goal: share the laptop's WiFi connection with all devices on the switch (none of which have WiFi cards). The USB Ethernet adapter is the bridge between the laptop and the switch.

Ubuntu Minimized ships with no text editor and no internet yet. Before getting online, the only way to write files is `tee` — it reads from stdin and writes to a file, so content gets piped into it instead of using an interactive editor.

```yaml
# /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    enx5c628b74a9c1:       # USB ethernet adapter — static IP, acts as gateway for the switch
      addresses:
        - 192.168.50.1/24  # /24 means subnet 255.255.255.0, covers 192.168.50.1-254
  wifis:
    wlp59s0:
      dhcp4: true           # Let the router assign an IP automatically
      access-points:
        "YOUR_WIFI_NAME":
          password: "YOUR_WIFI_PASSWORD"
```

Apply the config:

```bash
sudo netplan apply
```

## Part 2: NAT/Gateway Setup — Server B (Laptop)

Once online, ran `sudo apt update` and installed nano (`sudo apt install nano`).

NAT lets the laptop share its WiFi connection with everything on the switch. Used `ufw` to manage both the firewall and NAT rules, rather than `iptables-persistent` (which conflicts with ufw).

**Step 1 — Enable IPv4 forwarding in ufw's sysctl config:**

```bash
sudo nano /etc/ufw/sysctl.conf
# Find and uncomment this line:
net/ipv4/ip_forward=1
```

**Step 2 — Add the NAT MASQUERADE rule to ufw's before.rules:**

```bash
sudo nano /etc/ufw/before.rules
# At the very top of the file, before the *filter line, add:

*nat
:POSTROUTING ACCEPT [0:0]
# MASQUERADE rewrites outgoing packets from the switch so they appear to come from the laptop's
# WiFi IP. This is what allows devices on 192.168.50.x to reach the internet through the laptop.
-A POSTROUTING -o wlp59s0 -j MASQUERADE
COMMIT
```

**Step 3 — Add ufw rules and enable:**

```bash
sudo apt install ufw

# Allow SSH so we don't lock ourselves out
sudo ufw allow ssh

# Allow all traffic coming in from the switch side
sudo ufw allow in on enx5c628b74a9c1

# Allow traffic to be forwarded from the switch through to WiFi
sudo ufw route allow in on enx5c628b74a9c1 out on wlp59s0

sudo ufw enable
```

**Disable WiFi power saving** — the WiFi interface was going dormant and dropping connections:

```bash
sudo apt install iw
# iw is a wireless configuration tool. power_save off keeps the WiFi card awake at all times.
sudo iw dev wlp59s0 set power_save off
# Note: this does not survive a reboot
```

**Disable suspend on lid close** — closing the lid was suspending the laptop and dropping all connections:

```bash
sudo nano /etc/systemd/logind.conf
# Only these lines need to be changed/uncommented — everything else stays default

[Login]
HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

```bash
sudo systemctl restart systemd-logind
```

## Part 3: Installing Tailscale — Server B + Server A

AP isolation on the Nighthawk meant WiFi clients on the same network couldn't talk to each other directly — couldn't SSH into the laptop from the Gaming PC using the LAN IP (`10.0.0.36`). Tailscale tunnels traffic through its own network, bypassing this.

```bash
# Download and run the Tailscale install script
curl -fsSL https://tailscale.com/install.sh | sh

# Bring Tailscale up — prints a URL to authenticate the device
sudo tailscale up
# Open the URL in any browser and sign in.
# Each device running Tailscale gets a Tailscale IP (100.x.x.x)
# and can reach each other regardless of what network they're on.
```

The AP isolation issue was later resolved by moving the Gaming PC to Ethernet via the switch. Tailscale stays installed for remote access outside the home network.

## Part 4: Making IPv4 Forwarding Permanent — Server B

```bash
# sysctl.conf sets kernel parameters on boot. ip_forward=1 tells the kernel to allow packets
# to be forwarded between interfaces. The -a flag appends without overwriting.
# Before running, verify it's not already there: grep "ip_forward" /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
```

## Part 5: Ubuntu Server Install — Server A (Mini-PC)

Only relevant interface was `enp2s0` (Ethernet, already plugged into the switch). Assigned `192.168.50.2`, gateway pointed to the laptop at `192.168.50.1`.

```yaml
# /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    enp2s0:
      match:
        macaddress: b8:85:84:9a:d8:57  # Pins this config to the specific network card by MAC address
      set-name: enp2s0                  # Ensures the interface is always called enp2s0
      addresses:
        - 192.168.50.2/24
      routes:
        - to: default
          via: 192.168.50.1  # All traffic goes through the laptop
      nameservers:
        addresses:
          - 1.1.1.1  # Cloudflare DNS
```

Apply and verify:

```bash
sudo netplan apply

ping 192.168.50.1  # Laptop (gateway)
ping 8.8.8.8       # Internet (no DNS, raw IP)
ping google.com    # Internet + DNS resolution
```

## Part 6: Gaming PC Joins the Switch

Originally the Gaming PC was on WiFi (`10.0.0.16`). Due to AP isolation, it couldn't reach the laptop directly. Moved it to Ethernet via the switch and assigned a static IP manually in Windows.

```
Win + R > ncpa.cpl
Right click Ethernet > Properties > Internet Protocol Version 4 (TCP/IPv4) > Properties

IP Address:           192.168.50.3
Subnet Mask:          255.255.255.0
Default Gateway:      192.168.50.1
Preferred DNS Server: 1.1.1.1
Alternate DNS Server: 8.8.8.8
```
