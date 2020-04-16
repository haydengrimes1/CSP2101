#!/bin/bash

for file in ~/CSP2101/workshop/*; do
    if [ -d $file ]; then
        echo "$file is a folder"
    elif [ -f $file ]; then
        echo "$file is a file"
    fi
done   
exit 0