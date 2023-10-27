#!/bin/bash
# shellcheck disable=1091

source "$CONFIG_DIR/icons.sh"

mic=(
    icon="$MIC_ON"
	script="$PLUGIN_DIR/mic.sh"
    label.width=0
    padding_right=-5
    icon.padding_left=8
)

status_bracket=(
	background.color="$BACKGROUND_1"
	background.border_color="$BACKGROUND_2"
)

sketchybar --add event mic_update \
    --add item mic right \
	--set mic "${mic[@]}" \
	--subscribe mic mic_update mouse.clicked

sketchybar --add bracket status brew github.bell wifi volume_icon mic \
	--set status "${status_bracket[@]}"
