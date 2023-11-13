#!/bin/bash
# shellcheck disable=1091

if [ "$SENDER" = "front_app_switched" ]; then
    if [ "$INFO" = "neovide" ]; then
        INFO=$(osascript -e "id of app \"$INFO\"")
    fi
    sketchybar --set $NAME icon.background.image="app.$INFO"
fi
