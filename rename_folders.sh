#!/bin/bash
########################################################################
# @file         rename_folders.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         12.03.2025
# @copyright    2025
# @description  Rename folders, which include in name a timestamp, as 
#               rosbag output folder names.It removes the timestamp
#               and leave the rest name unchanged
# @argument
########################################################################
# @history
#      - V1.0.0 30.10.2024 Prodromos Sotiriadis
#         ~ Initial Release
########################################################################
# @todo Nothing
########################################################################

# Loop through all directories matching the pattern *_*_* (ensures at least two underscores)
for dir in *_*_*; do
    # Ensure it is actually a directory before renaming
    if [ -d "$dir" ]; then
        # Generate new name by removing the timestamp
        new_name=$(echo "$dir" | sed -E 's/(_[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2})$//')

        # Rename only if necessary
        if [ "$dir" != "$new_name" ]; then
            echo "Renaming: $dir -> $new_name"
            mv "$dir" "$new_name"
        fi
    fi
done

echo "Renaming complete!"

