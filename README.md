# shell_scripts
This package is a collections of usefull shell scripts

A list with the commited shell script is here:
* hdr_tmpl.sh
* ros2_create_pkg.sh
* change_hostname.sh
* get_yes_no_input.sh
* img_clone.sh
* rename_balls.sh
* rename_folders.sh

---

# Script detailed description
<b>hdr_tmpl.sh</b>

This script creates a shell script file with given filename as first argument by execution, with a standard header. If file exists or no filename isgiven as first argument, this script makes nothing.

Arguments:
* filename [Name of the shell script file to create]



<b>ros2_create_pkg.sh</b>

This script creates a ROS2 package with name and dependencies, which are given via keyboard. The dependencies should be seperated with space!!!
The script creates the package, with the given package name and dependencies, and add template files for *.cpp and *.hpp in the correct place. It also add code in CMakeLists.txt in order to compile this package and to generate an executable for this package.

Arguments: No



<b>change_hostname.sh</b>

This script is used to change the hostname of a machine. It has no arguments, but it read during the execution from input. The script asks for restart to make changes take effect. 

Arguments: No



<b>get_yes_no_input.sh</b>
This script contains a function to read input and evaluate if yes or no is given. Then run the function and return 0 for yes and 1 for no.

Arguments: No



<b>img_clone.sh</b>

This script is used to create an image for partitions of selected disk. This script may not work properly!! It needs test...

Arguments: No



<b>rename_balls.sh</b>

Rename script for a specific scenario, where a folder has subfolders with names using a rule, f.e. Ball1_xxx. Then giving can rename all folders with Ball1 in name using another string. Used to rename
dataset if a wrong name is given during dataset recording

Arguments: No



<b>rename_folders.sh</b>

Rename folders, which include in name a timestamp, as rosbag output folder names.It removes the timestamp and leave the rest name unchanged

Arguments: No



---

