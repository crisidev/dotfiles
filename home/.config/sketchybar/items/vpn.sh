#!/bin/bash
# shellcheck disable=2016

vpn=(
    script="$PLUGIN_DIR/vpn.sh"
    icon.font="$FONT:Bold:18.0"
    padding_right=6
    padding_left=6
    label.width=0
    label.drawing=off
    update_freq=30
    updates=on
)

sketchybar --add item vpn right \
    --set vpn "${vpn[@]}" \
    --subscribe vpn \
    system_woke \
    wifi_change
