#!/usr/bin/env bash
set -euo pipefail
mkdir -p labs/{vm,containers,answers}

cat > labs/README.md <<'DOC'
# Labs

- vm/: cloud-init or libvirt XML examples for quick practice.
- containers/: podman/docker tasks used in LFCS context.
- answers/: keep your lab outputs (commands and results) as Markdown logs.

Tips:
- Log every step you run; copy `cmd + output` pairs.
- Prefer reproducible scripts over manual steps.
DOC

echo "[OK] labs skeleton notes created."
