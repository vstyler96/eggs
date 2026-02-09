#!/bin/bash
set -e

# Prevent SteamCMD deadlock
sleep 1

# Default timezone to UTC
TZ=${TZ:-UTC}
export TZ

# Detect internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

cd /home/container || exit 1

# Replace {{ VAR }} placeholders with environment variable values
MODIFIED_STARTUP="$STARTUP"
for var_match in $(echo "$MODIFIED_STARTUP" | grep -oE '\{\{\s*[A-Z0-9_]+\s*\}\}'); do
  var_name=$(echo "$var_match" | sed 's/{{\s*//;s/\s*}}//')
  value=$(printenv "$var_name" || echo "")
  MODIFIED_STARTUP=${MODIFIED_STARTUP//"$var_match"/$value}
done

# Display the command being run
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$MODIFIED_STARTUP"

# Execute with exec for proper signal handling
exec $MODIFIED_STARTUP
