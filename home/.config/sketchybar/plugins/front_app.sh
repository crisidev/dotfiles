#!/bin/bash
# shellcheck disable=1091

if [ "$SENDER" = "front_app_switched" ]; then
    BUNDLE_ID="$(osascript -e "id of app \"$INFO\"")"
    # sketchybar --set $NAME label="$INFO" \
    #     icon.background.image="app.$BUNDLE_ID"
    sketchybar --set $NAME icon.background.image="app.$BUNDLE_ID"
fi
