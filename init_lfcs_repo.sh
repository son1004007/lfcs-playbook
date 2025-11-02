cat > init_lfcs_ascii.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "[LFCS] Creating repository structure..."
mkdir -p .github/workflows docs/{00-overall,01-operations,02-networking,03-storage,04-users-process,05-security} \
         scripts/{ops,net,storage,security} labs/{vm,containers,answers} .devcontainer

# LICENSE (MIT)
cat > LICENSE <<'LCS'
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LCS

# Makefile (tabs required)
{ 
  printf '.PHONY: test lint md\n\n'
  printf 'test: lint\n\n'
  printf 'lint:\n\tfind scripts -type f -name "*.sh" -print0 | xargs -0 -I{} shellcheck {}\n\n'
  printf 'md:\n\tnpx markdownlint-cli2 "**/*.md"\n'
} > Makefile

# GitHub Actions CI
cat > .github/workflows/ci.yml <<'GHY'
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: ShellCheck
        run: |
          sudo apt-get update && sudo apt-get install -y shellcheck
          find scripts -type f -name "*.sh" -print0 | xargs -0 -I{} shellcheck {}
GHY

# Sample scripts
cat > scripts/ops/service_health.sh <<'OPS'
#!/usr/bin/env bash
set -euo pipefail
SVC="${1:-sshd}"
systemctl is-active "$SVC" >/dev/null && echo "$SVC: active" || (echo "$SVC: inactive"; exit 1)
OPS
chmod +x scripts/ops/service_health.sh

cat > scripts/storage/lvm_create.sh <<'STO'
#!/usr/bin/env bash
set -euo pipefail
# Usage: sudo ./lvm_create.sh /dev/vdb vgdata lvweb 5G
DEV="${1:-/dev/vdb}"
VG="${2:-vgdata}"
LV="${3:-lvweb}"
SIZE="${4:-5G}"
pvcreate "$DEV"
vgcreate "$VG" "$DEV"
lvcreate -n "$LV" -L "$SIZE" "$VG"
mkfs.xfs "/dev/${VG}/${LV}"
echo "[OK] /dev/${VG}/${LV} created (xfs)."
STO
chmod +x scripts/storage/lvm_create.sh

# Cheatsheets (ASCII only)
cat > docs/01-operations/cheatsheet.md <<'OPC'
# Operations Cheatsheet

## Kernel parameters
- Temporary: `sysctl net.ipv4.ip_forward=1`
- Persistent: add `net.ipv4.ip_forward=1` to `/etc/sysctl.d/custom.conf` then `sysctl --system`
- Verify: `sysctl net.ipv4.ip_forward`

## Process and services
- Inspect: `ps aux`, `top`
- Kill: `kill -9 <pid>`
- systemd: `systemctl status|start|stop <svc>`, logs: `journalctl -u <svc> --since "1h ago"`
OPC

cat > docs/03-storage/cheatsheet.md <<'STC'
# Storage Cheatsheet

## LVM quick path
- PV: `pvcreate /dev/vdb`
- VG: `vgcreate vgdata /dev/vdb`
- LV: `lvcreate -n lvweb -L 5G vgdata`
- FS: `mkfs.xfs /dev/vgdata/lvweb`
- Mount: add UUID to `/etc/fstab` then `mount -a`
STC

echo "[LFCS] Done."
EOF

chmod +x init_lfcs_ascii.sh
./init_lfcs_ascii.sh

