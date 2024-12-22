#!/bin/bash
# Searchable enabled keybinds using rofi

# Kill yad to not interfere with this binds
pkill yad || true

# Define the config files
KEYBINDS_CONF="$HOME/.config/hypr/configs/Keybinds.conf"

# Combine the contents of the keybinds files and filter for keybinds
KEYBINDS=$(cat "$KEYBINDS_CONF" | grep -E '^(bind|bindl|binde|bindm)')

# check for any keybinds to display
if [[ -z "$KEYBINDS" ]]; then
  echo "No keybinds found."
  exit 1
fi

# Use rofi to display the keybinds
echo "$KEYBINDS" | rofi -dmenu -i -p "Keybinds" -config ~/.config/rofi/config-keybinds.rasi

