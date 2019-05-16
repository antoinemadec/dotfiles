#!/bin/bash
set -e

screen_nb="$(xrandr | grep ' connected ' | wc -l)"

input="$1"
focused_ws=$(i3-msg -t get_workspaces                   \
              | jq '.[] | select(.focused==true).num'   \
              | cut -d"\"" -f2)

# TODO: make it more elegant and generic
if ((screen_nb == 1))
then
  ws0=$focused_ws
  if [ "$input" = 0 ] && [ $ws0 -ge 2 ]
  then
    ((ws0-=1))
  elif [ "$input" = 1 ] && [ $ws0 -le 9 ]
  then
    ((ws0+=1))
  fi
  i3-msg "workspace number $ws0"
else
  ws0=$(((focused_ws-1)/2*2 + 1))
  ws1=$((ws0+1))
  if [ "$input" = 0 ] && [ $ws0 -ge 3 ]
  then
    ((ws0-=2))
    ((ws1-=2))
  elif [ "$input" = 1 ] && [ $ws0 -le 7 ]
  then
    ((ws0+=2))
    ((ws1+=2))
  fi
  i3-msg "workspace number $ws1; workspace number $ws0"
fi
