#! /bin/bash

set -e

pidfile="/tmp/swayidle.pid"

if [[ $1 == "kill" ]]; then
    # if kill passed as arg, end process (will exit if no pidfile)
    pid=$(cat $pidfile)
    kill $pid
    rm $pidfile

elif [ ! -f $pidfile ]; then
    # if no pid file, start swaylock and make pidfile
    swayidle -w \
        timeout 300 'swaylock -f' \
        timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaylock -f' &
    echo $! > $pidfile

fi
