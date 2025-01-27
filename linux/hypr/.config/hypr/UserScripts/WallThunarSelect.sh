#!/bin/bash
# Script for setting wallpapers from Thunar

# WALLPAPERS PATH
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# Variables
focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
# swww transition config
FPS=60
TYPE="any"
DURATION=1.5
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg >/dev/null; then
  pkill swaybg
fi

# Initiate swww if not running
swww query || swww-daemon --format xrgb

# Main logic
main() {
  if [[ -z "$1" ]]; then
    echo "Usage: $0 <image-path>"
    exit 1
  fi

  image_path="$1"

  # Validate the image file
  if [[ ! -f "$image_path" ]]; then
    echo "Error: File not found - $image_path"
    exit 1
  fi

  # Set the wallpaper
  swww img -o "$focused_monitor" "$image_path" $SWWW_PARAMS

  # Additional scripts
  sleep 1.5
  "$SCRIPTSDIR/WallustSwww.sh"
  sleep 0.5
  "$SCRIPTSDIR/Refresh.sh"
}

main "$@"
