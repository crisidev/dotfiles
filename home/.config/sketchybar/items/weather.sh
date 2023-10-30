#!/bin/bash

weather=(
    # label.width=65
    label.align=center
    # padding_left=-2
    padding_right=-3
    update_freq=1800
    script="$PLUGIN_DIR/weather.sh"
)

sketchybar --add item weather right \
    --set weather "${weather[@]}" \
