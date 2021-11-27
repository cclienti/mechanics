include <../libraries/NopSCADlib/vitamins/linear_bearings.scad>
include <../libraries/NopSCADlib/vitamins/circlips.scad>
//                   0      1     2     3     4     5     6     7      8     9    10    11    12        13          14
//                          h     E     W     L     F     T    h1  theta     B     C     S     l   bearing        clip
SBR12UU   = ["SBR12UU",  17.0, 20.0, 40.0, 39.0, 27.6,  8.0,  8.5,    80, 28.0, 26.0,  5.0, 10.0,  LM12UU, circlip_21i];
SBR16UU   = ["SBR16UU",  20.0, 22.5, 45.0, 45.0, 33.0,  9.0, 10.0,    80, 32.0, 30.0,  5.0, 10.0,  LM16UU, circlip_28i];

sbr_bearing_blocks = [SBR12UU, SBR16UU];

use <sbr_bearing_block.scad>
