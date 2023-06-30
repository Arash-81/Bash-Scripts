#!/bin/bash

find "$1" -type f -print0 | while read -d $'\0' file
do

    if [[ ${file,,} == *'.jpg' || ${file,,} == *'.jpeg' || ${file,,} == *'.png' || ${file,,} == *'.mp4'
        || ${file,,} == *'.avi' || ${file,,} == *'.3gp' || ${file,,} == *'.mpeg' || ${file,,} == *'.mkv'
        || ${file,,} == *'.vmw' || ${file,,} == *'.mov' ]]
    then

        year=$(date -r "$file" +"%Y")
        mkdir -p "$2/$year"

        if [[ ${file,,} == *'.jpg' || ${file,,} == *'.jpeg' || ${file,,} == *'.png' ]]
        then
            mkdir -p "$2/$year/photos"
            width="$(identify -format '%w' "$file")"
            if [ "$width" -gt 1024 ]; then
                convert "$file" -resize 1024 "$2/$year/photos/$(basename -- "$file")"
            else
                cp "$file" "$2/$year/photos/"
            fi
        else
            mkdir -p "$2/$year/videos"
            cp "$file" "$2/$year/videos/"
        fi
    fi
done

