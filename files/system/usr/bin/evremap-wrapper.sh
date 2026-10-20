#!/usr/bin/env bash
INSTANCE="$1"
SRC_CONFIG="/etc/evremap-${INSTANCE}.toml"
RUN_CONFIG="/run/evremap-${INSTANCE}.toml"

cp "$SRC_CONFIG" "$RUN_CONFIG"

if [ "$INSTANCE" = "firetv" ]; then
    while true; do
        DEV=$(/usr/bin/evremap list-devices 2>/dev/null | grep -oE "Amazon Remote Keyboard|AR Keyboard" | head -n 1)
        if [ -n "$DEV" ]; then
            sed "s/^[[:space:]]*device_name[[:space:]]*=.*/device_name = \"$DEV\"/" "$SRC_CONFIG" > "$RUN_CONFIG"
            break
        fi
        sleep 2
    done
fi

exec bash -c "/usr/bin/evremap remap \"$RUN_CONFIG\" -d 0"
