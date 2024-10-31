# #!/bin/bash
# ########################################################################
# # @file         img_clone.sh.sh
# # @author       Prodromos Sotiriadis
# # @version      V1.0.0
# # @date         30.10.2024
# # @copyright    2020-2021
# # @description
# # @argument
# ########################################################################
# # @history
# #      - V1.0.0 30.10.2024 Prodromos Sotiriadis
# #         ~ Initial Release
# ########################################################################
# # @todo Nothing
# ########################################################################

# Prompt for the main disk name
read -p "Enter the main disk name (e.g., sda, sdb): " disk_name

# Initialize an empty array for formats
formats=()
# Initialize an empty array for partition names
part_names=()

# Use `lsblk` to get the FSTYPE of the disk and its partitions, then parse it into the array
while IFS= read -r line; do
    # Extract the FSTYPE (filesystem type) from each line and add it to the array
    format=$(echo "$line" | awk '{print $2}')
    if [[ -n $format ]]; then
        formats+=("$format")
    fi
done < <(lsblk -r -o NAME,FSTYPE | grep "^${disk_name}[0-9]* ")

# Print the contents of the array for verification
echo "Filesystem formats for $disk_name and its partitions:"
for i in "${!formats[@]}"; do
    part_names[i]=${disk_name}$((i+1))
    # Check if the current format is vfat and change it to fat32
    if [ "${formats[$i]}" = "vfat" ]; then
        formats[$i]="fat32"
    fi
    echo "partition ${part_names[$i]} has the format ${formats[$i]}"
    # sudo partclone.${formats[$i]} -c -s /dev/${part_names[$i]} -o ~/system-part.img
done

