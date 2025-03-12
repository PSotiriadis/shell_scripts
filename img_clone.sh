#!/bin/bash
########################################################################
# @file         img_clone.sh
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


######################### Functions ##################################################
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
########################################################################################




img_dir_name="$HOME/image_$(date +%d%m%Y)"

echo "This script clone disk partitions (f.e. /dev/sda1) to image files (*.img)"
echo "The disk informations of all /dev/sd* for this machine are:"
# Use `lsblk` to get the NAME of the disk and its partitions, then parse it into the array
lsblk  -T -o NAME,FSTYPE,FSSIZE | grep 'sd'
lsblk_out=$(lsblk  -r -o NAME,FSTYPE,FSSIZE)

# Prompt for the main disk name
read -p "Enter the main disk name (e.g., sda, sdb): " disk_name

echo "The disk informations of all /dev/$disk_name are:"
lsblk  -T -o NAME,FSTYPE,FSSIZE,LABEL /dev/$disk_name

# ############################# NAMES ################################################
# Use `lsblk` to get the NAME of the disk and its partitions, then parse it into the array
lsblk_out=$(lsblk -n -r -o NAME,FSTYPE,LABEL /dev/${disk_name})
# echo $lsblk_out
# Use a while loop to read each line and add it to the array
while IFS= read -r line; do
    # Extract partition names
    name=$(echo "$line" | awk '{print $1}')
    # format=$(echo "$line" | awk '{print $2}')
    # label=$(echo "$line" | awk '{print $3}')

    if [[ "$name" != "${disk_name}" ]]; then
        part_names+=("$name") 
    fi   
done <<< "$lsblk_out"

# NEED TO CHECK IF GIVEN DISK EXISTS

echo "Disk ${disk_name} has following partitions"
for i in "${!part_names[@]}"; do
    echo "partition $((i+1)) name is ${part_names[$i]}"
    echo "Do you want to write an image file of ${part_names[$i]}?"
    # echo "Options y or Y for 'Yes' and n or N for 'No'"
    # Call the function
    get_yes_no_input

    # Capture the return status
    status=$?
    # Handle the return status if needed
    case "$status" in
        0)
            format=$(lsblk -n -o FSTYPE /dev/${part_names[$i]})
            echo "Partition ${part_names[$i]} has the format $format"
            # Add commands for handling zero
            echo "Which format do you want to use?"
            while true; do
                read -p "Enter filesystem type (ext4, vfat, fat32): " fs_type
                
                # Check if the input is one of the valid options
                if [[ "$fs_type" == "ext4" || "$fs_type" == "vfat" || "$fs_type" == "fat32" ]]; then
                    echo "You selected as filesystem format: $fs_type"
                    break  # Exit the loop if valid input is given
                else
                    echo "Invalid input. Please enter ext4, vfat, or fat32."
                fi
            done
            read -p "Give a name for the output image file without extention *.img: " img_name
            
            mkdir $img_dir_name
            sudo umount /dev/${part_names[$i]}
            sudo partclone.${fs_type} -c -s /dev/${part_names[$i]} -o $img_dir_name/$img_name.img
            ;;
            
        1)
            echo "You entered no."
            # Add commands for handling one
            ;;
        2)
            echo "Invalid input."
            echo "Please try again."
            # Add commands for handling two
            ;;
        *)
            echo "Invalid input. Please enter 'y' for yes or 'n' for no."
            ;;
    esac
done

echo "Do you want to write in a file the partition table?"
get_yes_no_input

# Capture the return status
status=$?    
# Use case statement to handle different input values
case "$status" in
    0)
        sudo sfdisk -d /dev/${disk_name} > $img_dir_name/partition_table.partitions
        # Add commands for handling zero
        ;;
    1)
        echo "You entered No."
        # Add commands for handling one
        ;;
    2)
        echo "Invalid input."
        # Add commands for handling two
        ;;
    *)
        echo "Invalid input. Please enter 0, 1, or 2."
        ;;
esac  


