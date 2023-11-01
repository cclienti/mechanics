#!/bin/bash

function chaser() {
    python - << EOF
max_pos=50
if (${1} // max_pos) & 1 == 1:
    print(max_pos - ${1} % max_pos)
else:
    print(${1} % max_pos)
EOF
}

function render() {
    echo "Rendering $1"
    cat <<EOF > animated/animate_$1.json
{
    "parameterSets": {
        "step": {
	        "cart_x_pos": "$1",
	        "cart_z_pos": "$2"
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
render $1 $(chaser $1)
