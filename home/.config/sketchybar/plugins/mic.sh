#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

toggle_mic() {
	"$HOME/.bin/hs" -c "spoon.MicMute:toggleMicMute()"
}

update() {
	MUTED=$("$HOME/.bin/hs" -c "hs.audiodevice.defaultInputDevice():muted()")
	if [ "$MUTED" = "true" ]; then
		COLOR=$RED
	else
		COLOR=$WHITE
	fi

	sketchybar --set $NAME icon.color=$COLOR
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
