#!/bin/bash
# shellcheck disable=1091

update() {
    source "$CONFIG_DIR/colors.sh"
    COLOR=$BACKGROUND_2
    if [ "$SELECTED" = "true" ]; then
        COLOR=$GREY
    fi
    sketchybar --set "$NAME" icon.highlight="$SELECTED" \
        label.highlight="$SELECTED" \
        background.border_color="$COLOR"
}

mouse_clicked() {
    if [ "$BUTTON" = "right" ]; then
        "$HOME/.bin/hs" -c "return hs.spaces.removeSpace($SID)"
        sketchybar --trigger windows_on_spaces
    else
        "$HOME/.bin/hs" -c "return hs.helpers.focus_space($SID)"
    fi
}

case "$SENDER" in
    "mouse.clicked")
        mouse_clicked
        ;;
    *)
        update
        ;;
esac
