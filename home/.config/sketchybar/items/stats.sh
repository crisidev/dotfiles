#!/bin/bash

sketchybar --add alias "Stats,CPU" right \
           --set "Stats,CPU" padding_right=0 padding_left=0 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,RAM_line_chart" right \
           --set "Stats,RAM_line_chart" padding_right=-15 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,Disk" right \
           --set "Stats,Disk" padding_right=-5 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Disk\ Utility.app"

sketchybar --add alias "Stats,Network" right  \
           --set "Stats,Network" padding_right=-8 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"

sketchybar --add alias "Stats,Sensors" right  \
           --set "Stats,Sensors" padding_right=-8 padding_left=-10 label.width=0 \
                 click_script="open -a /System/Applications/Utilities/Activity\ Monitor.app"
