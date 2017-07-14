#!/bin/bash

# user input is (<nb>:)<name>
#
# if workspace <nb>:<name> already exists:
#   jump into all workspaces mathing .*:<name>
# else:
#   if <nb> is defined:
#       if workspace number <nb> already exists:
#           rename workspace <nb>:<name>
#       else:
#           create workspace <nb>:<name>
#   else
#       create workspace <first_available_nb>:<name>

gen_workspaces()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"name":' | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

gen_workspaces_number()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"num":' | sed 's/.*"num"://' | sort -n
}

test_workspace_already_exist()
{
  (gen_workspaces | grep "$1") && return 0
  return 1
}

find_first_available_ws()
{
  for ((i=1; i<=10; i++))
  do
    available=1
    for n in $(gen_workspaces_number)
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

ws="$(gen_workspaces  | rofi -dmenu -p "workspace:")"

ws_nb=""
(echo "$ws" | grep -q ':') && ws_nb="$(echo "$ws" | cut -d ':' -f 1)"
ws_name="$(echo "$ws" | cut -d ':' -f 2)"

match_list="$(gen_workspaces | grep "\(:\|^\)$ws_name$" | sort -nr)"

if [ "$match_list" != "" ] && (test_workspace_already_exist "$ws")
then
  for w in $match_list
  do
    i3-msg "workspace $w"
  done
else
  if [ "$ws_nb" != "" ]
  then
    i3-msg "workspace number $ws_nb"
    i3-msg "rename workspace to $ws"
  elif [ "$ws" != "" ]
  then
    ws_nb="$(find_first_available_ws)"
    [ "$ws_nb" != "" ] && i3-msg "workspace \"$ws_nb:$ws_name\""
  fi
fi
