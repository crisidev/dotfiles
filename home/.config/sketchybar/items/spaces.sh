#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
for i in "${!SPACE_ICONS[@]}"; do
    # shellcheck disable=2004
    sid=$(($i + 1))

    space=(
        space=$sid
        icon="${SPACE_ICONS[i]}"
        icon.padding_left=10
        icon.padding_right=10
        padding_left=2
        padding_right=2
        label.padding_right=10
        icon.highlight_color="$RED"
        label.color="$GREY"
        label.highlight_color="$WHITE"
        label.font="sketchybar-app-font:Regular:16.0"
        label.y_offset=-1
        background.color="$BACKGROUND_1"
        background.border_color="$BACKGROUND_2"
        background.drawing=off
        label.drawing=off
        script="$PLUGIN_DIR/space.sh"
    )

    sketchybar --add space space.$sid left \
        --set space.$sid "${space[@]}" \
        --subscribe space.$sid mouse.clicked
done

spaces_bracket=(
    background.color="$BACKGROUND_1"
    background.border_color="$BACKGROUND_2"
)

separator=(
    icon=􀆊
    icon.font="$FONT:Heavy:16.0"
    padding_left=10
    padding_right=8
    label.drawing=off
    display=active
    click_script="$HOME/.bin/hs -c \"return hs.spaces.addSpaceToScreen(hs.screen.mainScreen(), true)\""
    icon.color="$WHITE"
)

sketchybar --add bracket spaces_bracket '/space\..*/' \
    --set spaces_bracket "${spaces_bracket[@]}" \
    \
    --add item separator left \
    --set separator "${separator[@]}"
