#!/usr/bin/env bash

image="$1"

wallpaper_dir="$(dirname $0)"

w=$(identify -ping -format %w "$image")
h=$(identify -ping -format %h "$image")

sub_w="$((w/3))"
sub_h="$((h/2))"

# upper right corner
x="$((2*sub_w))"
y=0
avg_pixel_val="$(convert -extract ${sub_w}x${sub_h}+$x+$y $image -scale 1x1\! \
  -colorspace gray txt:- | tail -n1 | sed 's/^.... (\([^,]*\).*/\1/')"
echo $avg_pixel_val > $wallpaper_dir/avg_val_top_right.txt
