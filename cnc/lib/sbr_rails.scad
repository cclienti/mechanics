//                   0       1      2     3     4     5     6     7     8     9    10     11    12     13    14    15
//                         DIA      H     E     W     F     T     K     J    h1  theta     B     N      P    S1    S2
SBR12RAIL = ["SBR12RAIL", 12.0, 20.46, 17.0, 34.0, 15.0,  4.5,  9.8, 15.0,  6.0,  80.0, 25.0, 50.0, 100.0,  4.5,  4.0];
SBR16RAIL = ["SBR16RAIL", 16.0, 25.00, 20.0, 40.0, 17.8,  5.0, 11.7, 18.5,  8.0,  80.0, 30.0, 25.0, 150.0,  5.5,  5.0];
SBR20RAIL = ["SBR20RAIL", 20.0, 27.00, 22.5, 45.0, 17.7,  5.0, 10.0, 19.0,  8.0,  50.0, 30.0, 25.0, 150.0,  5.5,  6.0];

sbr_rails = [SBR12RAIL, SBR16RAIL, SBR20RAIL];

use <sbr_rail.scad>
