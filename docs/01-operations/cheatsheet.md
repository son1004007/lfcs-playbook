# Operations Cheatsheet

## Kernel parameters
- Temporary: `sysctl net.ipv4.ip_forward=1`
- Persistent: add `net.ipv4.ip_forward=1` to `/etc/sysctl.d/custom.conf` then `sysctl --system`
- Verify: `sysctl net.ipv4.ip_forward`

## Process and services
- Inspect: `ps aux`, `top`
- Kill: `kill -9 <pid>`
- systemd: `systemctl status|start|stop <svc>`, logs: `journalctl -u <svc> --since "1h ago"`
