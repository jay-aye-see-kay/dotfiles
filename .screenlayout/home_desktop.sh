#!/bin/sh
xrandr --output HDMI-2 --off --output HDMI-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output eDP-1 --mode 1920x1080 --pos 264x1440 --rotate normal --output DP-2 --off
killall -USR1 compton
