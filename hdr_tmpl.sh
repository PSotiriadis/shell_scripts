#!/bin/bash
########################################################################
# @file         hdr_tmpl.sh
# @author       xxx
# @version      V1.0.2
# @date         26.01.2021
# @copyright    2021
# @description  This script creates a shell script file with given
#               filename as first argument by execution, with a standard
#               header. If file exists or no filename isgiven as first
#               argument, this script makes nothing.
# @argument
#     - filename [Name of the shell script file to create]
########################################################################
# @history
#      - V1.0.0 17.12.2020 xxx
#         ~ Initial Release
########################################################################
# @todo Nothing
########################################################################
echo "Current directory is $PWD"

if [ "$(find $PWD -name $1.sh)" != "$PWD/"$1".sh" ]
then
  if [ "$#" -gt 0 ]; then
    FILE_NAME=$1

TODAY=`date +"%d.%m.%Y"`

    echo  "#!/bin/bash
########################################################################
# @file         "$FILE_NAME".sh
# @author       xxx
# @version      V1.0.0
# @date         "$TODAY"
# @copyright    2020-2021
# @description
# @argument
########################################################################
# @history
#      - V1.0.0 "$TODAY" xxx
#         ~ Initial Release
########################################################################
# @todo Nothing
########################################################################
# Color definitions for output
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'" >> "$FILE_NAME".sh

sudo chmod a+x "$FILE_NAME".sh
  else
    echo No filename is given as argument!!!
    echo Call script again giving an argument
  fi
else
  echo File with given filename already exists!!!
fi
