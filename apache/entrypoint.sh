#!/bin/bash
set -e

if [ -n "$USER_ID" ]; then
    UID_VAL="${USER_ID%%:*}"   # everything before the colon
    GID_VAL="${USER_ID##*:}"   # everything after the colon
    #echo "[entrypoint] Remapping www-data to UID=$UID_VAL GID=$GID_VAL"
    groupmod -g "$GID_VAL" www-data
    usermod  -u "$UID_VAL" www-data
fi

echo "[entrypoint] Enabling all sites from sites-available..."

# Clear out any stale symlinks in sites-enabled
rm -f /etc/apache2/sites-enabled/*.conf

# Symlink every .conf in the (possibly mounted) sites-available into sites-enabled
for conf in /etc/apache2/sites-available/*.conf; do
    [ -f "$conf" ] || continue
    name=$(basename "$conf")
    ln -sf "$conf" "/etc/apache2/sites-enabled/$name"
    echo "[entrypoint] Enabled site: $name"
done

# Symlink every .conf in the (possibly mounted) sites-available into sites-enabled
for conf in /etc/apache2/conf-available/*.conf; do
    [ -f "$conf" ] || continue
    name=$(basename "$conf")
    a2enconf $name
    echo "[entrypoint] Enabled conf: $name"
done

echo "[entrypoint] Starting Apache..."
exec apache2ctl -D FOREGROUND
