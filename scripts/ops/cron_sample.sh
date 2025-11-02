#!/usr/bin/env bash
set -euo pipefail
( crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/date >> /tmp/cron_sample.log" ) | crontab -
echo "Cron installed. Check /tmp/cron_sample.log after 5+ minutes."
