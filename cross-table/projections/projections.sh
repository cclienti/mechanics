#!/bin/bash

function convert {
    mkdir -p dxf
    rm -f dxf/${1}.dxf
    ./convert.py -i ./scad/${1}.scad -n ${1}#LinearExtrude -o dxf/${1}.dxf
}

convert layer_y_to_x
