#!/bin/bash

./convert.py -i leg.scad -n leg#LinearExtrude -o leg.dxf
./convert.py -i plate.scad -n plate#LinearExtrude -o plate.dxf

# openscad --hardwarnings -p params.json -P projection --autocenter --viewall  -o leg.dxf ./leg.scad
# openscad --hardwarnings -p params.json -P projection --autocenter --viewall  -o plate.dxf ./plate.scad
