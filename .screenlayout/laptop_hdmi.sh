#!/bin/sh

# force this script to fail when HDMI is not connect,
# xrandr would return OK otherwise
xrandr | grep -q 'HDMI-1 disconnected' && exit 1

xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1-2 --off --output DP-1-1 --off
xrandr --output eDP-1 --primary --mode 1366x768 --pos 0x0 --rotate normal --output HDMI-1 --auto --same-as eDP-1 --scale-from 1366x768
