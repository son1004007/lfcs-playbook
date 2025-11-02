#!/usr/bin/env bash
set -euo pipefail
SVC="${1:-sshd}"
systemctl is-active "$SVC" >/dev/null && echo "$SVC: active" || (echo "$SVC: inactive"; exit 1)
