#!/usr/bin/env bash
set -euo pipefail
HOST="${1:-localhost}"
PORT="${2:-22}"
timeout 5 bash -lc "echo >/dev/tcp/${HOST}/${PORT}" && echo "TCP ${HOST}:${PORT} reachable" || (echo "Cannot reach ${HOST}:${PORT}"; exit 1)
