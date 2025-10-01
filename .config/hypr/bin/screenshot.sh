#!/usr/bin/env bash

# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Screenshots scripts

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"


notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${dir}/${file}"

active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
active_window_file="Screenshot_${time}_${active_window_class}.png"
active_window_path="${dir}/${active_window_file}"

# notify and view screenshot
notify_view() {
  if [[ "$1" == "active" ]]; then
    if [[ -e "${active_window_path}" ]]; then
      ${notify_cmd_shot} " Screenshot of '${active_window_class}' Saved."
    else
      ${notify_cmd_shot} " Screenshot of '${active_window_class}' not Saved"
    fi
  elif [[ "$1" == "swappy" ]]; then
    ${notify_cmd_shot} " Screenshot Captured."
  else
    local check_file="$dir/$file"
    if [[ -e "$check_file" ]]; then
      ${notify_cmd_shot} " Screenshot Saved."
    else
      ${notify_cmd_shot} " Screenshot NOT Saved."
    fi
  fi
}


# take shots
shotnow() {
  cd ${dir} && grim - | tee "$file" | wl-copy
  sleep 2
  notify_view
}

shotwin() {
  w_pos=$(hyprctl activewindow | grep 'at:' | cut -d':' -f2 | tr -d ' ' | tail -n1)
  w_size=$(hyprctl activewindow | grep 'size:' | cut -d':' -f2 | tr -d ' ' | tail -n1 | sed s/,/x/g)
  cd ${dir} && grim -g "$w_pos $w_size" - | tee "$file" | wl-copy
  notify_view
}

shotarea() {
  tmpfile=$(mktemp)
  grim -g "$(slurp)" - >"$tmpfile"
  if [[ -s "$tmpfile" ]]; then
    wl-copy <"$tmpfile"
    mv "$tmpfile" "$dir/$file"
  fi
  rm "$tmpfile"
  notify_view
}

shotswappy() {
  tmpfile=$(mktemp)
  grim -g "$(slurp)" - >"$tmpfile" && notify_view "swappy"
  swappy -f - <"$tmpfile"
  rm "$tmpfile"
}


if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

screenshot_choices=()
screenshot_choices+=("🔳 Area")
screenshot_choices+=("📝 Area With Edition")
screenshot_choices+=("🪟 Window")
screenshot_choices+=("🖥️ Fullscreen")

screenshot_mode=$(printf "%s\n" "${screenshot_choices[@]}" | rofi -dmenu)

if [[ "$screenshot_mode" == "" ]]; then
  exit 0
fi

case "$screenshot_mode" in
  *Fullscreen)
    shotnow
    ;;
  *Window)
    shotwin
    ;;
  *Area)
    shotarea
    ;;
  *Edition)
    shotswappy
    ;;
  *)
    echo "Unknown option: $screenshot_mode"
    exit 1
    ;;
esac
