# Networking Cheatsheet

## IP and links
- Show: `ip a`, `ip r`, `ip -br link`
- Up/Down: `ip link set eth0 up|down`
- Add addr: `ip addr add 192.0.2.10/24 dev eth0`

## Hostname/DNS
- Hostname: `hostnamectl set-hostname host1`
- DNS (systemd-resolved): `resolvectl status`
- `/etc/hosts`, `/etc/resolv.conf` (bind mounts or symlink on some distros)

## SSH
- Server install: `apt install -y openssh-server` or `dnf install -y openssh-server`
- Enable: `systemctl enable --now ssh|sshd`
- Keys: `ssh-keygen -t ed25519`, `ssh-copy-id user@host`

## Packet filtering
- UFW (Ubuntu): `ufw allow 22/tcp && ufw enable`
- firewalld (RHEL): `firewall-cmd --permanent --add-service=ssh && firewall-cmd --reload`
- nft/iptables: know where to list rules `nft list ruleset`, `iptables -S`

## Troubleshooting
- `ping`, `traceroute`, `ss -lntp`, `tcpdump -i eth0`
