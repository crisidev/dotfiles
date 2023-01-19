#!/usr/bin/zsh

if [ $# -ne 4 ]; then
    echo "usage $0 source-file output-image language resize-percentage"
    exit 1
fi

silicon $1 -o $2 --theme Enki-Tokyo-Night --pad-horiz 20 --pad-vert 20 --shadow-blur-radius 20 --background '#00000000' --shadow-color '#00000000' --language $3
convert -resize $4 $2 $2
