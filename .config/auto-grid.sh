#!/bin/bash
# Get list of windows in current workspace
windows=$(i3-msg -t get_tree | jq '[.nodes[].nodes[] | select(.name=="__i3") | .nodes[] | select(.layout != "dockarea") | .nodes[].nodes[] | select(.window != null) | .window]')

# If 4 windows, arrange in 2x2 grid
count=$(echo $windows | jq 'length')
if [ $count -eq 4 ]; then
    i3-msg 'layout splith; split v; layout splith'
fi
