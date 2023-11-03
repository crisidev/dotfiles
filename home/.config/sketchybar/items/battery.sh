#!/bin/bash
# shellcheck disable=2016

battery=(
    script="$PLUGIN_DIR/battery.sh"
    icon.font="$FONT:Regular:19.0"
    padding_right=5
    padding_left=0
    label.drawing=off
    update_freq=120
    updates=on
    popup.height=35
)

battery_info=(
    # icon=$LOCK
    label="Info"
    click_script=""
)

sketchybar --add item battery right \
    --set battery "${battery[@]}" \
    --subscribe battery \
    power_source_change \
    system_woke \
    mouse.clicked \
    --add item battery.info popup.battery \
    --set battery.info "${battery_info[@]}"
