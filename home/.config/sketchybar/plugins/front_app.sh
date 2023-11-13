#!/bin/bash
# shellcheck disable=1091

if [ "$SENDER" = "front_app_switched" ]; then
    BUNDLE_ID=$(osascript -e "id of app \"$INFO\"")
    if [ "$?" != 0 ]; then
        if echo "$INFO" | grep -iq "WhatsApp"; then
            BUNDLE_ID="net.whatsapp.WhatsApp"
        fi
    fi
    # sketchybar --set $NAME label="$INFO" \
    #     icon.background.image="app.$BUNDLE_ID"
    sketchybar --set $NAME icon.background.image="app.$BUNDLE_ID"
fi
