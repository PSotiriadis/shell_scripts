#!/bin/bash
########################################################################
# @file         disk_inf.sh
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

# Prompt for the main disk name
read -p "Enter the main disk name (e.g., sda, sdb): " disk_name

# Initialize an empty array for formats
formats=()
# Initialize an empty array for formats
part_formats=()
# Initialize an empty array for partition names
part_names=()
# Initialize an empty array for partition labels
part_labels=()

# ############################# NAMES ################################################
# Use `lsblk` to get the NAME of the disk and its partitions, then parse it into the array
lsblk_out=$(lsblk -n -r -o NAME,FSTYPE,LABEL /dev/${disk_name})
# echo $lsblk_out
# Use a while loop to read each line and add it to the array
while IFS= read -r line; do
    # Extract partition names
    name=$(echo "$line" | awk '{print $1}')
    format=$(echo "$line" | awk '{print $2}')
    label=$(echo "$line" | awk '{print $3}')

    if [[ "$name" != "${disk_name}" ]]; then
        part_names+=("$name")
        # Extract partition formats
        if [[ -n $format ]]; then
            part_formats+=("$format")
        else
            format="NO_FORMAT"
            part_formats+=("$format")
        fi    

        # Extract partition labels
        if [[ -n $label ]]; then
            part_labels+=("$label")
        else
            label="NO_LABEL"
            part_labels+=("$label")
        fi   
    fi   
done <<< "$lsblk_out"

echo "part_names array size is ${#part_names[@]}"
for i in "${!part_names[@]}"; do
    echo "partition $i name is ${part_names[$i]}"
done

echo "part_formats array size  is ${#part_formats[@]}"
for i in "${!part_formats[@]}"; do
    echo "partition $i format is ${part_formats[$i]}"
done

echo "part_labels array size  is ${#part_labels[@]}"
for i in "${!part_labels[@]}"; do
    echo "partition $i label is ${part_labels[$i]}"
done
