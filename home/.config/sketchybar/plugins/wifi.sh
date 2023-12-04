#!/bin/bash
# shellcheck disable=1091

update() {
    source "$CONFIG_DIR/icons.sh"
    source "$CONFIG_DIR/colors.sh"

    SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}')"
    IPADDR="$(ipconfig getifaddr en0)"
    LABEL="$SSID ($IPADDR)"
    ICON="$([ -n "$SSID" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
    sketchybar -m --set "$NAME" icon="$ICON" label="$LABEL"
}

case "$SENDER" in
    "wifi_change" | "system_woke")
        update
        ;;
esac
