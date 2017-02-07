#!/bin/bash
set -e

# this script assumes we are always using dual screen

input="$1"
cur_dir="$(dirname $0)"
file="current_workspace.txt"
cur_workspace=1
if [ -f "$file" ]
then
  cur_workspace=$(cat $file)
fi
ws0=$((cur_workspace))
ws1=$((cur_workspace+1))

if [ "$input" = 0 ]
then
  # left
  if [ $cur_workspace -ge 3 ]
  then
    ws0=$((cur_workspace-2))
    ws1=$((cur_workspace-1))
  fi
else
  # right
  if [ $cur_workspace -le 7 ]
  then
    ws0=$((cur_workspace+2))
    ws1=$((cur_workspace+3))
  fi
fi

i3-msg "workspace $ws1; workspace $ws0"
echo $ws0 > $file
