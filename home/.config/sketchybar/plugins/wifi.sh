#!/bin/bash
# shellcheck disable=1091

update() {
    source "$CONFIG_DIR/icons.sh"
    source "$CONFIG_DIR/colors.sh"
    args=(--remove '/wifi.line\.*/')

    SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}')"
    IPADDR="$(ipconfig getifaddr en0)"
    LABEL="$SSID ($IPADDR)"
    ICON="$([ -n "$SSID" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
    sketchybar -m --set "$NAME" icon="$ICON" label="$LABEL"

    # Wifi info
    CHANNEL=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' channel: ' '/ channel: / { print $2 }')
    AUTH=$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' link auth: ' '/ link auth: / { print $2 }')
    LABEL="SSID: $SSID, channel: $CHANNEL, auth: $AUTH"
    wifi=(
        icon.padding_left=6
        label.padding_right=6
        icon.color="$BLUE"
        icon="$WIFI_CONNECTED"
        position=popup.wifi
        drawing=on
        label="$LABEL"
    )
    args+=(--clone "wifi.line.1" wifi.info
        --set "wifi.line.1" "${wifi[@]}")

    DEFAULT_ROUTE=$(route -n get default | awk -F ' gateway: ' '/ gateway: / { print $2 }')
    LABEL="IP address: $IPADDR, gateway: $DEFAULT_ROUTE"
    ipaddr=(
        icon.padding_left=6
        label.padding_right=6
        icon.color="$BLUE"
        icon=􀁞
        position=popup.wifi
        drawing=on
        label="$LABEL"
    )
    args+=(--clone "wifi.line.2" wifi.info
        --set "wifi.line.2" "${ipaddr[@]}")

    # tailscale
    ICON=$TAILSCALE_OFF
    LABEL="Tailscale disconnected"
    if /Applications/Tailscale.app/Contents/MacOS/Tailscale status >/dev/null 2>&1; then
        ICON=$TAILSCALE_ON
        LABEL="Tailscale connected, address: $(/Applications/Tailscale.app/Contents/MacOS/Tailscale ip --4)"
    fi
    tailscale=(
        icon.padding_left=6
        label.padding_right=6
        icon.color="$BLUE"
        icon="$ICON"
        position=popup.wifi
        drawing=on
        label="$LABEL"
    )
    args+=(--clone "wifi.line.3" wifi.info
        --set "wifi.line.3" "${tailscale[@]}")

    sketchybar -m "${args[@]}" >/dev/null
}

click() {
    CURRENT_WIDTH="$(sketchybar --query "$NAME" | jq -r .label.width)"

    WIDTH=0
    if [ "$CURRENT_WIDTH" -eq "0" ]; then
        WIDTH=dynamic
    fi

    sketchybar --animate sin 20 --set "$NAME" label.width="$WIDTH"
}

popup() {
    sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
    "wifi_change")
        update
        ;;
    "mouse.clicked")
        click
        ;;
    "mouse.entered")
        popup on
        ;;
    "mouse.exited" | "mouse.exited.global")
        popup off
        ;;
esac
