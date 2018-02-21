#!/bin/bash

convert_video(){
    #ffmpeg -loop 1 -shortest -y -i "$1" -i "$2" -c:v mpeg4 -q:v 6 -c:a mp3 -vf -s 160x128 converted_output.mp4
    #ffmpeg -loop 1 -shortest -y -i "$1" -i "$2" -acodec copy -vcodec mpeg4 result.avi
    #ffmpeg -loop 1 -shortest -y -i "$1" -i "$2" -acodec copy -vcodec mjpeg result.avi
    ffmpeg -loop 1 -i "$1" -i "$2" -c:v mpeg4 -tune stillimage -c:a mp3 -b:a 192k -pix_fmt yuv420p -shortest out.mp4
    #while getopts ":f:d:" opt;do
    #    case $opt in
    #        f) file="$OPTARG"
    #        ;;
    #        d) dir="$OPTARG"
    #        ;;
    #        \?) echo "Invalid option -$OPTARG" >&2
    #        ;;
    #    esac
    #done
    #if $file
    #then
    #    echo "$file"
    #elif $dir
    #then
    #    echo "$dir"
    #fi
    #for file in $(find . -type f)
    #do
    #    #ffmpeg -i $ -c:v mpeg4 -q:v 6 -c:a mp3 -vf scale=160:-1 $ 
    #    #ffmpeg -i $ -c:v mpeg4 -q:v 6 -c:a mp3 -vf -s 160x128 $
    #    echo $file
    #done
}

convert_video "$1" "$2"
