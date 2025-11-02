#!/usr/bin/env bash
set -euo pipefail
LV="${1:?Usage: $0 /dev/vg/lv +2G}"
SIZE="${2:?Example: +2G}"
lvextend -L "${SIZE}" "${LV}"
# try xfs grow, then ext
xfs_growfs "${LV}" 2>/dev/null || resize2fs "${LV}"
