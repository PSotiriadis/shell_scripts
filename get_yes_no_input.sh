#!/bin/bash
########################################################################
# @file         get_yes_no_input.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         01.11.2024
# @copyright    2020-2021
# @description
# @argument
########################################################################
# @history
#      - V1.0.0 01.11.2024 Prodromos Sotiriadis
#         ~ Initial Release
########################################################################
# @todo Nothing
########################################################################

# Color definitions for output
NOCOLOR="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
LIGHT_GRAY="\033[0;37m"
DARK_GRAY="\033[1;30m"
LIGHT_RED="\033[1;31m"
LIGHT_GREEN="\033[1;32m"
YELLOW="\033[1;33m"
LIGHT_BLUE="\033[1;34m"
LIGHT_PURPLE="\033[1;35m"
LIGHT_CYAN="\033[1;36m"
WHITE="\033[1;37m"

# Function to read a character input
get_yes_no_input() {
    local user_input

    # Prompt the user for input
    echo "Please enter 'y' for yes or 'n' for no:"
    read -n 1 user_input  # Read a single character without waiting for Enter
    echo  # Move to the next line for clarity

    # Check the input
    if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
        echo "You entered Yes."
        return 0  # Return 0 for yes
    elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
        echo "You entered No."
        return 1  # Return 1 for no
    else
        echo "Invalid input. Please enter 'y' or 'n'."
        return 2  # Return 2 for invalid input
    fi
}

# Call the function
get_yes_no_input

# Capture the return status
status=$?

# Handle the return status if needed
if [ $status -eq 2 ]; then
    echo "Please try again."
fi
