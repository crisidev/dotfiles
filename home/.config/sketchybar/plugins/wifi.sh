#!/bin/bash
# shellcheck disable=1091

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

update() {

    SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}')"
    IPADDR="$(ipconfig getifaddr en0)"
    LABEL="$SSID ($IPADDR)"
    ICON="$([ -n "$SSID" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
    sketchybar -m --set "$NAME" icon="$ICON" label="$LABEL"
}

update_details() {
    args=(--remove '/wifi.line\.*/')

    # Wifi info
    SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}')"
    IPADDR="$(ipconfig getifaddr en0)"
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

toggle_details() {
    POPUP=$(sketchybar --query wifi | jq -r .popup.drawing)
    if [ "$POPUP" = "on" ]; then
        sketchybar --set "$NAME" popup.drawing=off
    else
        update_details
        sketchybar --set "$NAME" popup.drawing=on
    fi
}

click() {
    CURRENT_WIDTH="$(sketchybar --query "$NAME" | jq -r .label.width)"

    WIDTH=0
    if [ "$CURRENT_WIDTH" -eq "0" ]; then
        WIDTH=dynamic
    fi

    sketchybar --animate sin 20 --set "$NAME" label.width="$WIDTH"
}

case "$SENDER" in
    "wifi_change" | "system_woke")
        update
        ;;
    "mouse.clicked")
        if [ "$BUTTON" = "right" ] || [ "$MODIFIER" = "shift" ]; then
            toggle_details
        else
            update
            click
        fi
        ;;
    "mouse.exited.global")
        sketchybar --set "$NAME" popup.drawing=off
        ;;
esac
