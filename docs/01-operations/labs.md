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
