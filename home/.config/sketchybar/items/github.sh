#!/bin/bash

github_bell=(
    padding_right=6
    update_freq=180
    icon="$BELL"
    icon.font="$FONT:Bold:15.0"
    icon.color="$BLUE"
    label="$LOADING"
    label.highlight_color="$BLUE"
    popup.align=right
    script="$PLUGIN_DIR/github.sh"
)

github_template=(
    drawing=off
    background.corner_radius=12
    padding_left=7
    padding_right=7
    icon.background.height=2
    icon.background.y_offset=-12
)

sketchybar --add event github.update \
    --add item github.bell right \
    --set github.bell "${github_bell[@]}" \
    --subscribe github.bell mouse.clicked \
                            github.update \
                            system_woke   \
    --add item github.template popup.github.bell \
    --set github.template "${github_template[@]}"
