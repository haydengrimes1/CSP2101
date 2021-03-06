#!/bin/bash

# Student Name : Hayden Grimes
# Student Number : 10424698

#Global Variables
downloadAmount=0
downloadFolder="./downloads"
yesToAll="false"
downloadSize=0

#Function to download single image
# Takes last 4 digits of image number as input
function downloadThumbnail () {
    # Define local variables for function (website URL and Image name)
    local website="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC0"
    local output="DSC0"
    # Append website with imputted 4 digit number followed by .jpg to complete URL
    website=$website$1".jpg"
    # Append output
    output=$output$1".jpg"
    #If statement checks if file has already been downloaded
    # Check if the output exists in download folder
    if [ -f $downloadFolder"/"$output ]; then
        selection2=""
        # Until loop to ensure users doesnt specify anything other then y, n or y2all
        until [ "$selection2" == "y" ] || [ "$selection2" == "n" ] || [ "$yesToAll" == "true" ]
            do
            # Informs user file already downloaded, asks if they want to replace or not
            echo -e "\e[96m$output has already been Downloaded"
            read -p "Would you like to Override? (y/n/y2all): " selection2
            # If no rturns out of function, skipping the download
            if [ $selection2 == "n" ]; then
                return
            # if yes set selection to y and coniunes on out of the until loo[]
            elif [ $selection2 == "y" ]; then
                selection2="y"
            # If y2all sets global variable to true allowing all future downloads to skip the until loop
            elif [ $selection2 == "y2all" ]; then
                yesToAll="true"
            else
            # Print error and reloop for input
                echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[39m"
                selection2=""
            fi
        done
    fi
    #Creates variable response to the response code of the http packet header
    # Curl command downloads the http packet header silently.
    # grep gets the lines which contain http/1.1
    # awk command prints the second word on the line, which is the code
    response=`curl -sI $website | grep -i http/1.1 | awk '{printf $2}'`
    # Checks if response is equal to 200, meaning the http packet response is OK
    if [ $response == 200 ]; then
    # Set filesize variable to outcome of curl, Same as above for response
    # grep command finds lines with content-length
    # awk commands prints the second command which is the file size in bits, Divides the answer by 1024 to get the value in KB, Asnwer is then rounded to 2 decimal spaces
        filesize=`curl -sI $website | grep -i content-length | awk '{print $2}'`
        # Add file size to total download size variable for multiple downloads
        downloadSize=`awk '{print $1+$2}' <<<"${downloadSize} ${filesize}"`
        filesize=`awk '{printf "%.2f", $1/1024}' <<<"${filesize}"`
        # Print message saying file being downloaded
        echo -e "Downloading DSC0$1, with the filename '$output', with a file size of $filesize KB..."
        # Download image and save to output folder and file
        curl -s $website > $downloadFolder"/"$output
        #Add one to download amount to keep count of downloads when multiple are taking place
        ((downloadAmount++))
        echo -e "Download Complete\n"
    fi
}
#Function that is executed when user selects to download specific image
function downloadSingleThumb () {
    choice=0
    # While lopp to ensure user enters a number in the correct range 1533 - 2042
    while [ $choice -lt 1533 ] || [ $choice -gt 2042 ] ; do
    echo -e "\e[96m"
    # Read file choice
    read -p "Which File would you like to download: DSC0" choice
        # Set varaible to use for regular expression
        # Ensures that input only contains numbers
        re='^[0-9]+$'
        # If statement to see if input has anything other then digits
        if ! [[ $choice =~ $re ]]; then
            echo -e "\e[31mError: Please enter a File within the range of DSC01533 - DSC02042\e[96m"
            choice=0
        # Makes sure input is within range
        elif [ $choice -lt 1533 ] || [ $choice -gt 2042 ]; then
            echo -e "\e[31mError: Please enter a File within the range of DSC01533 - DSC02042\e[96m"
        fi
    done
    # Checks if there is an image to download associated with 4 digit number inputted
    local website="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC0$choice.jpg"
    response=`curl -sI $website | grep -i http/1.1 | awk '{printf $2}'`
    if [ $response == 200 ]; then
    # If exists run downloadThumbnail function
        downloadThumbnail $choice
    else
        echo -e "\n\e[31mError: Image '$choice' doesn't exist.\e[96m"
        read -p "Press <Enter> to return to the Home Screen..."
    fi

}
# Function to download all Images
function downloadAllThumb () {
    # Resets yestoall, download amount and download size variables.
    yesToAll="false"
    downloadAmount=0
    downloadSize=0
    local startNum=1533
    local endNum=2042
    local current=$startNum
    #Loop through all numbers inbetween 1533 and 2042 and runs downloadThumbnail for each
    while [ $current -le $endNum ]
        do
        downloadThumbnail $current
        ((current++))
    done
    # If statement checks if total download size it above 1024 bytes
    if (( $downloadSize > 1024 )); then
    # Awk command rounds download size by 1024 to get the size in KB
        downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
        # Rounds download size to a whole number to use for next if statement
        downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
        # checks if rounded amount is more then 1024 to get size in MB
        if (( $downloadSizeRound > 1024 )); then
        # Same steps as above
            downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
            downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
            # Checks if rounded amoutn is more then 1024 to get GB value
            if (( $downloadSizeRound > 1024 )); then
                downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
                # Prints message if download size is at least 1 gb
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize GB"
            else
            # Prints message if download size is at least 1 MB
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize MB"
            fi
        else
        # Print message if download size is at least 1 KB
            echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize KB"
        fi
    else
    # Print message if download size is anything less then 1 KB (Only happen if nothing is downloaded)
        echo -e "\e[96m$downloadAmount Files Downloaded"
    fi 
    read -p "Press <Enter> to return to the Home Screen..."

}
# Function to Download all images in a user defined range
function downloadRangeThumb () {
    echo -e "\e[96m\nPlease enter the Range in which you wish to download..."
    local startNum=0
    local endNum=0
    # While loop to ensure starting number is between 1533 and 2042
    while [ $startNum -lt 1533 ] || [ $startNum -gt 2042 ] ; do
        read -p "Please enter First File in Range: DSC0" startNum
        # Set varaible to use for regular expression
        # Ensures that input only contains numbers
        re='^[0-9]+$'
        # If statement to see if input has anything other then digits
                if ! [[ $startNum =~ $re ]]; then
            echo -e "\e[31mError: Please enter a File within the range of DSC01533 - DSC02042\e[96m"
            startNum=0
        elif [ $startNum -lt 1533 ] || [ $startNum -gt 2042 ]; then
            echo -e "\e[31mPlease enter a File within the range of DSC01533 - DSC02042\e[96m"
        fi
    done
    while [ $endNum -gt 2042 ] || [ $endNum -lt $startNum ] ; do
        read -p "Please enter Last File in Range: DSC0" endNum
        # Set varaible to use for regular expression
        # Ensures that input only contains numbers
        re='^[0-9]+$'
        # If statement to see if input has anything other then digits
        if ! [[ $endNum =~ $re ]]; then
            echo -e "\e[31mPlease enter a File within the range of DSC0$startNum - DSC02042\e[96m"
            endNum=0
        elif [ $endNum -gt 2042 ] || [ $endNum -lt $startNum ]; then
            echo -e "\e[31mPlease enter a File within the range of DSC0$startNum - DSC02042\e[96m"
        fi
    done
    echo -e ""
    # Resets yestoall, download amount and download size variables.
    yesToAll="false"
    downloadAmount=0
    downloadSize=0
    local current=$startNum
    # While loop to loop through all numbers between the current and the end number and run download function 
    while [ $current -le $endNum ]
        do
        downloadThumbnail $current
        ((current++))
    done
 # If statement checks if total download size it above 1024 bytes
    if (( $downloadSize > 1024 )); then
    # Awk command rounds download size by 1024 to get the size in KB
        downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
        # Rounds download size to a whole number to use for next if statement
        downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
        # checks if rounded amount is more then 1024 to get size in MB
        if (( $downloadSizeRound > 1024 )); then
        # Same steps as above
            downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
            downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
            # Checks if rounded amoutn is more then 1024 to get GB value
            if (( $downloadSizeRound > 1024 )); then
                downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
                # Prints message if download size is at least 1 gb
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize GB"
            else
            # Prints message if download size is at least 1 MB
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize MB"
            fi
        else
        # Print message if download size is at least 1 KB
            echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize KB"
        fi
    else
    # Print message if download size is anything less then 1 KB (Only happen if nothing is downloaded)
        echo -e "\e[96m$downloadAmount Files Downloaded"
    fi 
    read -p "Press <Enter> to return to the Home Screen..."
}

function downloadRandom () {
    yesToAll="false"
    echo -e "\e[96m"
    ranAmount=0
    local startNum=0
    local endNum=0
    echo -e "\e[96m\nPlease enter the Range in which you wish to download..."
    # While loop to ensure starting number is between 1533 and 2042
    while [ $startNum -lt 1533 ] || [ $startNum -gt 2042 ] ; do
        read -p "Please enter First File in Range: DSC0" startNum
        # Set varaible to use for regular expression
        # Ensures that input only contains numbers
        re='^[0-9]+$'
        # If statement to see if input has anything other then digits
                if ! [[ $startNum =~ $re ]]; then
            echo -e "\e[31mError: Please enter a File within the range of DSC01533 - DSC02042\e[96m"
            startNum=0
        elif [ $startNum -lt 1533 ] || [ $startNum -gt 2042 ]; then
            echo -e "\e[31mPlease enter a File within the range of DSC01533 - DSC02042\e[96m"
        fi
    done
    while [ $endNum -gt 2042 ] || [ $endNum -lt $startNum ] ; do
        read -p "Please enter Last File in Range: DSC0" endNum
        # Set varaible to use for regular expression
        # Ensures that input only contains numbers
        re='^[0-9]+$'
        # If statement to see if input has anything other then digits
        if ! [[ $endNum =~ $re ]]; then
            echo -e "\e[31mPlease enter a File within the range of DSC0$startNum - DSC02042\e[96m"
            endNum=0
        elif [ $endNum -gt 2042 ] || [ $endNum -lt $startNum ]; then
            echo -e "\e[31mPlease enter a File within the range of DSC0$startNum - DSC02042\e[96m"
        fi
    done
    # While loop to ensure user only enters a number between 0 and 75 as there are only 75 images to download
    while [ $ranAmount == 0 ] || [ $ranAmount -gt 75 ] ; do
        read -p "How many images would you like to download: " ranAmount
        re='^[0-9]+$'
        if ! [[ $ranAmount =~ $re ]]; then
            echo -e "\e[31mError: Please enter a Number between 0 - 75\e[96m\n"
            ranAmount=0
        elif [ $ranAmount == 0 ] || [ $ranAmount -gt 75 ]; then
            if [ $ranAmount -gt 75 ]; then
                echo -e "There are only 75 Images to Download"
            fi
            echo -e "\e[31mError: Please enter a Number between 0 - 75\e[96m\n"
        fi
    done       
    echo -e ""
    # Reset download amount and size variables
    downloadAmount=0
    downloadSize=0
    # Until loop loops adding one each time untill reaches the run amount entered by user (Only counts if user choices to download in the case an image has already been downloaded)
    until [ $downloadAmount -ge $ranAmount ]
        do
        # Equation to get a random number within the entered range
        ((difference=$endNum-$startNum))
        number=$((RANDOM%(difference+1) + $startNum))
        downloadThumbnail $number
    done
# If statement checks if total download size it above 1024 bytes
    if (( $downloadSize > 1024 )); then
    # Awk command rounds download size by 1024 to get the size in KB
        downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
        # Rounds download size to a whole number to use for next if statement
        downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
        # checks if rounded amount is more then 1024 to get size in MB
        if (( $downloadSizeRound > 1024 )); then
        # Same steps as above
            downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
            downloadSizeRound=`awk '{printf "%.0f", $1}' <<<"${downloadSize}"`
            # Checks if rounded amoutn is more then 1024 to get GB value
            if (( $downloadSizeRound > 1024 )); then
                downloadSize=`awk '{printf "%.2f", $1/1024}' <<<"${downloadSize}"`
                # Prints message if download size is at least 1 gb
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize GB"
            else
            # Prints message if download size is at least 1 MB
                echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize MB"
            fi
        else
        # Print message if download size is at least 1 KB
            echo -e "\e[96m$downloadAmount Files Downloaded, with a total size of $downloadSize KB"
        fi
    else
    # Print message if download size is anything less then 1 KB (Only happen if nothing is downloaded)
        echo -e "\e[96m$downloadAmount Files Downloaded"
    fi 
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
            # Checks if folder exists and if not makes it
            if [ ! -d $downloadFolder ]; then
                mkdir $downloadFolder
            fi
        elif [ $selection2 == "y" ]; then
            selection2="y"
        else
            echo -e "\e[31m\nError: Please Input Either 'y' or 'n'\e[96m"
            selection2=""
        fi
    done
}
# Main function that runs the homescreen
function homescreen () {
    selection=9
    # Checks if download folder exisist and creates it if it doesnt
    if [ ! -d $downloadFolder ]; then
                mkdir $downloadFolder
    fi
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
                downloadSingleThumb;;
                
            "2")
                downloadAllThumb;;
            "3")
                downloadRangeThumb 1533 1700;;
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
# Initialise the home screen
homescreen
exit 0
