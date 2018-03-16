#!/bin/sh

# xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
# xrandr --addmode Virtual1 1920x1080

xrandr --newmode "3840x2160"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
xrandr --addmode Virtual1 3840x2160
echo Xft.dpi: 178 | xrdb -merge
xrandr --output Virtual1 --mode 3840x2160
i3-msg restart
