#!/bin/bash

sketchybar --add alias "Stats,CPU" right \
    --set "Stats,CPU" padding_right=0 padding_left=0 label.width=0 \
    click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,RAM_line_chart" right \
    --set "Stats,RAM_line_chart" padding_right=-15 padding_left=-10 label.width=0

sketchybar --add alias "Stats,Disk_bar_chart" right \
    --set "Stats,Disk_bar_chart" padding_right=-5 padding_left=-10 label.width=0

sketchybar --add alias "Stats,Network_speed" right \
    --set "Stats,Network_speed" padding_right=-5 padding_left=-10 label.width=0
sketchybar --add alias "Stats,Network_label" right \
    --set "Stats,Network_label" padding_right=-10 padding_left=-10 label.width=0

sketchybar --add alias "Stats,Sensors_sensors" right \
    --set "Stats,Sensors_sensors" padding_right=-5 padding_left=-10 label.width=0

sketchybar --add alias "Tailscale,Item-0" right \
    --set "Tailscale,Item-0" padding_right=-5 padding_left=-5 label.width=0
