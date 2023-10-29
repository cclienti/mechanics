#!/bin/bash

function convert {
    mkdir -p dxf
    rm -f dxf/${1}.dxf
    ./convert.py -i ./scad/${1}.scad -n ${1}#LinearExtrude -o dxf/${1}.dxf
}

convert leg
convert plate
convert z_axis_mounting_plate
