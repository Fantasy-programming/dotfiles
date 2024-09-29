##
## Utility Functions
##

function _smooth_fzf() {
  local filename
  local current_dir="$PWD"

  cd "${XDG_CONFIG_HOME:-~/.config}"
  filename="$(fzf)" || return
  $EDITOR "$filename"

  cd "$current_dir"
}

function _sudo_replace_buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

function _sudo_command_line() {
  # If line is empty, get the last run command from history
  if [[ -z $BUFFER ]]; then
    LBUFFER="$(fc -ln -1)"
  fi

  # Save beginning space if present
  local WHITESPACE=""

  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
  # Else use the default $EDITOR
  local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

  # If $EDITOR is not set, just toggle the sudo prefix on and off
  if [[ -z "$EDITOR" ]]; then
    case "$BUFFER" in
    sudo\ -e\ *) _sudo_replace_buffer "sudo -e" "" ;;
    sudo\ *) _sudo_replace_buffer "sudo" "" ;;
    *) LBUFFER="sudo $LBUFFER" ;;
    esac
    return
  fi

  # Get the command and check if it's an alias or matches the editor
  local cmd="${BUFFER%% *}"              # Extract first word (command)
  local realcmd="${aliases[$cmd]:-$cmd}" # Get alias or command if no alias exists
  local editorcmd="${EDITOR%% *}"        # Extract first word from EDITOR

  # Check if the real command matches the editor or an alias for the editor
  if [[ "$realcmd" == "$EDITOR" || "$realcmd" == "$editorcmd" || "$realcmd" == "${editorcmd:c}" ]]; then
    _sudo_replace_buffer "$cmd" "sudo -e"
    return
  fi

  # If it doesn't match, apply transformations for editor commands
  case "$BUFFER" in
  $editorcmd\ *) _sudo_replace_buffer "$editorcmd" "sudo -e" ;;
  \$EDITOR\ *) _sudo_replace_buffer '$EDITOR' "sudo -e" ;;
  sudo\ -e\ *) _sudo_replace_buffer "sudo -e" "$EDITOR" ;;
  sudo\ *) _sudo_replace_buffer "sudo" "" ;;
  *) LBUFFER="sudo $LBUFFER" ;;
  esac

  # Preserve leading whitespace and redisplay buffer
  LBUFFER="${WHITESPACE}${LBUFFER}"
  zle redisplay
}

function _vi_search_fix() {
  zle vi-cmd-mode
  zle .vi-history-search-backward
}

function toppy() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n 21
}

function cd() {
  builtin cd "$@" && command ls --group-directories-first --color=auto -F
}

function git-svn() {
  if [[ ! -z "$1" && ! -z "$2" ]]; then
    echo "Starting clone/copy ..."
    repo=$(echo $1 | sed 's/\/$\|.git$//')
    svn export "$repo/trunk/$2"
  else
    echo "Use: git-svn <repository> <subdirectory>"
  fi
}

# vim:ft=sh
