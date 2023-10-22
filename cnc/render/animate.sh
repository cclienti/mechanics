#!/bin/bash


function render() {
    echo "Rendering $1"
    cat <<EOF > animated/animate_$1.json
{
    "parameterSets": {
        "step": {
	        "cart_x_pos": "$1"
        }
    }
}
EOF

    openscad -q ../plasma_cnc.scad \
             -p animated/animate_$1.json \
             -P step \
             --imgsize=1920,800 \
             --camera=493.58,405.02,54.45,78.10,0.00,39.80,1806.97 \
             -o animated/frame_$(printf "%05d" $1).png

    rm -rf animated/animate_$1.json
}


mkdir -p animated

render $1
