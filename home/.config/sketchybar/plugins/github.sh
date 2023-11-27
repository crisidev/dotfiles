#!/bin/bash
# shellcheck disable=1091

BELL_RED=0
TOTAL_NOTIFICATION=0
PREV_COUNT=$(sketchybar --query github.bell | jq -r .label.value)

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
if [ -e "$CONFIG_DIR/plugins/gitlab.sh" ]; then
    source "$CONFIG_DIR/plugins/gitlab.sh"
fi

update_gh() {
    NOTIFICATIONS="$(gh api notifications)"
    COUNT="$(echo "$NOTIFICATIONS" | jq 'length')"
    TOTAL_NOTIFICATION=$((TOTAL_NOTIFICATION + COUNT))
    args=()

    # For sound to play around with:
    # afplay /System/Library/Sounds/Morse.aiff

    args+=(--remove '/github.notification\.*/')

    COUNTER=0
    COLOR=$BLUE
    args+=(--set github.bell icon.color="$COLOR")

    while read -r repo url type title; do
        if [ "${repo}" = "" ] && [ "${title}" = "" ]; then
            continue
        fi
        COUNTER=$((COUNTER + 1))
        IMPORTANT="$(echo "$title" | grep -Ei "(deprecat|break|broke|bug)")"
        COLOR=$BLUE
        PADDING=0

        case "${type}" in
            "'Issue'")
                COLOR=$GREEN
                ICON=$GIT_ISSUE
                URL="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
            "'Discussion'")
                COLOR=$WHITE
                ICON=$GIT_DISCUSSION
                URL="https://www.github.com/notifications"
                ;;
            "'PullRequest'")
                COLOR=$MAGENTA
                ICON=$GIT_PULL_REQUEST
                URL="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
            "'Commit'")
                COLOR=$WHITE
                ICON=$GIT_COMMIT
                URL="$(gh api "$(echo "${url}" | sed -e "s/^'//" -e "s/'$//")" | jq .html_url)"
                ;;
        esac

        if [ "$IMPORTANT" != "" ]; then
            BELL_RED=1
            COLOR=$RED
        fi

        notification=(
            label="$(echo "$title" | sed -e "s/^'//" -e "s/'$//")"
            icon="󰊤  $ICON $(echo "$repo" | sed -e "s/^'//" -e "s/'$//"):"
            icon.padding_left="$PADDING"
            label.padding_right="$PADDING"
            icon.color="$COLOR"
            position=popup.github.bell
            icon.background.color="$COLOR"
            drawing=on
            click_script="open $URL; sketchybar --set github.bell popup.drawing=off; sleep 5; sketchybar --trigger github.update"
        )

        args+=(--clone "github.notification.$COUNTER" github.template
            --set "github.notification.$COUNTER" "${notification[@]}")
    done <<<"$(echo "$NOTIFICATIONS" | jq -r '.[] | [.repository.name, .subject.latest_comment_url, .subject.type, .subject.title] | @sh')"

    sketchybar -m "${args[@]}" >/dev/null

}

toggle_details() {
    POPUP=$(sketchybar --query $NAME | jq -r .popup.drawing)
    if [ "$POPUP" = "on" ]; then
        sketchybar --set "$NAME" popup.drawing=off
    else
        sketchybar --set "$NAME" popup.drawing=on
    fi
}

update() {
    if [ -e "$CONFIG_DIR/plugins/gitlab.sh" ]; then
        update_glab
    fi
    update_gh
    if [ "$TOTAL_NOTIFICATION" -eq 0 ]; then
        args=(--set "$NAME" icon="$BELL" label="0")
        notification=(
            label="No new notifications"
            icon="$ICON Note: "
            icon.padding_left="$PADDING"
            label.padding_right="$PADDING"
            icon.color="$COLOR"
            position=popup.github.bell
            icon.background.color="$COLOR"
            drawing=on
        )
        args+=(--clone "github.notification.1" github.template
            --set "github.notification.1" "${notification[@]}")
        sketchybar -m "${args[@]}" >/dev/null
    else
        sketchybar -m --set "$NAME" icon="$BELL_DOT" label="$TOTAL_NOTIFICATION"
    fi
    if [ "$TOTAL_NOTIFICATION" -gt "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
        sketchybar --animate tanh 15 --set github.bell label.y_offset=5 label.y_offset=0
    fi
    if [ "$BELL_RED" = 1 ]; then
        sketchybar -m --set github.bell icon.color="$RED"
    fi
}

case "$SENDER" in
    "routine" | "forced" | "github.update")
        update
        ;;
    "system_woke")
        sleep 10 && update # Wait for network to connect
        ;;
    "mouse.clicked")
        toggle_details
        ;;
esac
