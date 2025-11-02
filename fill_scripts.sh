#!/usr/bin/env bash
set -euo pipefail
mkdir -p scripts/{ops,net,storage,security}

# ops
cat > scripts/ops/cron_sample.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
( crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/date >> /tmp/cron_sample.log" ) | crontab -
echo "Cron installed. Check /tmp/cron_sample.log after 5+ minutes."
S
chmod +x scripts/ops/cron_sample.sh

cat > scripts/ops/journal_tail.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
UNIT="${1:-ssh|sshd}"
journalctl -u "$UNIT" -n 50 -f
S
chmod +x scripts/ops/journal_tail.sh

# net
cat > scripts/net/ping_test.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
HOST="${1:-8.8.8.8}"
ping -c 4 "$HOST"
S
chmod +x scripts/net/ping_test.sh

cat > scripts/net/ssh_test.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
HOST="${1:-localhost}"
PORT="${2:-22}"
timeout 5 bash -lc "echo >/dev/tcp/${HOST}/${PORT}" && echo "TCP ${HOST}:${PORT} reachable" || (echo "Cannot reach ${HOST}:${PORT}"; exit 1)
S
chmod +x scripts/net/ssh_test.sh

# storage
cat > scripts/storage/lvm_extend.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
LV="${1:?Usage: $0 /dev/vg/lv +2G}"
SIZE="${2:?Example: +2G}"
lvextend -L "${SIZE}" "${LV}"
# try xfs grow, then ext
xfs_growfs "${LV}" 2>/dev/null || resize2fs "${LV}"
S
chmod +x scripts/storage/lvm_extend.sh

cat > scripts/storage/fs_repair_demo.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
DEV="${1:-/dev/vdb1}"
umount "${DEV}" || true
( xfs_repair -n "${DEV}" || fsck -fy "${DEV}" ) || true
echo "Repair check attempted (xfs or ext)."
S
chmod +x scripts/storage/fs_repair_demo.sh

# security
cat > scripts/security/selinux_status.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
command -v getenforce >/dev/null && getenforce || echo "SELinux not present"
S
chmod +x scripts/security/selinux_status.sh

cat > scripts/security/suid_scan.sh <<'S'
#!/usr/bin/env bash
set -euo pipefail
find / -perm -4000 -type f -printf "%m %u %g %p\n" 2>/dev/null | sort
S
chmod +x scripts/security/suid_scan.sh

echo "[OK] scripts samples created."
