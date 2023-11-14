#!/bin/bash

if [ "$SENDER" = "space_windows_change" ]; then
    /usr/bin/python3 "$CONFIG_DIR/plugins/space.py"
fi
