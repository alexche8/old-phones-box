#!/bin/bash

opb_images=$HOME/.opb_images

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

    ffmpeg -loop 1 -i "$image" -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"

    echo $(readlink -f "$file_name" )
}

mk_blackaudio(){
    #TODO create black screen video with mp3 audio
    ffmpeg -loop 1 -i "$image" -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"
}

mk_textedaudio(){
    #TODO create black/blue screen video with just text overlay and input mp3 file

    ffmpeg  -i "$1" -f lavfi -i color=c=blue:s=160x128:d=0.5 -vf \
    "drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeMonoBold.ttf:fontsize=30: \
     fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='Stack Overflow'" \
     -loop 1 -r 24 \
    -codec:a copy output.mp4
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2" "$3" "$4"
elif [ "$1" = "mk_textedaudio" ];then
    mk_textedaudio "$2" "$3"
else
    echo "Command '$1' not supported"
fi
