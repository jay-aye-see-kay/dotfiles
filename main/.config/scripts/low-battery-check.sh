#!/usr/bin/env bash

while true; do
   BATT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
   BATT_PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
   if { [ "$BATT_STATUS" = 'Discharging' ] && [ "$BATT_PERCENT" -le 50 ]; }
   then
      notify-send "Low battery: $BATT_PERCENT%"
   fi
   sleep 120s
done &
