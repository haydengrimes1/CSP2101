#!/bin/bash

# Student Name : Hayden Grimes
# Student Number: 10424698

# Define global variables
age=0
guess=0
counter=0
minAge=20
maxAge=70
selection=9

# Function to generate random numbers based off the set MinAge and MaxAge Variables
function getRandomNumber () {
    ((difference=$maxAge-$minAge))
    age=$((RANDOM%(difference+1) + $minAge))
}

# Function to clear the terminal screen
function clearScreen () {
    echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
    }

# Function to get the MinAge variable
function changeMinAge () {
    locMinAge=maxAge+1
    # While loop to check if the inputed number is greated then the max ages
    while (( $locMinAge >= $maxAge ))
    do
        clearScreen
        echo "    The current minimum age is: $minAge"
        echo -e "\n    The current maximum age is: $maxAge"
        echo -e "\n\n"
        read -p "    What would you like the minimum age to be? " locMinAge
        # Check if variable inputed is a positive integer, will not allow negative integer, string,floats
        if [[ $locMinAge =~ ^[+]?[0-9]+$ ]]; then
            if (( $locMinAge >= $maxAge )); then
                clearScreen
                echo "    The Minimum Age must be less then the Maximum Age"
                sleep 4
            else
                clearScreen
                echo "    Minimum age changed to: $locMinAge"
                sleep 2   
                minAge=$locMinAge
            fi
        else
            clearScreen
            echo "    You must enter a Positive Integer"
            locMinAge=maxAge+1
            sleep 3
        fi
    done
}

# Function to get the MaxAge variable
function changeMaxAge () {
    locMaxAge=minAge-1
    # While loop to check if the inputed number is greated then the max ages
    while (( $locMaxAge <= $minAge ))
    do
        clearScreen
        echo "    The current minimum age is: $minAge"
        echo -e "\n    The current maximum age is: $maxAge"
        echo -e "\n\n"
        read -p "    What would you like the maximum age to be? " locMaxAge
        # Check if variable inputed is a positive integer, will not allow negative integer, string,floats
        if [[ $locMaxAge =~ ^[+]?[0-9]+$ ]]; then
            if (( $locMaxAge <= $minAge )); then
                clearScreen
                echo "    The Maximum Age must be more then the Minimum Age"
                sleep 4
            else
                clearScreen
                echo "    Maximum age changed to: $locMaxAge"
                sleep 2   
                maxAge=$locMaxAge
            fi
        else
            clearScreen
            echo "    You must enter a Positive Integer"
            locMaxAge=minAge-1
            sleep 3
        fi
    done
}
# The default screen
function homeScreen () {
    # While loop to contiune untill 0 is entered then will exit (This is to ensure user will alway return to home screen)
    while (( $selection != 0 ))
    do
        clearScreen
        echo "  ----- Home Screen -----"
        echo -e "\n\n"
        echo "    1: Start Guessing Game"
        echo "    2: Change Min Age   (Min Age = $minAge)"
        echo "    3: Change Max Age   (Max Age = $maxAge)"
        echo -e "\n"
        echo "    0: Exit"
        echo -e "\n\n"
        read -p "    Enter Selection: " selection
        # Case statement to asssit with selection options
        case $selection in
            "1")
                startGame;;
            "2")
                changeMinAge;;
            "3")
                changeMaxAge;;
            "0")
                clearScreen
                echo "    Exiting..."
                sleep 1
                clearScreen
                exit 0;;
            # Anything else inputted will throw error and reprint homescreen
            *)
                clearScreen
                echo "    Error: You did not enter a correct number"
                sleep 2
                selection=9;;
        esac
    done
}
#Function for users to make guess once game started
function makeGuess () {
    # While statement to keep looking untill the guess is correct
    while [ $guess -ne $age ]
    do
        echo "    The Minimum age is: $minAge"
        echo -e "    The Maximum age is: $maxAge\n"
        echo -e "    Amount of guesses: $counter \n\n"
        read -p "    Please make a guess: " guess
        # Make sure the inputed guess is a positive integer
        if [[ $guess =~ ^[+]?[0-9]+$ ]]; then
            # Check if guess is more then the max ages and warn user
            if (( $guess > $maxAge )); then
                clearScreen
                echo "    You're guess is greater then the Maximum Age"
                sleep 3
                clearScreen
                guess=0
                ((counter=counter+1))
            # Check if guess is less then the min age and warn user
            elif (( $guess < $minAge )); then
                clearScreen
                echo "    You're guess is less then the Minimum Age"
                sleep 3
                clearScreen
                guess=0
                ((counter=counter+1))
            # If the guess is in between the min and max ages
            else
                clearScreen
                echo -e "    Your guess was: $guess\n\n\n"
                echo "    Checking your guess..."
                ((counter=counter+1))
                sleep 2
                clearScreen
                echo -e "\n\n\n\n\n"
                # check if guess is correct
                if [ $guess -eq $age ]; then
                    echo "    Correct"
                    sleep 4
                    clearScreen
                # check if guess is greater then the random age
                elif [ $guess -gt $age ]; then
                    echo "    $guess is to High"
                    sleep 2
                    clearScreen
                # check if guess is less then the random age
                elif [ $guess -lt $age ]; then
                    echo "    $guess is to Low"
                    sleep 2
                    clearScreen
                # Anything else. Should be impossible
                else
                    echo "Error"
                fi
            fi
        # Output if anything other then positive integer is entered
        else
            clearScreen
            echo "    You Must enter a Positive Integer."
            echo "    This will not count as a guess."
            sleep 4
            clearScreen
            guess=0
        fi
    done
}

#Function for starting the game
function startGame () {

    age=0
    guess=0
    counter=0

    clearScreen
    echo "    Welcome to the Guessing Game"
    sleep 2
    clearScreen
    echo "    Generating a Random Age between $minAge - $maxAge ..."
    sleep 5
    clearScreen
    getRandomNumber
    echo "    Age has been Generated between $minAge - $maxAge"
    sleep 3
    clearScreen
    makeGuess
    echo -e "    Finished\n"
    echo "    Amount of Guesses : $counter"
    echo "    Age : $age "
    echo -e "\n\n   Thanks for playing\n"
    read -p "Press any button to return to the Home Screen..."
    clearScreen
}


# Initialise the homescreen

homeScreen


exit 0