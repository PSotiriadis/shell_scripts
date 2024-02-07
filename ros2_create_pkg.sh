#!/bin/bash
########################################################################
# @file         ros2_create_pkg.sh
# @author       xxx
# @version      V1.0.0
# @date         03.02.2024
# @copyright    2020-2021
# @description
# @argument
########################################################################
# @history
#      - V1.0.0 03.02.2024 xxx
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
WHITE='\033[1;37m'


WORK_DIR=$PWD
echo "Whorking directory is $PWD"

#############################################################################################
	# Read the ROS2 package name
echo "Give a ros2 pkg name: "
read package_name
echo "Namespace is: $package_name"


	# Set the package name IFS to underscore (_) as the delimiter
IFS="_"

	# Read package name into an array
read -ra array <<< "$package_name"

	# Reset IFS to the default value (whitespace)
IFS=$' \t\n'

	# Parse elements of package name
#echo "Number of package name elements: ${#array[@]}"
#echo "Package name elements:"
for element in "${array[@]^}"; do
    class_name+="$element"
    #echo "$element"
done



	# Print class name
echo "class name is: $class_name"



#############################################################################################
	# Read the dependencies for the package
echo "Give dependencies seperated with spaces: "
read package_deps
#echo "You entered: $package_deps"




#############################################################################################
	# Create ROS2 package with selected name and dependences
ros2 pkg create $package_name --build-type ament_cmake --dependencies $package_deps





#############################################################################################
# Create cpp template to package src
cd $package_name/src

echo "
/**
 *********************************************************************************
 * @file       "$package_name".cpp
 * @author     xxx  
 * @version    V1.0.0
 * @date       dd.mm.yy
 * @copyright  2023 - 2024
 * @brief      Brief description
 * @details    Detailed description    
 *********************************************************************************
 *  @par History:
 *  @details V1.0.0 
 *         - Initial Release
 *********************************************************************************
 */

#include \"../include/"$package_name"/"$package_name".hpp\"



namespace "$package_name"{

using namespace std;
	"$class_name"::"$class_name"():
			Node(\""$package_name"\")
	{

	}


	"$class_name"::~"$class_name"(){
		/* delete "$class_name" method at the end to free memory */
		delete this;
	}

	void "$class_name"::"$class_name"Callback()
	{

	}
}



/**
  * @brief      Main function for base_controller
  * @details    In this function is "$package_name" node initialized
  *             and an object of "$class_name" defined to take
  *             care of everything
  * @param   [in] argc: Non-negative value representing the number of
  *                     arguments passed to the program from the environment
  *                     in which the program is run.
  * @param   [in] argv: Pointer to an array of pointers to null-terminated
  *                     multibyte strings that represent the arguments passed
  *                     to the program from the execution environment
  * @retval  If the return statement is used, the return value is used as the
  *          argument to the implicit call to exit(). This value can be:
  *                     @arg EXIT_SUCCESS [indicate successful termination]
  *                     @arg EXIT_FAILURE [indicate unsuccessful termination]
  */
int main(int argc, char **argv)
{

  rclcpp::init(argc, argv);

  rclcpp::spin(std::make_shared<"$package_name"::"$class_name">());

  rclcpp::shutdown();

  return 0;
}" >> "$package_name".cpp	

cd $WORK_DIR




#############################################################################################
# Create hpp template to package include
cd $package_name/include/$package_name

package_name_upper=$(echo "$package_name" | tr '[:lower:]' '[:upper:]')

echo "
/**
 *********************************************************************************
 * @file       "$package_name".hpp
 * @author     xxx
 * @version    V1.0.0
 * @date       dd.mm.yy
 * @copyright  2023 - 2024
 * @brief      A Brief description
 * @details    A detailed description
 *********************************************************************************
 *  @par History:
 *  @details V1.0.0 
 *         - Initial Release
 *********************************************************************************
 */
#ifndef SRC_"$package_name_upper"_INCLUDE_"$package_name_upper"_"$package_name_upper"_HPP_
#define SRC_"$package_name_upper"_INCLUDE_"$package_name_upper"_"$package_name_upper"_HPP_

#include \"rclcpp/rclcpp.hpp\"



namespace "$package_name"{
	/**
	 * @brief   A Brief description
	 * @details A detailed description
	 */
	class "$class_name"  : public rclcpp::Node{
	public:
	    /**
		  * @brief    A Brief description
  		  * @details  A detailed description
		  */
		"$class_name"();

		/**
		  * @brief   A Brief description
		  * @details A detailed description
		  */
        ~"$class_name"();
	  /**
		* @brief      A Brief description
		* @details    A detailed description
		*
		* @param      Parameter description
		*/
	  void "$class_name"Callback();

	private:


	};//End of class
}


#endif" >> "$package_name".hpp	

cd $WORK_DIR
echo "$PWD"

# String to add
ADD_EXECUTABLE_TO_CMAKE="add_executable(\${PROJECT_NAME}\ src/\${PROJECT_NAME}\.cpp) \n\
ament_target_dependencies(\${PROJECT_NAME}\ rclcpp std_msgs )\n\
\n\
\n\
include_directories(include/\${PROJECT_NAME} \${Boost_INCLUDE_DIR})\n\
target_link_libraries(\${PROJECT_NAME}\ \${Boost_LIBRARIES})\n\
\n\
# Uncomment if you want to add launch or other folders in package share directory\n\
#install(DIRECTORY src include\n\
#  DESTINATION share/\${PROJECT_NAME}\n\
#)\n\
\n\
install(TARGETS\n\
  \${PROJECT_NAME}\\n\
  DESTINATION lib/\${PROJECT_NAME})\n"

# Use sed to add a line before the line containing "end"
sed -i -e "/ament_package()/ i\\$ADD_EXECUTABLE_TO_CMAKE" "$package_name/CMakeLists.txt"


