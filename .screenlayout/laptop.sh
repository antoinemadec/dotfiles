#!/bin/sh
xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1-2 --off --output DP-1-1 --off
xrandr --output eDP-1 --primary --mode 1366x768 --pos 0x0 --rotate normal
