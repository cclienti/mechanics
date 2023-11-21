#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

function convert {
    mkdir -p ${SCRIPTPATH}/dxf
    rm -f ${SCRIPTPATH}/dxf/${1}.dxf
    ${SCRIPTPATH}/convert.py -i ${SCRIPTPATH}/scad/${1}.scad -n ${1}#difference -o ${SCRIPTPATH}/dxf/${1}.dxf
}

convert leg
convert plate
convert z_axis_mounting_plate
convert torche_adapter
