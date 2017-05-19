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
#       create workspace <next_available_odd_nb>:<name>
#       create workspace <next_available_even_nb>:<name>

gen_workspaces()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"name":' | sed 's/"name":"\(.*\)"/\1/g' | sort -n
}

gen_workspaces_number()
{
  i3-msg -t get_workspaces | tr ',' '\n' | grep '"num":' | sed 's/.*"num"://' | sort -n
}

find_consecutive_available_odd_even_pair()
{
  for ((i=1; i<=10; i++))
  do
    if ((i%2 == 1))
    then
      even_available=0
      odd_available=1
      for n in $(gen_workspaces_number)
      do
        [ "$n" = "$i" ] && odd_available=0
      done
    else
      even_available=1
      for n in $(gen_workspaces_number)
      do
        [ "$n" = "$i" ] && even_available=0
      done
    fi
    if (((odd_available == 1) && (even_available == 1)))
    then
      echo $((i-1))
      return 0
    fi
  done
}

ws="$(gen_workspaces  | rofi -dmenu -p "workspace:")"

ws_nb=""
(echo "$ws" | grep -q ':') && ws_nb="$(echo "$ws" | cut -d ':' -f 1)"
ws_name="$(echo "$ws" | cut -d ':' -f 2)"

match_list="$(gen_workspaces | grep "\(:\|^\)$ws_name$" | sort -nr)"

if [ "$match_list" != "" ]
then
  for ws in $match_list
  do
    i3-msg "workspace $ws"
  done
else
  if [ "$ws_nb" != "" ]
  then
    number_already_exist=0
    i3-msg "workspace number $ws_nb"
    i3-msg "rename workspace to $ws"
  elif [ "$ws" != "" ]
  then
    ws_nb="$(find_consecutive_available_odd_even_pair)"
    [ "$ws_nb" != "" ] && i3-msg "workspace \"$((ws_nb+1)):$ws_name\"; workspace \"$ws_nb:$ws_name\""
  fi
fi
