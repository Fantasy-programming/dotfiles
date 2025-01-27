#!/usr/bin/env sh

# set variables

confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
roDir="$confDir/rofi"
roconf="$roDir/styles/style_7.rasi"

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

if [ ! -f "${roconf}" ]; then
  roconf="$(find "${confDir}/rofi/styles" -type f -name "style_*.rasi" | sort -t '_' -k 2 -n | head -1)"
fi

if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    export hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
    export hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"

    # Check if they are valid numbers, otherwise set defaults
    if [[ ! "${hypr_border}" =~ ^[0-9]+$ ]]; then
        hypr_border=8
    fi
    if [[ ! "${hypr_width}" =~ ^[0-9]+$ ]]; then
        hypr_width=2
    fi

fi


# Debugging output
echo "hypr_border: $hypr_border"
echo "hypr_width: $hypr_width"

#// rofi action

case "${1}" in
d | --drun) r_mode="drun" ;;
w | --window) r_mode="window" ;;
f | --filebrowser) r_mode="filebrowser" ;;
h | --help)
  echo -e "$(basename "${0}") [action]"
  echo "d :  drun mode"
  echo "w :  window mode"
  echo "f :  filebrowser mode,"
  exit 0
  ;;
*) r_mode="drun" ;;
esac

# set overrides

wind_border=$((hypr_border * 3))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$((hypr_border * 2))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
i_override="configuration {icon-theme: \"${i_override}\";}"

# launch rofi
rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"
