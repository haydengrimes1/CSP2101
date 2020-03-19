#!/bin/bash
## Check if secret.txt exists
if [ -e ../secret.txt ]; then
## Read a print file content to screen
    cat ../secret.txt
else
## If not exist print error
    echo "Error: FIle not Found"

fi

exit 0
