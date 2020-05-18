#!/bin/bash

downloadAmount=0
downloadFolder="./downloads"
yesToAll="false"

function downloadThumbnail () {
    local website="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC0"
    local output="DSC0"
    website=$website$1".jpg"
    output=$output$1".jpg"
    if [ -f $downloadFolder"/"$output ]; then
        selection2=""
        # Until loop to ensure users doesnt specify anything other then y or n
        until [ "$selection2" == "y" ] || [ "$selection2" == "n" ] || [ "$yesToAll" == "true" ]
            do
            echo -e "$output has already been Downloaded"
            read -p "Would you like to Override? (y/n/y2all): " selection2
            if [ $selection2 == "n" ]; then
                return
            elif [ $selection2 == "y" ]; then
                selection2="y"
            elif [ $selection2 == "y2all" ]; then
                yesToAll="true"
            else
                echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[39m"
                selection2=""
            fi
        done
    fi
    response=`curl -sI $website | grep -i http/1.1 | awk '{printf $2}'`
    if [ $response == 200 ]; then
        filesize=`curl -sI $website | grep -i content-length | awk '{printf "%.2f KB", $2/1024}'`
        echo "Downloading DSC0$1, with the filename '$output', with a file size of $filesize..."
        curl -s $website > $downloadFolder"/"$output
        ((downloadAmount++))
        echo -e "Download Complete\n"
    fi
}

function downloadAllThumb () {
    yesToAll="false"
    downloadAmount=0
    local startNum=1533
    local endNum=2042
    local current=$startNum
    while [ $current -le $endNum ]
        do
        downloadThumbnail $current
        ((current++))
    done
    echo "$downloadAmount Files Downloaded"
    read -p "Press <Enter> to return to the Home Screen..."

}

function downloadRangeThumb () {
    yesToAll="false"
    downloadAmount=0
    local startNum=$1
    local endNum=$2
    local current=$startNum
    while [ $current -le $endNum ]
        do
        downloadThumbnail $current
        ((current++))
    done
    echo "$downloadAmount Files Downloaded"

}

function downloadRandom () {
    yesToAll="false"
    read -p "How many images would you like to download: " ranAmount
    downloadAmount=0
    local startNum=1533
    local endNum=2042
    until [ $downloadAmount -ge $ranAmount ]
        do
        ((difference=$endNum-$startNum))
        number=$((RANDOM%(difference+1) + $startNum))
        downloadThumbnail $number
    done
    echo "$downloadAmount Files Downloaded"
    read -p "Press <Enter> to return to the Home Screen..."
}

function changeDownloadFolder () {
    selection2=""
    # Until loop to ensure users doesnt specify anything other then y or n
    until [ "$selection2" == "y" ] || [ "$selection2" == "n" ]
        do
        # Prints the current file name
        echo -e "\e[96m\nThe Current Download Folder is '"$downloadFolder"'. Is this correct? (y/n)" 
        # Prompts for input y or n
        read -p "Input 'y' or 'n': " selection2
        if [ $selection2 == "n" ]; then
        # Prompts for input of new file name and sets answer to the global variable
            read -p "Please specify a new Download Folder: " downloadFolder
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[39m"
            selection2=""
        fi
    done
}

function homescreen () {
    selection=9
    #Until loop to repeat selection until user exits
    until (( $selection == 0 ))
    do
        #Prints homescreen
        echo -e "\e[96m\nWelcome to the Image Downloader\n"
        echo -e "Current Download Directory:\e[36m" $downloadFolder
        echo -e "\e[96m\n1: \e[36mDownload Specific Image"
        echo -e "\e[96m2: \e[36mDownload All Images"
        echo -e "\e[96m3: \e[36mDownload Images in Range"
        echo -e "\e[96m4: \e[36mDownload # of Random Images\n"
        echo -e "\e[96m5: \e[35mChange Download Directory\n"
        echo -e "\e[96m0: \e[31mExit Program\n\n\e[96m"
        read -p "Please enter your Selection: "  selection
        #Case statement to handle users selection
        case $selection in
            "1")
                echo;;
                
            "2")
                downloadAllThumb;;
            "3")
                echo;;
            "4")
                downloadRandom;;
            "5")
                changeDownloadFolder;;
            "0")
                exit 0;;
            # Anything else inputted will throw error and reprint homescreen
            *)
                echo -e "\e[31m\nError: You did not enter a correct number\e[39m"
                 selection=9;;
        esac
    done

}

homescreen
exit 0