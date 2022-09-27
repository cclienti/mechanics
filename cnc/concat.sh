#!/bin/bash


parallel -j 28 ./animate.sh ::: {80..800}
ffmpeg -framerate 30 -pattern_type glob -i 'animated/*.png' -c:v libx264 -pix_fmt yuv420p plasma.mp4
