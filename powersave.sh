#!/bin/bash

SLEEP_TIME=300

LOGGER="logger -t powersave"
$LOGGER "Power save: $@"

if [[ -n "$1" && "$1" == "true" ]]; then
    battery_charge=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $NF}')

    $LOGGER "Battery charge: $battery_charge"

    if [ "${battery_charge:0:-1}" -gt 20 ]; then
        mode="mem"
    else
        mode="disk"
    fi

    $LOGGER "Forcing $mode sleep for $SLEEP_TIME seconds"

    rtcwake -m $mode -s $SLEEP_TIME
fi

