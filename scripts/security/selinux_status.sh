#!/usr/bin/env bash
set -euo pipefail
command -v getenforce >/dev/null && getenforce || echo "SELinux not present"
