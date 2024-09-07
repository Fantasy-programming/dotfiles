#!/bin/sh

user='cybersage'
img_array=(~/.wallpapers/*)

img_array_rndm=( $(echo "${img_array[@]}" | tr ' ' '\n' | sort -R) )

transition="--transition-type outer --transition-pos 1,1 --transition-step 90 --transition-fps 144"

delay=60m # Delay in minutes

while true; do
	selected_img=${img_array[$RANDOM % ${#img_array[@]}]}
	swww img $selected_img $transition
  wal -i $selected_img
	sleep ${delay}
done
