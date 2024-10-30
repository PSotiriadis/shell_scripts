#!/bin/bash
########################################################################
# @file         img_clone.sh.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         30.10.2024
# @copyright    2020-2021
# @description
# @argument
########################################################################
# @history
#      - V1.0.0 30.10.2024 Prodromos Sotiriadis
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



echo "Clone image process will be started"
echo "In system there is following disk information:"
echo "${YELLOW}"
df
echo "${NOCOLOR}"
echo "${NOCOLOR}Choose which disk do you want to clone (i.e. sda, sdb, sdc???)" 
read choosen_disk
echo "You choose ${LIGHT_CYAN} $choosen_disk${NOCOLOR} as disk to clone"

# Capsule the choosen disk and look how many partitions it has
echo "${YELLOW}"
lsblk -i   
df_info=$(lsblk -l --noheadings -o NAME,FSTYPE /dev/sdc )
echo $df_info
echo "${NOCOLOR}"

# Initialize variables to store format types
sdc1_format=""
sdc2_format=""

# Convert the string into an array
# read -r -a array <<< "$df_info"
readarray -t array <<< "$df_info"


# Loop through the array to find and assign format values
for (( i=0; i<${#array[@]}; i++ )); do
    # Print each element for debugging
    echo "Element $i: ${array[i]}"
    
    # Check if the current element is sdc1 or sdc2, then capture the next element
    if [ "${array[i]}" = "sdc1" ]; then
        sdc1_format=${array[i+1]}   # Assign the format for sdc1
        echo "Found sdc1 format: $sdc1_format"
    elif [ "${array[i]}" = "sdc2" ]; then
        sdc2_format=${array[i+1]}   # Assign the format for sdc2
        echo "Found sdc2 format: $sdc2_format"
    fi
done

# Output to verify variables are set correctly
echo "Final sdc1 format: $sdc1_format"
echo "Final sdc2 format: $sdc2_format"