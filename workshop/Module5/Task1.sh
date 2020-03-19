#!/bin/bash

read -p "What folder would you like to Copy? " folderName

if [ -d "$folderName" ]; then
    read -p "New folder name: " newFolderName
    cp -r "$folderName" "$newFolderName"
else

    echo "Error"
fi

exit 0