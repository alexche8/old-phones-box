#!/bin/bash

# 1. Make textedaudio

export PYTHONIOENCODING=utf8

convert_video(){
    output="${1%.*}"_nokia130.mp4
    ffmpeg -i "$1" -c:v mpeg4 -q:v 3 -c:a mp3 -vf scale=160:-1 "$output"
}

pull_youtube_playlist(){
    youtube-dl -o "%(title)s.%(ext)s" "$1"
}

mk_imageaudio(){
    file_name="${1%.*}"_nokia130.mp4

    convert -size 32x32 xc:black default.jpg

    ffmpeg -loop 1 -i default.jpg -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"

    echo $(readlink -f "$file_name" )
}

format_album_name(){
    album=$(eyeD3 -P nfo "$1" | grep Album | cut -d: -f2)
    artist=$(eyeD3 -P nfo "$1" | grep Artist | cut -d: -f2)
    year=$(eyeD3 -P nfo "$1" | grep Recorded | cut -d: -f2)
    mv "$1" "${artist:1}${year:1}-${album:1}"
    echo -e "$1" formated as "${artist:1}${year:1}-${album:1}"
}

copy_dir(){
    for dir in */; do
        cp -r --verbose "$dir"* "$2"/"$dir"
    done
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2"
elif [ "$1" = "format_album_name" ];then
    format_album_name "$2"
elif [ "$1" = "copy_dir" ];then
    copy_dir "$2" "$3"
elif [ "$1" = "pull_youtube_playlist" ];then
    pull_youtube_playlist "$2"
elif [ "$1" = "convert_video" ];then
    convert_video "$2"
else
    echo "Command '$1' not supported"
fi
