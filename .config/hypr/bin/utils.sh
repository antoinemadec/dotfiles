# Hyprland bash utils

get_workspaces_names() {
  hyprctl workspaces | grep "^workspace" | grep -v '(special' | sed -e 's/.*(//' -e 's/).*//'
}

get_workspaces_ids() {
  hyprctl workspaces | grep "^workspace" | grep -v '(special' | sed -e 's/.*ID //' -e 's/ .*//'
}

get_current_workspace_id() {
  hyprctl activeworkspace -j | jq -r '.id'
}

special_workspace_exists() {
  hyprctl workspaces | grep -q special:"$1"
}

current_window_is_not_in_group() {
  hyprctl activewindow | grep -q 'grouped: 0$'
}

current_window_is_group_left() {
  win_id="$(hyprctl activewindow | grep ^Window | cut -f 2 -d ' ')"
  hyprctl activewindow | grep -q "grouped: $win_id"
}

current_window_is_group_right() {
  win_id="$(hyprctl activewindow | grep ^Window | cut -f 2 -d ' ')"
  hyprctl activewindow | grep -q "grouped: .*$win_id\$"
}

current_workspace_has_no_window() {
  hyprctl activeworkspace | grep -q 'windows: 0$'
}

toggle_special_workspace() {
  local cmd="$1"
  local special_ws_name="$2"

  if special_workspace_exists "$special_ws_name"; then
    hyprctl dispatch togglespecialworkspace "$special_ws_name"
  else
    hyprctl dispatch exec "[workspace special:$special_ws_name; float]" "$cmd"
  fi
}
