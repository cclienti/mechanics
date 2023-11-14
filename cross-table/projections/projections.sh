#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

function convert {
    mkdir -p ${SCRIPTPATH}/dxf
    rm -f ${SCRIPTPATH}/dxf/${1}.dxf
    ${SCRIPTPATH}/convert.py -i ${SCRIPTPATH}/scad/${1}.scad -n ${1}#LinearExtrude -o ${SCRIPTPATH}/dxf/${1}.dxf
}

convert layer_y_to_x
convert profile_connector_E30x120
convert profile_connector_E60x120
convert drill_press_plate
convert layer_x_connector
