#!/usr/bin/env bash
set -euo pipefail
find / -perm -4000 -type f -printf "%m %u %g %p\n" 2>/dev/null | sort
