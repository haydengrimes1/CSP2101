#!/bin/bash

input1=$1
input2=$3
sign=$2

if [ $sign = "+" ]
then
    let answer=$input1+$input2
    echo -e "\033[34m" $answer
elif [ $sign = "-" ]
then
    let answer=$input1-$input2
    echo -e "\033[32m" $answer
elif [ $sign = "x" ]
then
    let answer=$input1*$input2
    echo -e "\033[31m" $answer
elif [ $sign = "/" ]
then
    let answer=$input1/$input2
    echo -e "\033[35m" $answer
fi
