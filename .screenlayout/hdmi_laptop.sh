#!/bin/sh
xrandr --output eDP-1 --off --output HDMI-1 --off --output DP-1-2 --off --output DP-1-1 --off
xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --mode 1366x768 --same-as HDMI-1 --scale-from 1920x1080
