#!/bin/bash
########################################################################
# @file         rename_balls.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         12.03.2025
# @copyright    2025
# @description  Rename script for a specific scenario, where a folder
#               has subfolders with names using a rule, f.e. Ball1_xxx.
#               Then giving can rename all folders with Ball1 in name
#               using another string. Used to rename dataset if a wrong
#               name is given during dataset recording
# @argument
########################################################################
# @history
#      - V1.0.0 30.10.2024 Prodromos Sotiriadis
#         ~ Initial Release
########################################################################
# @todo Nothing
########################################################################

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Old Prefix> <New Prefix>"
    exit 1
fi

# Assign arguments to variables
PARENT_DIR="/home/etti4-more/dataset/lab/rosbag"
OLD_PREFIX="$1"
NEW_PREFIX="$2"

# Loop through all subfolders matching the pattern OLD_PREFIX_*cm
for folder in "$PARENT_DIR"/"$OLD_PREFIX"_*cm; do
    # Check if folder exists (to prevent errors when no matching folders are found)
    [ -d "$folder" ] || continue

    # Extract the base name of the folder
    folder_name=$(basename "$folder")

    # Replace the prefix in the folder name
    new_folder_name="${NEW_PREFIX}_${folder_name#${OLD_PREFIX}_}"

    # Define the old and new file names inside the folder
    old_file="$folder/$folder_name.bag"
    new_file="$folder/${new_folder_name}.bag"

    # Rename the folder
    mv "$folder" "$PARENT_DIR/$new_folder_name"

    # Rename the .bag file inside the renamed folder
    if [ -f "$PARENT_DIR/$new_folder_name/$folder_name.bag" ]; then
        mv "$PARENT_DIR/$new_folder_name/$folder_name.bag" "$PARENT_DIR/$new_folder_name/$new_folder_name.bag"
    fi
done

echo "Renaming completed."

