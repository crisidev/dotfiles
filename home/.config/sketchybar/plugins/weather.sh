#!/bin/bash

WEATHER=$(curl -s "https://wttr.in/?format=1")
if [ "$?" -eq 0 ]; then
    TEMP=$(echo "$WEATHER" | gsed 's|  *| |g')
    sketchybar -m --set "$NAME" drawing=on --set "$NAME" label="${TEMP}" \
        --set "$NAME" click_script="/usr/bin/open /System/Applications/Weather.app"
else
    sketchybar --set "$NAME" drawing=off
fi
