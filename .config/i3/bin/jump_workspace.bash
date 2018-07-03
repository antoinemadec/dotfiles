#!/bin/bash

# I- user input is <name>( <nb>)
#
#   create <nb> (default=1) workspaces called <first_available_idx>:<name>
#
#
# II- user input is <idx>:<name>
#
#   if workspace <idx>:<name> already exists:
#     jump into all workspaces mathing .*:<name>
#   else:
#     if workspace number <idx> already exists:
#       rename workspace <idx>:<name>
#     else:
#       create workspace <idx>:<name>
#
#
# III- user input is r(a) (<idx>:)<new_name>
#
#   if ra:
#     rename all workspaces matching .*:<focused_ws_name> in .*:<new_name>
#   if r:
#     if <idx> provided:
#       rename <focused_ws> in <idx>:<new_name>
#     else:
#       rename <focused_ws> in <focused_ws_idx>:<new_name>
#
#
# IV- user input is m <idx>
#
#   move <focused_ws> in <idx>:<focused_ws_name>


get_workspaces()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"name":' | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

get_workspace_indexes()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"num":' | sed 's/.*"num"://' | sort -n
}

get_focused_workspace()
{
  i3-msg -t get_workspaces                    \
    | jq '.[] | select(.focused==true).name'  \
    | cut -d"\"" -f2
}

workspace_already_exist()
{
  (get_workspaces | grep "$1") && return 0
  return 1
}

find_first_available_ws()
{
  ws_nb=$1
  cnt=0
  ws_in_use="$(get_workspace_indexes)"
  for ((i=1; i<=10; i++))
  do
    available=1
    for n in $ws_in_use
    do
      [ "$n" = "$i" ] && available=0
    done
    if ((available))
    then
      ((cnt++))
      if ((cnt == ws_nb))
      then
        echo $((i+1-ws_nb))
        return 0
      fi
    else
      cnt=0
    fi
  done
}

ws="$(get_workspaces  | rofi -dmenu -p "workspace")"
if (echo "$ws" | grep -q '^ra\? ')
then
  focused_ws="$(get_focused_workspace)"
  focused_ws_name="$(echo "$focused_ws" | cut -d ':' -f 2)"
  ws_new_name="$(echo "$ws" | cut -d ' ' -f 2)"
  if (echo "$ws" | grep -q '^ra ')
  then
    match_list="$(get_workspaces | grep ":$focused_ws_name$" | sort -nr)"
  else
    match_list="$focused_ws"
  fi
  for w in $match_list
  do
    ws_idx="$(echo $w | cut -d ':' -f 1)"
    i3-msg "workspace number $ws_idx"
    if [[ "$ws_new_name" =~ ':' ]]
    then
      i3-msg "rename workspace to $ws_new_name"
    else
      i3-msg "rename workspace to $ws_idx:$ws_new_name"
    fi
  done
elif (echo "$ws" | grep -q '^m ')
then
  focused_ws="$(get_focused_workspace)"
  focused_ws_name="$(echo "$focused_ws" | cut -d ':' -f 2)"
  ws_idx="$(echo "$ws"  | cut -d ' ' -f 2)"
  i3-msg "rename workspace to $ws_idx:$focused_ws_name"
elif (echo "$ws" | grep -q ':')
then
  ws_idx="$(echo "$ws"  | cut -d ':' -f 1)"
  ws_name="$(echo "$ws" | cut -d ':' -f 2)"
  match_list="$(get_workspaces | grep ":$ws_name$" | sort -nr)"
  echo "$match_list"
  if [ "$match_list" != "" ] && workspace_already_exist $ws
  then
    for w in $match_list
    do
      i3-msg "workspace $w"
    done
  else
    i3-msg "workspace number $ws_idx"
    i3-msg "rename workspace to $ws"
  fi
elif [ "$ws" != "" ]
then
  ws_name="$(echo "$ws" | cut -d ' ' -f 1)"
  ws_nb=1
  (echo "$ws" | grep -q ' ') && ws_nb="$(echo "$ws" | cut -d ' ' -f 2)"
  ws_base_idx="$(find_first_available_ws $ws_nb)"
  if [ "$ws_base_idx" != "" ]
  then
    for ((i=0; i<ws_nb; i++))
    do
      ws_idx=$((ws_base_idx + i))
      i3-msg "workspace \"$ws_idx:$ws_name\""
    done
  fi
else
  echo "ERROR in $0"
  exit 1
fi
