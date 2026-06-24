# Server Provisioning

Covers Samba/file sharing setup and Docker engine install on both servers. Assumes network setup (see [01-network-setup.md](01-network-setup.md)) is already done.

## Part 1: Samba Setup — Server A & B

Samba is core to the workflow here, not just extra storage — all container configs and AppData also live in the Samba share, so any file (e.g. a Minecraft world's mod folder running through CraftyController) is reachable from any device through File Explorer.

Ran the same steps on both servers:

```bash
# Update package lists + install Samba
sudo apt update
sudo apt install samba

# Create the share directory. Done in the root of the system here, though some prefer the home directory
mkdir Abrar_SMB

# Edit the Samba config
sudo nano /etc/samba/smb.conf

# Added at the very bottom:
[Abrar_SMB]
comment = Samba on Ubuntu Server
path = /Abrar_SMB
read only = no
browsable = yes

# Restart to apply config and allow Samba through UFW
sudo service smbd restart
sudo ufw allow samba

# Set up the Samba user/password (prompts for password after running)
sudo smbpasswd -a abrar

# Since the share directory is in root, give it ownership perms for Windows clients
sudo chown abrar:abrar /Abrar_SMB
```

## Part 2: Mounting a Secondary Drive — Server A

A secondary SSD (used earlier to back up important data — see [CHANGELOG.md](CHANGELOG.md)) gets mounted into the Samba share.

```bash
cd /Abrar_SMB
mkdir "SSD Mount"

# Find the drive ID. Need sda1 and its UUID here
lsblk -f

# Mount it to the new directory
sudo mount /dev/sda1 /Abrar_SMB/SSD_Mount

# Make it permanent in fstab
sudo nano /etc/fstab
UUID=1aa51f8e-484f-4d45-97ac-7a716a2c3c1d /Abrar_SMB/SSD_Mount ext4 defaults 0 2

# Set read/write perms on the share
sudo chown -R abrar:abrar /Abrar_SMB
sudo chmod -R 775 /Abrar_SMB
sudo find /Abrar_SMB -type d -exec chmod 2775 {} \;
sudo find /Abrar_SMB -type f -exec chmod 664 {} \;
sudo systemctl restart smbd
```

## Part 3: Docker Install — Server A & B

Docker is the base for all self-hosted services on both machines.

```bash
# Install dependencies
sudo apt install ca-certificates curl

# Add Docker's official GPG key and repository
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \ $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \ sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

# Install Docker Engine and Docker Compose
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker abrar

exit

# SSH back in
docker --version
docker compose version

# Set up the directories that will hold container configs and volumes
cd /Abrar_SMB
mkdir "Container Configs"  # docker-compose.yml files live here
mkdir "AppData"            # container volumes live here
```

From here, each service's setup lives in its own file under [03-services/](03-services/).
