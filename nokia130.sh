#!/bin/bash

opb_images=$HOME/.opb_images

# 1. Make imageaudio, textedaudio, blackscreenaudio
# 2. Fix tags for mp3 file to make right order DONE
# 3. Rename folder to Artist - [yyyy] Album
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

fix_songs_order(){
    # set id3 tags as 1.1
    path=$1
    find $1 -name *mp3 -exec eyeD3 --to-v1.1 {} \;
}


rename_folder(){
    eyeD3 --nfo "$1" | grep Album -B 1 -A 1 | cut -d: -f2 | while read x; do echo $x; done
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2" "$3" "$4"
elif [ "$1" = "fix_songs_order" ];then
    fix_songs_order "$2"
elif [ "$1" = "rename_folder" ];then
    rename_folder "$2"
else
    echo "Command '$1' not supported"
fi
