#!/bin/bash

# Student Name : Hayden Grimes
# Student Number : 10424698

fileName='./rectangle.txt'
destinationFileName="./rectangle_f.txt"

function checkSourceFile () {
    if [ -f $fileName ]; then
        echo "HERE"
        true
    else
        echo "$fileName doesn not exist.\n Please create or select a different File."
        false
    fi
}

function homeScreen () {
    selection=9
    until (( $selection == 0 ))
    do
        echo -e "\nWelcome to the File Format Program.\n"
        echo -e "Current Input File:\t" $fileName
        echo -e "Current Output File:\t" $destinationFileName
        echo -e "\n1: Format File"
        echo -e "2: Change Input File"
        echo -e "3: Change Output File\n"
        echo -e "0: Exit Program\n\n"
        read -p "Please enter your Selection: " selection
        case $selection in
            "1")
                if [ -f $fileName ]; then
                    echo "HERE"
                    sedFile
                else
                    echo -e "\nInput file '$fileName' doesn't not exist.\nPlease create or select a different File."
                    selection=9
                fi
                ;;
            "2")
                changeSourceFile;;
            "3")
                changeDestinationFile;;
            "0")
                exit 0;;
            # Anything else inputted will throw error and reprint homescreen
            *)
                echo "    Error: You did not enter a correct number"
                selection=9;;
        esac
    done
}

function checkDestinationFile () {
    if [ -f $destinationFileName ]; then
        echo $destinationFileName "already exists. Removing..."
        rm $destinationFileName
        echo "Removed" $destinationFileName
    fi
}

function sedFile () {
    checkDestinationFile
    read header < $fileName
    IFS=","
    read -ra header <<< $header
    sed -e '1d'\
        -e 's/Rec/'${header[0]}': Rec/'\
        -e 's/,/\t\t'${header[1]}': /'\
        -e 's/,/\t\t'${header[2]}': /'\
        -e 's/,/\t\t'${header[3]}': /'\
        -e 's/,/\t\t'${header[4]}': /' $fileName > $destinationFileName
}

function changeSourceFile () {
    selection2=""
    until [ "$selection2" == "y" ] || [ "$selection2" == "n" ]
        do
        echo -e "\nThe Current Input File is '" $fileName "'. Is this correct? (y/n)" 
        read -p "Input 'y' or 'n': " selection2
        if [ $selection2 == "n" ]; then
            read -p "Please specify a new File: " answer
            if [ -f "$answer" ]; then
                fileName=$answer
            else
                echo -e "\nError: That file doesn't exist"
                selection2=""
            fi
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\nError: Please Input Either 'y' or 'n'"
            selection2=""
        fi
    done
}

function changeDestinationFile () {
    selection2=""
    until [ "$selection2" == "y" ] || [ "$selection2" == "n" ]
        do
        echo -e "\nThe Current Output file is '" $destinationFileName "'. Is this correct? (y/n)" 
        read -p "Input 'y' or 'n': " selection2
        if [ $selection2 == "n" ]; then
            read -p "Please specify a new File: " destinationFileName
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\nError: Please Input Either 'y' or 'n'"
            selection2=""
        fi
    done
}

homeScreen

exit 0