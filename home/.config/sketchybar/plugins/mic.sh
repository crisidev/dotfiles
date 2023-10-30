#!/bin/bash
# shellcheck disable=1091,2086

toggle_mic() {
    "$HOME/.bin/hs" -c "return spoon.MicMute:toggleMicMute()"
}

update() {
    source "$CONFIG_DIR/colors.sh"

    MUTED=$("$HOME/.bin/hs" -c "return hs.audiodevice.defaultInputDevice():muted()")
    if [ "$MUTED" = "true" ]; then
        COLOR=$RED
    else
        COLOR=$WHITE
    fi

    sketchybar --set "$NAME" icon.color="$COLOR"
}

case "$SENDER" in
    "mic_update")
        update
        ;;
    "mouse.clicked")
        toggle_mic
        update
        ;;
esac
