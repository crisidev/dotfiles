#!/bin/bash
# shellcheck disable=1091

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | /usr/bin/grep -Eo "\d+%" | cut -d% -f1)
REMAINING_TIME=$(echo "$BATTERY_INFO" | /usr/bin/grep -Eo "\d+:\d+")
CHARGING=$(echo "$BATTERY_INFO" | /usr/bin/grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
    exit 0
fi

DRAWING=on
COLOR=$WHITE
case ${PERCENTAGE} in
    9[0-9] | 100)
        ICON=$BATTERY_100 #DRAWING=off
        ;;
    [6-8][0-9])
        ICON=$BATTERY_75 #DRAWING=off
        ;;
    [3-5][0-9])
        ICON=$BATTERY_50
        ;;
    [1-2][0-9])
        ICON=$BATTERY_25
        COLOR=$ORANGE
        ;;
    *)
        ICON=$BATTERY_0
        COLOR=$RED
        ;;
esac

if [[ $CHARGING != "" ]]; then
    ICON=$BATTERY_CHARGING
    # DRAWING=off
fi

sketchybar --set "$NAME" drawing=$DRAWING icon="$ICON" icon.color="$COLOR"

popup() {
    sketchybar --set "$NAME" popup.drawing="$1"
}

update() {
    label="Charge $PERCENTAGE%"
    if [ "$REMAINING_TIME" != "" ]; then
        label="$label, remaining time $REMAINING_TIME"
    fi
    args=(--remove battery.info
        --add item battery.info popup.battery --set battery.info
        label="$label")
    sketchybar -m "${args[@]}" >/dev/null
}

case "$SENDER" in
    "routine" | "forced" | "power_source_change")
        update
        ;;
    "mouse.clicked")
        popup toggle
        ;;
    "mouse.exited")
        popup off
        ;;
esac
