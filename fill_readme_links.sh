#!/usr/bin/env bash
set -euo pipefail
awk '1; /##/ && !x++ { print "\n## Study Links\n- [00-overall](docs/00-overall/study-plan.md)\n- [01-operations](docs/01-operations/cheatsheet.md)\n- [02-networking](docs/02-networking/cheatsheet.md)\n- [03-storage](docs/03-storage/cheatsheet.md)\n- [04-users-process](docs/04-users-process/cheatsheet.md)\n- [05-security](docs/05-security/cheatsheet.md)\n" }' README.md > README.md.tmp && mv README.md.tmp README.md || true
echo "[OK] README links section inserted (idempotent best-effort)."
