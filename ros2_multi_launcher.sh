#!/bin/bash
########################################################################
# @file         ros2_multi_launcher.sh
# @author       Prodromos Sotiriadis
# @version      V1.0.0
# @date         03.07.2026
# @copyright    2020  - 2026 UniBwM-ETTI4-Institute of Embedded Systems
# @description  Start multiple ROS 2 launch files and optional ros2 run 
#               executables in separate GNOME Terminal windows.
# @Options:
#  -w, --workspace PATH     ROS 2 workspace path. Default: ${WORKSPACE}
#  -d, --domain-id ID       Optional ROS_DOMAIN_ID.
#  -h, --help               Show this help.
#
#  Example:
#  ./${SCRIPT_NAME} --workspace ~/clearpath_ws --domain-id 42
########################################################################
# @history
#      - V1.0.0 03.07.2026 Prodromos Sotiriadis
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

set -euo pipefail

# -----------------------------
# Defaults
# -----------------------------

ROS_DISTRO="jazzy"
WORKSPACE="$HOME/ros2_ws"
ROS_DOMAIN_ID_VALUE=""
LAUNCH_DELAY_SEC=2
KILL_TIMEOUT_SEC=5

SCRIPT_NAME="$(basename "$0")"

# Store process group IDs for cleanup.
declare -a CHILD_PGIDS=()

# -----------------------------
# Help
# -----------------------------

print_help()
{
  echo -e "${BLUE}"
  cat <<EOF
Usage:
  ${SCRIPT_NAME} [OPTIONS]

Options:
  -w, --workspace PATH     ROS 2 workspace path. Default: ${WORKSPACE}
  -d, --domain-id ID       Optional ROS_DOMAIN_ID.
  -h, --help               Show this help.

Example:
  ./${SCRIPT_NAME} --workspace ~/clearpath_ws --domain-id 42

Edit these arrays inside the script:
  LAUNCH_COMMANDS
  RUN_COMMANDS

EOF
  echo -e "${NOCOLOR}"
}

# -----------------------------
# Argument parsing
# -----------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    -w|--workspace)
      if [[ $# -lt 2 ]]; then
        echo -e "${RED}[ERROR] Missing value after $1 ${NOCOLOR}"
        print_help
        exit 1
      fi
      WORKSPACE="$2"
      shift 2
      ;;
    -d|--domain-id)
      if [[ $# -lt 2 ]]; then
        echo -e "${RED}[[ERROR] Missing value after $1 ${NOCOLOR}"
        print_help
        exit 1
      fi
      ROS_DOMAIN_ID_VALUE="$2"
      shift 2
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo -e "${RED}[[ERROR] Unknown argument: $1 ${NOCOLOR}"
      print_help
      exit 1
      ;;
  esac
done

WORKSPACE="${WORKSPACE/#\~/$HOME}"

# -----------------------------
# User configuration
# -----------------------------

LAUNCH_COMMANDS=(
  # Replace with your real launch files.
  "ros2 launch dummy_robot_bringup dummy_robot_bringup.launch.py"
  "ros2 launch dummy_robot_bringup dummy_robot_bringup.launch.py"

  # Examples:
  # "ros2 launch my_robot_bringup camera_1_points_bridge.launch.py"
  # "ros2 launch my_robot_bringup camera_2_points_bridge.launch.py"
)

RUN_COMMANDS=(
  # Optional ros2 run executables.
  # "ros2 run teleop_twist_keyboard teleop_twist_keyboard"
  # "ros2 run my_package my_node --ros-args -p use_sim_time:=true"
)

# -----------------------------
# Validation
# -----------------------------

validate_environment()
{
  local ros_setup="/opt/ros/${ROS_DISTRO}/setup.bash"
  local ws_setup="${WORKSPACE}/install/setup.bash"

  if ! command -v gnome-terminal >/dev/null 2>&1; then
    echo -e "${RED}[ERROR] gnome-terminal is not installed.${NOCOLOR}"
    echo -e "${LIGHT_BLUE}[HINT] Install it with:"
    echo "       sudo apt update && sudo apt install gnome-terminal${NOCOLOR}"
    exit 1
  fi

  if [[ -z "${DISPLAY:-}" ]]; then
    echo -e "${RED}[ERROR] DISPLAY is not set. gnome-terminal requires a graphical desktop session.${NOCOLOR}"
    echo -e "${LIGHT_BLUE}[HINT] Run this script from your Ubuntu desktop terminal.${NOCOLOR}"
    exit 1
  fi

  if [[ ! -f "$ros_setup" ]]; then
    echo -e "${RED}[ERROR] ROS setup file not found: $ros_setup${NOCOLOR}"
    echo -e "${LIGHT_BLUE}[HINT] Check that ROS 2 ${ROS_DISTRO} is installed.${NOCOLOR}"
    exit 1
  fi

  if [[ ! -f "$ws_setup" ]]; then
    echo -e "${RED}[ERROR] Workspace setup file not found: $ws_setup${NOCOLOR}"
    echo -e "${LIGHT_BLUE}[HINT] Build your workspace first:"
    echo "       cd ${WORKSPACE} && colcon build --symlink-install${NOCOLOR}"
    exit 1
  fi

  if [[ -n "$ROS_DOMAIN_ID_VALUE" ]]; then
    if ! [[ "$ROS_DOMAIN_ID_VALUE" =~ ^[0-9]+$ ]]; then
      echo -e "${RED}[ERROR] ROS_DOMAIN_ID must be a non-negative integer.${NOCOLOR}"
      exit 1
    fi
  fi
}

# -----------------------------
# Cleanup
# -----------------------------

cleanup()
{
  local exit_code=$?

  trap - EXIT INT TERM

  echo ""
  echo -e "${BLUE}[INFO] Cleaning up ROS 2 processes and GNOME Terminal windows...${NOCOLOR}"

  # Graceful stop.
  for pgid in "${CHILD_PGIDS[@]}"; do
    if kill -0 "-${pgid}" 2>/dev/null; then
      echo -e "${BLUE}[INFO] Sending SIGINT to process group ${pgid}${NOCOLOR}"
      kill -INT "-${pgid}" 2>/dev/null || true
    fi
  done

  sleep "${KILL_TIMEOUT_SEC}"

  # Stronger stop.
  for pgid in "${CHILD_PGIDS[@]}"; do
    if kill -0 "-${pgid}" 2>/dev/null; then
      echo "${YELLOW}[WARN] Process group ${pgid} still alive. Sending SIGTERM.${NOCOLOR}"
      kill -TERM "-${pgid}" 2>/dev/null || true
    fi
  done

  sleep 2

  # Final fallback.
  for pgid in "${CHILD_PGIDS[@]}"; do
    if kill -0 "-${pgid}" 2>/dev/null; then
      echo -e "${RED}[ERROR] Process group ${pgid} ignored SIGTERM. Sending SIGKILL.${NOCOLOR}"
      kill -KILL "-${pgid}" 2>/dev/null || true
    fi
  done

  echo -e "${BLUE}[INFO] Cleanup complete.${NOCOLOR}"
  exit "$exit_code"
}

trap cleanup EXIT INT TERM

# -----------------------------
# Start one command in GNOME Terminal
# -----------------------------

start_in_gnome_terminal()
{
  local title="$1"
  local command="$2"

  local ros_setup="/opt/ros/${ROS_DISTRO}/setup.bash"
  local ws_setup="${WORKSPACE}/install/setup.bash"

  local pgid_file
  pgid_file="$(mktemp "/tmp/ros2_gnome_pgid_${title// /_}_XXXXXX")"

  gnome-terminal \
    --title="$title" \
    -- bash -c "
      set -euo pipefail

      setsid bash -c '
        echo \$\$ > \"$pgid_file\"

        source \"$ros_setup\"
        source \"$ws_setup\"

        if [[ -n \"$ROS_DOMAIN_ID_VALUE\" ]]; then
          export ROS_DOMAIN_ID=\"$ROS_DOMAIN_ID_VALUE\"
        fi

        echo \"[INFO] Window: $title\"
        echo \"[INFO] Command: $command\"
        echo \"[INFO] ROS_DISTRO: $ROS_DISTRO\"
        echo \"[INFO] WORKSPACE: $WORKSPACE\"

        if [[ -n \"\${ROS_DOMAIN_ID:-}\" ]]; then
          echo \"[INFO] ROS_DOMAIN_ID: \${ROS_DOMAIN_ID}\"
        fi

        echo \"----------------------------------------\"

        exec $command
      '
    " &

  local waited=0

  while [[ ! -s "$pgid_file" ]]; do
    sleep 0.1
    waited=$((waited + 1))

    if [[ "$waited" -gt 50 ]]; then
      echo -e "${RED}[ERROR] Failed to get process group ID for: $title${NOCOLOR}"
      echo -e "${RED}[ERROR] Command was: $command${NOCOLOR}"
      rm -f "$pgid_file"
      return 1
    fi
  done

  local pgid
  pgid="$(cat "$pgid_file")"
  rm -f "$pgid_file"

  if ! [[ "$pgid" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}[ERROR] Invalid process group ID received for: $title${NOCOLOR}"
    return 1
  fi

  CHILD_PGIDS+=("$pgid")

  echo -e "${BLUE}[INFO] Started '$title' with process group ${pgid}${NOCOLOR}"
}

# -----------------------------
# Main
# -----------------------------

main()
{
  validate_environment

  echo -e "${BLUE}[INFO] ROS 2 automation starting...${NOCOLOR}"
  echo -e "${BLUE}[INFO] ROS_DISTRO: ${ROS_DISTRO}${NOCOLOR}"
  echo -e "${BLUE}[INFO] WORKSPACE: ${WORKSPACE}${NOCOLOR}"

  if [[ -n "$ROS_DOMAIN_ID_VALUE" ]]; then
    echo -e "${BLUE}[INFO] ROS_DOMAIN_ID: ${ROS_DOMAIN_ID_VALUE}${NOCOLOR}"
  fi

  local index=1

  for command in "${LAUNCH_COMMANDS[@]}"; do
    start_in_gnome_terminal "ROS2 Launch ${index}" "$command"
    index=$((index + 1))
    sleep "$LAUNCH_DELAY_SEC"
  done

  index=1

  for command in "${RUN_COMMANDS[@]}"; do
    start_in_gnome_terminal "ROS2 Run ${index}" "$command"
    index=$((index + 1))
    sleep "$LAUNCH_DELAY_SEC"
  done

  echo -e "${BLUE}[INFO] All ROS 2 commands started.${NOCOLOR}"
  echo -e "${BLUE}[INFO] Press Ctrl+C here to stop all launched processes.${NOCOLOR}"

  while true; do
    sleep 1
  done
}

main
