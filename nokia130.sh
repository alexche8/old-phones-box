#!/bin/bash

opb_images=$HOME/.opb_images

# 1. Make imageaudio, textedaudio, blackscreenaudio
# 2. Fix tags for mp3 file to make right order DONE
# 4. Copy contact book.
# 5. Fix tags for mp3 file to make right order set order:song to title if not works

mk_imageaudio(){
    if [ -z "$3" ]; then
        file_name="${1%.*}"_nokia130.mp4
    else
        file_name=$3
    fi

    #if [ -z "$2" ]; then
    #    image=$opb_images/default.jpg
    #    image=${2:-$opb_images/default.jpg}
    #else
    #    image=$2
    #fi

    convert -size 32x32 xc:white default.jpg

    ffmpeg -loop 1 -i default.jpg -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"

    echo $(readlink -f "$file_name" )
}

format_tracks_titles(){
    export PYTHONIOENCODING=utf8
    new_title=$(eyeD3 -P display --pattern "%track%.%title%" "$1")
    echo $new_title
    eyeD3 --title="$new_title" "$1"
}


format_album_name(){
    album=$(eyeD3 -P nfo "$1" | grep Album | cut -d: -f2)
    artist=$(eyeD3 -P nfo "$1" | grep Artist | cut -d: -f2)
    year=$(eyeD3 -P nfo "$1" | grep Recorded | cut -d: -f2)
    mv "$1" "${artist:1}[${year:1}]-${album:1}"
    echo -e "$1" formated as "${artist:1}[${year:1}]-${album:1}"
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2" "$3" "$4"
elif [ "$1" = "format_tracks_titles" ];then
    format_tracks_titles "$2"
elif [ "$1" = "format_album_name" ];then
    format_album_name "$2"
else
    echo "Command '$1' not supported"
fi
