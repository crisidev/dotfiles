#!/bin/bash
# shellcheck disable=1091

if [ "$SENDER" = "front_app_switched" ]; then
    if [ "$INFO" = "neovide" ]; then
        INFO=$(osascript -e "id of app \"$INFO\"")
    fi
    sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO" \
        --animate tanh 10 --set $NAME icon.background.image.scale=1.2 \
        icon.background.image.scale=1
fi
