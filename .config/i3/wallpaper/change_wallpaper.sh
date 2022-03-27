#!/usr/bin/env bash

set -e

WALLPAPER_DIR="$(dirname $0)"

image="$1"
startup="$2"
[ -f "$image" ] || image="$WALLPAPER_DIR/$image"
[ -f "$image" ] || exit 1

# execute in background
(feh --bg-scale $image &> /dev/null) &
