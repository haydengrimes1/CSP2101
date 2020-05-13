#!/bin/bash

declare -a rectangleList

IFS=$'\n'
for rectangle in $(cat rectangle.txt); do
    rectangleList+=$rectangle
done

echo -e "\033[32m<MESSAGE>\033[0m testing"

exit 0