#!/usr/bin/env bash
set -euo pipefail
mkdir -p docs/01-operations

cat > docs/01-operations/cheatsheet.md <<'DOC'
# Operations Cheatsheet

## Kernel parameters
- Temp: `sysctl net.ipv4.ip_forward=1`
- Persist: add to `/etc/sysctl.d/99-custom.conf` then `sysctl --system`
- Verify: `sysctl net.ipv4.ip_forward`

## Services (systemd)
- Start/Stop/Enable: `systemctl start|stop|enable <svc>`
- Status/Logs: `systemctl status <svc>`, `journalctl -u <svc> --since "1h ago"`
- Create simple service:
"""
/etc/systemd/system/hello.service:
[Unit]
Description=Hello service
[Service]
Type=simple
ExecStart=/usr/bin/echo Hello
[Install]
WantedBy=multi-user.target
"""
- `systemctl daemon-reload && systemctl enable --now hello`

## Jobs
- User cron: `crontab -e`
- Systemd timer: pair `<name>.service` with `<name>.timer`, `systemctl list-timers`

## Packages
- Debian/Ubuntu: `apt update && apt install -y <pkg>`
- RHEL: `dnf install -y <pkg>`
DOC

cat > docs/01-operations/labs.md <<'DOC'
# Operations Labs

## Lab 1: Create and manage a service
1) Create `/etc/systemd/system/demo.service`:
"""
[Unit]
Description=Demo
[Service]
ExecStart=/usr/bin/sleep infinity
[Install]
WantedBy=multi-user.target
"""
2) `systemctl daemon-reload && systemctl enable --now demo`
3) Verify: `systemctl status demo`, `journalctl -u demo -n 5`

## Lab 2: Schedule a job with cron
1) `echo "*/5 * * * * /usr/bin/date >> /tmp/cron_demo.log" | crontab -`
2) Verify after 5+ minutes: `tail -f /tmp/cron_demo.log`
DOC

echo "[OK] docs/01-operations files created."

