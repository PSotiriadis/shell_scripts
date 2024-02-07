# shell_scripts
This package is a collections of usefull shell scripts

A list with the commited shell script is here:
* hdr_tmpl.sh
* ros2_create_pkg.sh

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

---

