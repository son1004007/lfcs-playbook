#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/00-overall

cat > docs/00-overall/study-plan.md <<'DOC'
# LFCS Study Plan

## Week 1 - System Operations
- Kernel parameters (sysctl)
- Processes/services (systemd), logs (journalctl)
- Jobs (cron, systemd timers)
- Package management (apt, dnf)

## Week 2 - Networking
- IPv4/IPv6 addressing, routing
- Hostname and DNS
- OpenSSH server/client
- Packet filtering (ufw, firewalld, iptables/nft)
- Troubleshooting (ping, traceroute, ss/tcpdump)

## Week 3 - Storage
- Partitions and filesystems
- LVM (PV/VG/LV)
- Mounts and fstab
- Remote FS (NFS, CIFS)
- Recovery (fsck, xfs_repair)

## Week 4 - Users, Processes, Security
- Users/groups, sudoers
- Process control and monitoring
- SELinux/AppArmor basics
- Backups, tar/rsync
DOC

cat > docs/00-overall/exam-day-checklist.md <<'DOC'
# Exam Day Checklist

- Time sync: `timedatectl`, NTP status
- Man pages available; know `--help` usage
- Network basics verified: `ip a`, `ping`, `ss -lntp`
- SSH service reachable (if required)
- SELinux/AppArmor mode known
- LVM/FS commands fresh in memory
- Log commands: `journalctl -xe`, `journalctl -u <svc>`
- Keep calm; read the task twice before typing.
DOC

cat > docs/00-overall/command-index.md <<'DOC'
# Command Index (Quick)

## System
sysctl, systemctl, journalctl, timedatectl, shutdown, reboot, hostnamectl

## Packages
apt, dnf, rpm, dpkg, add-apt-repository, dnf config-manager

## Networking
ip, nmcli, netplan, resolvectl, ping, traceroute, ss, tcpdump, ssh, scp

## Storage
lsblk, blkid, fdisk/parted, mkfs.*, mount/umount, /etc/fstab, pvcreate,
vgcreate, lvcreate, lvextend, xfs_growfs, resize2fs, fsck, xfs_repair

## Users/Processes
useradd, passwd, usermod, groupadd, su, sudo, ps, top/htop, nice, renice, kill

## Security
chmod, chown, umask, getenforce, setenforce, semanage, ausearch, audit2why
DOC

echo "[OK] docs/00-overall files created."
