#!/bin/bash

# 1. Make imageaudio, textedaudio, blackscreenaudio
# 4. Copy contact book.
# 6. Download youtube video and playlists

mk_imageaudio(){
    file_name="${1%.*}"_nokia130.mp4

    convert -size 32x32 xc:white default.jpg

    ffmpeg -loop 1 -i default.jpg -i "$1" -c:v mpeg4 -tune stillimage \
    -c:a mp3 -b 1k -s 160x128 -filter:a "volume=1.5" -shortest "$file_name"

    echo $(readlink -f "$file_name" )
}

format_title_tag(){
    export PYTHONIOENCODING=utf8
    new_title=$(eyeD3 -P display --pattern "%track%.%title%" "$1")
    echo $new_title
    eyeD3 --title="$new_title" "$1"
}

format_title_tag_dir(){
    for i in *.mp3; do
        format_title_tag "$i"
    done;
}


format_album_name(){
    album=$(eyeD3 -P nfo "$1" | grep Album | cut -d: -f2)
    artist=$(eyeD3 -P nfo "$1" | grep Artist | cut -d: -f2)
    year=$(eyeD3 -P nfo "$1" | grep Recorded | cut -d: -f2)
    mv "$1" "${artist:1}${year:1}-${album:1}"
    echo -e "$1" formated as "${artist:1}${year:1}-${album:1}"
}

format_albums_dir(){
    find . -type d -exec nokia130 format_album_name {} \;
}

if [ "$1" = "mk_imageaudio" ];then
    mk_imageaudio "$2"
elif [ "$1" = "format_tracks_titles" ];then
    format_tracks_titles "$2"
elif [ "$1" = "format_title_tag_dir" ];then
    format_title_tag_dir"$2"
elif [ "$1" = "format_album_name" ];then
    format_album_name "$2"
else
    echo "Command '$1' not supported"
fi
