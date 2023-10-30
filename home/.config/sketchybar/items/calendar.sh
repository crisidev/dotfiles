#!/bin/bash

calendar=(
    icon=cal
    icon.font="$FONT:Black:12.0"
    icon.padding_right=0
    label.width=65
    label.align=right
    padding_left=8
    update_freq=5
    script="$PLUGIN_DIR/calendar.sh"
    click_script="$PLUGIN_DIR/zen.sh"
)

sketchybar --add item calendar right \
    --set calendar "${calendar[@]}" \
    --subscribe calendar system_woke
