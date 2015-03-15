#!/bin/sh
# 2015 Sander Boom
# Toggle primary output via xrandr
#
# See: https://wiki.archlinux.org/index.php/xrandr

# connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
activeOutputs=$(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
activeOutputs=($activeOutputs) # Create stringarray
primaryOutput=$(xrandr | grep -E " connected primary ?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

setPrimary() {
  xrandr --output "$1" --primary
}

if [ -z "$primaryOutput" ]
  then
    # primaryOutput is empty, set to first in activeOutputs
    echo "No primary detected, setting primary to first possible output: ${activeOutputs[0]}"
    setPrimary "${activeOutputs[0]}"
  else
    # primaryOutput is set, needs to toggle
    echo "Current primary: $primaryOutput"
    for output in "${activeOutputs[@]}"
    do
      if [ "$primaryOutput" != "$output" ]
        then
          echo "Setting primary to: $output"
          setPrimary "$output"
      fi
    done
fi
