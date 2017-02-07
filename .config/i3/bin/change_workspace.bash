#!/bin/bash
set -e

# this script assumes we are always using dual screen

input="$1"
focused_ws=$(i3-msg -t get_workspaces                   \
              | jq '.[] | select(.focused==true).name'  \
              | cut -d"\"" -f2)
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

i3-msg "workspace $ws1; workspace $ws0"
