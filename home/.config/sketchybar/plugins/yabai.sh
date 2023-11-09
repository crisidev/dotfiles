#!/bin/bash
# shellcheck disable=1091

window_state() {
    source "$CONFIG_DIR/colors.sh"
    source "$CONFIG_DIR/icons.sh"

    WINDOW=$("/opt/homebrew/bin/yabai" -m query --windows --window)
    STACK_INDEX=$(echo "$WINDOW" | jq '.["stack-index"]')

    COLOR=$BAR_BORDER_COLOR
    ICON=""

    if [ "$(echo "$WINDOW" | jq '.["is-floating"]')" = "true" ]; then
        ICON+=$YABAI_FLOAT
        COLOR=$MAGENTA
    elif [ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" = "true" ]; then
        ICON+=$YABAI_FULLSCREEN_ZOOM
        COLOR=$GREEN
    elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
        ICON+=$YABAI_PARENT_ZOOM
        COLOR=$BLUE
    elif [[ $STACK_INDEX -gt 0 ]]; then
        LAST_STACK_INDEX=$("/opt/homebrew/bin/yabai" -m query --windows --window stack.last | jq '.["stack-index"]')
        ICON+=$YABAI_STACK
        LABEL="$(printf "[%s/%s]" "$STACK_INDEX" "$LAST_STACK_INDEX")"
        COLOR=$RED
    fi

    args=(--bar border_color=$COLOR --animate sin 10 --set $NAME icon.color=$COLOR)

    [ -z "$LABEL" ] && args+=(label.width=0) ||
        args+=(label="$LABEL" label.width=40)

    [ -z "$ICON" ] && args+=(icon.width=0) ||
        args+=(icon="$ICON" icon.width=30)

    sketchybar -m "${args[@]}"
}

windows_on_spaces() {
    /usr/bin/python3 "$CONFIG_DIR/plugins/space.py"
}

mouse_clicked() {
    "/opt/homebrew/bin/yabai" -m window --toggle float
    window_state
}

case "$SENDER" in
    "mouse.clicked")
        mouse_clicked
        ;;
    "forced")
        exit 0
        ;;
    "window_focus")
        window_state
        ;;
    "windows_on_spaces" | "space_change")
        windows_on_spaces
        ;;
esac
