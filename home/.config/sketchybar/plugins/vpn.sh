#!/bin/bash
# shellcheck disable=2016

source "$CONFIG_DIR/icons.sh"

VPN=$(scutil --nc list | grep Connected | sed -E 's/.*"(.*)".*/\1/')

if [[ $VPN != "" ]]; then
  sketchybar -m --set vpn icon="$TAILSCALE_ON" drawing=on
else
  sketchybar -m --set vpn icon="$TAILSCALE_OFF" drawing=on
fi
