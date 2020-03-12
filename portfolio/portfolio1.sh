#!/bin/bash

age=0
guess=0
differance=0

function getRandomNumber () {
    age=$((RANDOM%51 + 20))
}

function makeGuess () {
    read -r guess
    if "${guess//[0-9]}" && -n "$guess" {
        echo "Incorrent Input."
    }



}

makeGuess

exit 0