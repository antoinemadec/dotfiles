#!/usr/bin/env bash

set -e

WALLPAPER_DIR="$(dirname $0)"

image="$1"
startup="$2"
[ -f "$image" ] || image="$WALLPAPER_DIR/$image"
[ -f "$image" ] || exit 1


# execute in background
(
  # change wallpaper and term colorscheme
  wal -e -i $image --saturate 0.9
  # conky
  $WALLPAPER_DIR/get_average_val.sh $image
  if [[ "$startup" == 1 ]]; then
    pkill conky || true
    conky -c ~/.config/conky/process.lua &
    sleep .1
    conky -c ~/.config/conky/time.lua &
  else
    touch -m $HOME/.config/conky/process.lua
    touch -m $HOME/.config/conky/time.lua
  fi
) &
