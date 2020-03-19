#!/bin/bash
## Check to see if 3 arguments where entered
if [ "$#" -eq 3 ]; then
##Check if all 3 arguments Exist
    if [ -e "$1" ] && [ -e "$2" ] && [ -e "$3" ]; then
##Check if arguement 1 is newer then arguments 2 and 3
        if [ "$1" -nt "$2" ] && [ "$1" -nt "$3" ]; then
            echo "$1"
##Check if arguement 2 is newer then arguments 1 and 3
        elif [ "$2" -nt "$1" ] && [ "$2" -nt "$3" ]; then
            echo "$2"
##Check if arguement 3 is newer then arguments 2 and 1
        elif [ "$3" -nt "$2" ] && [ "$3" -nt "$1" ]; then
            echo "$3"
        fi   
    else
        echo "Error: Not all Arguments are DIrectories"
        exit 2
    fi
else
    echo "Error: Not 3 Arguments"
    exit 1
fi
exit 0