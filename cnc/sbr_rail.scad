include <../libraries/NopSCADlib/core.scad>
use <../libraries/NopSCADlib/vitamins/rod.scad>

function sbr_rail_width(type) = type[4];
function sbr_rail_rod_center_height(type) = type[2];


module sbr_rail(type, length=500) {
	DIA=type[1];
	H=sbr_rail_rod_center_height(type);
	E=type[3];
	W=sbr_rail_width(type);
	F=type[5];
	T=type[6];
	K=type[7];
	J=type[8];
	h1=type[9];
	theta=type[10];
	B=type[11];
	N=type[12];
	P=type[13];
	S1=type[14];
	S2=type[15];

	WJ2 = (W-J)/2;
	WB2 = (W-B)/2;

	x1 = h1 / (2*tan(theta/2));
	ra = J/h1;

	color(grey(90)) render() {
		translate([-length/2, -W/2, 0]) rotate([90, 0, 90]) {
			difference() {
				union() {
					linear_extrude(length) {
						union() {
							polygon(points=[[0, 0], [W, 0], [W, T], [W-WJ2, T], [W-WJ2, K], [WJ2, K], [WJ2, T], [0, T]],
							        convexity=10);
							translate([W/2, H-DIA/2 + x1, 0]) {
								polygon(points=[[0, 0], [ra*h1/2, -ra*x1], [-ra*h1/2, -ra*x1]],
								        convexity=10);
							}
						}
					}
					translate([W/2, H, 0]) rod(DIA, length, center=false);
				}

				for (i = [N : P : length]) {
					translate([WB2, T, i]) rotate([90, 0, 0]) cylinder(T*2, S1/2, S1/2);
					translate([W-WB2, T, i]) rotate([90, 0, 0]) cylinder(T*2, S1/2, S1/2);
				}
			}
		}
	}
}
