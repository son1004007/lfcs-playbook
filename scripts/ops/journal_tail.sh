#!/usr/bin/env bash
set -euo pipefail
UNIT="${1:-ssh|sshd}"
journalctl -u "$UNIT" -n 50 -f
