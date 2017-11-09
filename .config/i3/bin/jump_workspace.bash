#!/bin/bash

# I- user input is <idx>:<name>
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
# II- user input is r(a) <new_name>
#   if ra:
#     rename all workspaces matching .*:<focused_ws_name> in .*:<new_name>
#   if r:
#     rename <focused_ws> in <focused_ws_idx>:<new_name>
#
#
# III- user input is <name>( <nb>)
#
#   create <nb> (default=1) workspaces called <first_available_idx>:<name>


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
  for ((i=1; i<=10; i++))
  do
    available=1
    for n in $(get_workspace_indexes)
    do
      [ "$n" = "$i" ] && available=0
    done
    if ((available))
    then
      echo $i
      return 0
    fi
  done
}

ws="$(get_workspaces  | rofi -dmenu -p "workspace:")"

if (echo "$ws" | grep -q ':')
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
elif (echo "$ws" | grep -q '^ra\? ')
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
    i3-msg "rename workspace to $ws_idx:$ws_new_name"
  done
elif [ "$ws" != "" ]
then
  ws_name="$(echo "$ws" | cut -d ' ' -f 1)"
  ws_nb=1
  (echo "$ws" | grep -q ' ') && ws_nb="$(echo "$ws" | cut -d ' ' -f 2)"
  for ((i=0; i<ws_nb; i++))
  do
    ws_idx="$(find_first_available_ws)"
    [ "$ws_idx" != "" ] && i3-msg "workspace \"$ws_idx:$ws_name\""
  done
else
  echo "ERROR in $0"
  exit 1
fi
