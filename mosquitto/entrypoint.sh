#!/bin/ash
set -e

# Set permissions
user="$(id -u)"
if [ "$user" = '0' ]; then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

echo
echo '## SET UP CRON-JOBS ##'
echo
echo '0       3       *       *       6       kill -HUP "$(pgrep mosquitto)"' >> /etc/crontabs/root
crond -f -l 8 &

echo
echo '## DONE ##'
echo

exec "$@"
