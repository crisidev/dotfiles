#!/bin/bash
# shellcheck disable=1091

source "$CONFIG_DIR/icons.sh"

wifi=(
    update_freq=180
    padding_right=6
    label.width=0
    icon.font="$FONT:Bold:15.0"
    icon="$WIFI_DISCONNECTED"
    label="$LOADING"
    popup.align=right
    script="$PLUGIN_DIR/wifi.sh"
)

wifi_info=(
    drawing=off
    background.corner_radius=12
    padding_left=7
    padding_right=7
    icon.background.height=2
    icon.background.y_offset=-12
    align=left
)

sketchybar --add item wifi right \
    --set wifi "${wifi[@]}" \
    --subscribe wifi \
    wifi_change \
    mouse.clicked \
    mouse.entered \
    mouse.exited \
    mouse.exited.global \
    --add item wifi.info popup.wifi \
    --set wifi.info "${wifi_info[@]}"
