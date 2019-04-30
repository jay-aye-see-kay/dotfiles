#!/usr/bin/env bash
tmpbg="/tmp/screen.png"
scrot "$tmpbg"

convert -scale 10% -blur 0x2.5 -brightness-contrast -10x-10 -resize 1000% "$tmpbg" "$tmpbg"

i3lock -i "$tmpbg"; rm "$tmpbg"

