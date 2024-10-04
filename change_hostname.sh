#!/bin/bash
########################################################################
# @file         change_hostname.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         04.07.2024
# @copyright    2020-2021
# @description
# @argument
########################################################################
# @history
#      - V1.0.0 04.07.2024 Prodromos Sotiriadis
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

hosts_path="/etc/hosts"

old_hostname=$(hostname)
echo "Old hostname: $old_hostname"
echo "Please give desired hostname to set on speedy robot:"
read new_hostname

echo "You choose as new hostname for speedy: $new_hostname"



sudo hostnamectl set-hostname $new_hostname

sudo sed -i "s/${old_hostname}/${new_hostname}/g" "$hosts_path"

echo "Hostname is changed from $old_hostname to new_hostname. Bellow hostnamectl information:"
hostnamectl

echo "If everything is OK, a restart is needed in order to make changes take effect"
echo "Do you want to restart system now?"
read do_restart

if [[ "$do_restart" == "Y" || "$do_restart" == "y" ]]; then
	sudo reboot
else
	echo "No reboot is performed. Please make reboot later manualy to make change take effect"
fi
 
