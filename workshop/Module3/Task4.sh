#!/bin/bash

# Read username with prompt using -p
read -p "Please enter your Username: " username
# Read password with prompt and Secret -s -p
read -s -p "Please enter you Password: " password

#Sending the output of echo to secret.txt
echo "$username:$password" >> secret.txt



exit 0