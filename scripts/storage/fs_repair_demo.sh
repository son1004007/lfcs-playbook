#!/usr/bin/env bash
set -euo pipefail
DEV="${1:-/dev/vdb1}"
umount "${DEV}" || true
( xfs_repair -n "${DEV}" || fsck -fy "${DEV}" ) || true
echo "Repair check attempted (xfs or ext)."
