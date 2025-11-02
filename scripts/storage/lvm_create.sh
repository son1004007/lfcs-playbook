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
