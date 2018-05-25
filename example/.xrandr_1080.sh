#!/bin/sh

xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode Virtual1 1920x1080
echo Xft.dpi: 96 | xrdb -merge
xrandr --output Virtual1 --mode 1920x1080

i3-msg restart
