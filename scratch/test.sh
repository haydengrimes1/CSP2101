#!/bin/bash

read -p "What is your name: " name
echo "hello $name"

read -s -p "What is your password: " pass
echo  "Password is : $pass"

echo -e  "\e[93m\e[1mTesting"

read -n1 -p "Press and Key to exit"
exit 0


