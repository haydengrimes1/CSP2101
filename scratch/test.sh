#!/bin/bash

read -p "What is your name: " name
echo "hello $name"

read -s -p "What is your password: " pass
echo  "Password is : $pass"

echo "Testing"

read -n1 -p "Press and Key to exit"
exit 0


