#!/bin/bash

echo "1. Create a folder"
echo "2. List files in a folder"
echo "3. Copy a folder"
echo "4. Save a password"
echo "5. Read a password"
echo "6. Print newest file"

read -p "Please select one of the options: " selection

case $selection in
    "1")
        ~/CSP2101/workshop/Module3/foldermaker.sh
        echo "1";;
    "2")
        ~/CSP2101/workshop/Module3/Task3.sh
        echo "2";;
    "3")
        ~/CSP2101/workshop/Module4/Task1.sh
        echo "3";;
    "4")
        ~/CSP2101/workshop/Module3/Task4.sh
        echo "4";;
    "5")
        ~/CSP2101/workshop/Module4/Task3.sh
        echo "5";;
    "6")
        read -p "Enter the first file name: " argument1
        read -p "Enter the second file name: " argument2
        read -p "Enter the third file name: " argument3
        ~/CSP2101/workshop/Module4/Task4.sh $argument1 $argument2 $argument3
        echo "6";;
    *)
        echo "Error: You did not enter a correct number";;
esac
exit 0
    




exit 0