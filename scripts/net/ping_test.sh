#!/usr/bin/env bash
set -euo pipefail
HOST="${1:-8.8.8.8}"
ping -c 4 "$HOST"
