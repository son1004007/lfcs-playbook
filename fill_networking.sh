#!/usr/bin/env bash
set -euo pipefail
mkdir -p docs/02-networking

cat > docs/02-networking/cheatsheet.md <<'DOC'
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
DOC

cat > docs/02-networking/labs.md <<'DOC'
# Networking Labs

## Lab 1: Bring up a secondary IP
1) `ip addr add 192.0.2.20/24 dev eth0`
2) Verify: `ip a show dev eth0`
3) Remove: `ip addr del 192.0.2.20/24 dev eth0`

## Lab 2: Restrict SSH with firewall
- UFW: `ufw allow proto tcp from 10.0.0.0/24 to any port 22`
- firewalld: `firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.0.0.0/24 port port=22 protocol=tcp accept' && firewall-cmd --reload`
DOC

echo "[OK] docs/02-networking files created."
