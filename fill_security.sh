#!/usr/bin/env bash
set -euo pipefail
mkdir -p docs/05-security

cat > docs/05-security/cheatsheet.md <<'DOC'
# Security Cheatsheet

## Permissions
- `chmod 640 file`, `chown user:group file`, `umask 027`
- Find SUID/SGID: `find / -perm -4000 -o -perm -2000 -type f 2>/dev/null`

## SELinux (RHEL)
- Mode: `getenforce`, `setenforce 0|1`
- Persistent: `/etc/selinux/config`
- Labels: `ls -Z`, `restorecon -Rv /path`
- Booleans: `getsebool -a`, `setsebool -P httpd_can_network_connect on`

## Logs & auditing
- `journalctl -xe`
- `ausearch -m AVC -ts recent` (if auditd)
DOC

echo "[OK] docs/05-security files created."
