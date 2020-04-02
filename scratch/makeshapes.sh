#!/bin/bash

length=7
width=2
lcounter=0
wcounter=0

while [ $lcounter -lt $length ]
do
    wcounter=0
    while [ $wcounter -lt $width ]
    do
        echo -n " ■"
        ((wcounter=$wcounter+1))
    done
    echo -e ""
    ((lcounter=$lcounter+1))
done



exit 0;
