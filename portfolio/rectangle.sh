#!/bin/bash

# Student Name : Hayden Grimes
# Student Number : 10424698

fileName='./rectangle.txt'
destinationFileName="./rectangle_f.txt"

function checkSourceFile () {
    if [ -f $fileName ]; then
        true
    else
        echo -e "\e[31m$fileName doesn not exist.\n Please create or select a different File.\e[39m"
        false
    fi
}

function homeScreen () {
    selection=9
    until (( $selection == 0 ))
    do
        echo -e "\e[96m\nWelcome to the File Format Program.\n"
        echo -e "Current Input File:\t\e[36m" $fileName
        echo -e "\e[96mCurrent Output File:\t\e[36m" $destinationFileName
        echo -e "\e[96m\n1: \e[36mFormat File"
        echo -e "\e[96m2: \e[36mChange Input File"
        echo -e "\e[96m3: \e[36mChange Output File\n"
        echo -e "\e[96m0: \e[31mExit Program\n\n\e[96m"
        read -p "Please enter your Selection: " selection
        case $selection in
            "1")
                if [ -f $fileName ]; then
                    sedFile
                else
                    echo -e "\e[31m\nInput file '$fileName' doesn't not exist.\nPlease create or select a different File.\e[39m"
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
                echo -e "\e[31m\nError: You did not enter a correct number\e[39m"
                selection=9;;
        esac
    done
}

function checkDestinationFile () {
    if [ -f $destinationFileName ]; then
        echo -e "\e[91m\n$destinationFileName already exists. Removing...\e[39m"
        rm $destinationFileName
        echo -e "\e[91mRemoved $destinationFileName\e[39m"
    fi
}

function sedFile () {
    counter=0
    dataAmount=0
    error=0
    while read -r line
    do
        ((counter++))
        if [ $counter = 1 ]; then
            IFS=","
            read -ra data <<< $line
            dataAmount=${#data[@]}
        else
            IFS=","
            read -ra data <<< $line
            if [ $dataAmount != ${#data[@]} ]; then
                error=1
                break
            fi
            string='Rec*'
            if [[ "${data[0]}" != $string ]]; then
                error=1
                break
            fi
        fi
    done < "$fileName"
    if [ $error = 0 ]; then
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
        echo -e "\n\e[96m'$fileName' has been Formatted and saved at '$destinationFileName'"
    else
        echo -e "\e[31m\nInvalid Input File Format.\e[39m"
    fi
    
}

function changeSourceFile () {
    selection2=""
    until [ "$selection2" == "y" ] || [ "$selection2" == "n" ]
        do
        echo -e "\e[96m\nThe Current Input File is '" $fileName "'. Is this correct? (y/n)" 
        read -p "Input 'y' or 'n': " selection2
        if [ $selection2 == "n" ]; then
            read -p "Please specify a new File: " answer
            if [ -f "$answer" ]; then
                fileName=$answer
            else
                echo -e "\e[31m\nError: That file doesn't exist\e[39m"
                selection2=""
            fi
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[39m"
            selection2=""
        fi
    done
}

function changeDestinationFile () {
    selection2=""
    until [ "$selection2" == "y" ] || [ "$selection2" == "n" ]
        do
        echo -e "\e[96m\nThe Current Output file is '" $destinationFileName "'. Is this correct? (y/n)" 
        read -p "Input 'y' or 'n': " selection2
        if [ $selection2 == "n" ]; then
            read -p "Please specify a new File: " destinationFileName
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[39m"
            selection2=""
        fi
    done
}

homeScreen

exit 0