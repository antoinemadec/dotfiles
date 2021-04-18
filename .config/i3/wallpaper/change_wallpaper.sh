#!/usr/bin/env bash

set -e

WALLPAPER_DIR="$(dirname $0)"

image="$1"
startup="$2"
[ -f "$image" ] || image="$WALLPAPER_DIR/$image"
[ -f "$image" ] || exit 1

[ -f ~/.pywal.sh ] && source ~/.pywal.sh

# execute in background
(
if [[ "$PYWAL_ENABLED" == 1 ]]; then
  # change wallpaper and term colorscheme
  wal -e -i $image --saturate 0.9
else
  feh --bg-scale $image &> /dev/null
  mkdir -p ~/.cache/wal
  echo '' > ~/.cache/wal/colors-rofi-light.rasi
fi
) &
