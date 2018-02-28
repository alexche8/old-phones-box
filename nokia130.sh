#!/bin/bash

opb_images=$HOME/.opb_images

# 1. Make imageaudio, textedaudio, blackscreenaudio
# 2. Fix tags for mp3 file to make right order
# 3. Rename folder to Artist - [yyyy] Album

mk_imageaudio(){
    if [ -z "$3" ]; then
        file_name="${1%.*}"_nokia130.mp4
    else
        file_name=$3
    fi

    if [ -z "$2" ]; then
        image=$opb_images/default.jpg
    else
        image=$2
    fi

    convert -size 32x32 xc:white default.jpg
    image="default.jpg"

    ffmpeg -loop 1 -i $image -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"

    echo $(readlink -f "$file_name" )
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2" "$3" "$4"
else
    echo "Command '$1' not supported"
fi
