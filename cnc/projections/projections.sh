#!/bin/bash

openscad --hardwarnings -p params.json -P projection --autocenter --viewall  -o leg.dxf ./leg.scad
openscad --hardwarnings -p params.json -P projection --autocenter --viewall  -o plate.dxf ./plate.scad
