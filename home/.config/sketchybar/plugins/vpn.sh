#!/bin/bash
# shellcheck disable=1091

source "$CONFIG_DIR/icons.sh"

if /Applications/Tailscale.app/Contents/MacOS/Tailscale status >/dev/null; then
    sketchybar -m --set vpn icon="$TAILSCALE_ON" drawing=on
else
    sketchybar -m --set vpn drawing=off
fi
