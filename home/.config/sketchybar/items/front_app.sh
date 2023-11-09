#!/bin/bash
# shellcheck disable=2016

front_app=(
    label.font="$FONT:Black:12.0"
    icon.background.drawing=on
    associated_display=active
    script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app left \
    --set front_app "${front_app[@]}" \
    --subscribe front_app front_app_switched
