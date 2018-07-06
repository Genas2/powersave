#!/bin/bash

MEM_SLEEP_TIME=300
MEM_SLEEP_TIME=15
MEM_TIMEOUT=30

DISK_SLEEP_TIME=600
DISK_TIMEOUT=30

LOGGER="logger -t powersave"
$LOGGER "Power save: $@"

function battery_state {
    echo $(upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $NF}')
}

if [[ -n "$1" && "$1" == "true" ]]; then
    sleep $MEM_TIMEOUT

    while [ $(battery_state) = "discharging" ]
    do
        $LOGGER "Battery state: $(battery_state)"

        battery_charge=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $NF}')

        $LOGGER "Battery charge: $battery_charge"

        if [ "${battery_charge:0:-1}" -gt 20 ]; then
            mode="mem"
            sleep_time=$MEM_SLEEP_TIME
            timeout=$MEM_TIMEOUT
        else
            mode="disk"
            sleep_time=$DISK_SLEEP_TIME
            timeout=$DISK_TIMEOUT
        fi

        $LOGGER "Forcing $mode sleep for $sleep_time seconds"
        rtcwake -m $mode -s $sleep_time
        sleep $timeout
    done
fi

