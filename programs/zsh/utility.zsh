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

rebase() {
  if [ "$1" = "--abort" ]; then
    git rebase --abort
    return
  fi
  if [[ "$1" =~ ^[0-9]+$ ]] && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git rebase -i HEAD~"$1"
  fi
}

extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# function mp3() {
#     yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 \
#         --embed-metadata --embed-thumbnail --convert-thumb jpg \
#         --ppa "ThumbnailsConvertor+FFmpeg_o:-c:v mjpeg -vf crop=\"'min(iw,ih)':'min(iw,ih)'\"" \
#         -o "%(title)s - %(artist)s.%(ext)s" \
#         "$1"
# }
# yt_search_play() {
#     # Check if required dependencies are installed
#     for cmd in fzf mpv yt-dlp jq; do
#         if ! command -v "$cmd" &> /dev/null; then
#             echo "Error: $cmd is not installed. Please install it first."
#             return 1
#         fi
#     done
#
#     # Function to format duration
#     format_duration() {
#         local duration=$1
#         local hours=$((duration/3600))
#         local minutes=$(((duration%3600)/60))
#         local seconds=$((duration%60))
#
#         if [ $hours -gt 0 ]; then
#             printf "%02d:%02d:%02d" $hours $minutes $seconds
#         else
#             printf "%02d:%02d" $minutes $seconds
#         fi
#     }
#
#     # Get search query from user if not provided as argument
#     local query="$*"
#     if [ -z "$query" ]; then
#         read -p "Enter search term: " query
#     fi
#
#     # Perform YouTube search and format results
#     selected=$(yt-dlp ytsearch20:"$query" \
#         --get-id --get-title --get-duration \
#         --no-playlist \
#         --print '%(title)s|||%(duration)s|||%(id)s' 2>/dev/null \
#         | while IFS='|||' read -r title duration id; do
#             duration_formatted=$(format_duration "$duration")
#             printf "%-70.70s  [%s]  https://youtube.com/watch?v=%s\n" \
#                 "$title" "$duration_formatted" "$id"
#         done | fzf --ansi \
#             --preview 'yt-dlp --get-description {-1}' \
#             --preview-window 'right:40%:wrap' \
#             --bind 'ctrl-y:execute(echo {-1} | xclip -selection clipboard)' \
#             --header 'TAB/Shift-TAB: Move preview window | Ctrl-Y: Copy URL | Enter: Play video')
#
#     # Check if a video was selected
#     if [ -n "$selected" ]; then
#         # Extract video URL and play with mpv
#         url=$(echo "$selected" | awk '{print $NF}')
#         echo "Playing: $url"
#         mpv "$url"
#     else
#         echo "No video selected"
#     fi
# }

# vim:ft=sh
