#!/bin/bash

IFS=$'\n'
for item in $(cat filenames.txt); do
    if [ -f $item ]; then
        echo "$item - That file exists"
    elif [ -d $item ]; then
        echo "$item - That's a Directory"
    else
        echo "$item - I don't know what that is!!"
    fi
done

exit 0