include <../../libraries/NopSCADlib/core.scad>
include <../../libraries/NopSCADlib/vitamins/ball_bearings.scad>

function bk_depth(type) = type[2];
function bk_width(type) = type[8];
function bk_hole_C1(type) = type[6];
function bk_hole_P(type) = type[15];
function bk_hole_diam(type) = type[17];
function bk_ball_bearing_center(type) = type[11];
function bk_ball_bearing_width(type) = type[20];
function bk_rod_offset(type) = type[5];

function bf_depth(type) = type[2];
function bf_width(type) = type[3];
function bf_hole_P(type) = type[10];
function bf_ball_bearing_center(type) = type[6];
function bf_ball_bearing_width(type) = type[15];

function ek_depth(type) = type[2];
function ek_width(type) = type[6];
function ek_hole_P(type) = type[12];
function ek_hole_diam(type) = type[13];

function ef_depth(type) = type[2];
function ef_width(type) = type[3];
function ef_hole_P(type) = type[9];


module BKColar(depth, outer_diam, thickness) {
	color("darkslategray") {
		difference() {
			cylinder(h=depth, d=outer_diam + thickness*2, $fn=100);
			cylinder(h=depth, r=outer_diam/2, $fn=100);
		}
	}
}

module vertical_hole(H1, X, Y, Z) {
	rotate_extrude(convexity=10) {
		polygon(points=[[0, -1], [X/2, -1], [X/2, H1-Z],
		                [Y/2, H1-Z], [Y/2, H1+1], [0, H1+1]],
		        convexity=10);
	}
}

module BKxx(type) {
	BKxx_base(type);
}

module BFxx(type) {
	BFxx_base(type);
}

module BKxx_base(type) {
	d1 = type[1];
	L = bk_depth(type);
	L1 = type[3];
	L2 = type[4];
	L3 = bk_rod_offset(type);
	C1 = bk_hole_C1(type);
	C2 = type[7];
	B = bk_width(type);
	H = type[9];
	b = type[10];
	h = bk_ball_bearing_center(type);
	B1 = type[12];
	H1 = type[13];
	E = type[14];
	P = bk_hole_P(type);
	d2 = type[16];
	X = bk_hole_diam(type);
	Y = type[18];
	Z = type[19];
	bbw = bk_ball_bearing_width(type);
	bbd = type[21];

	Z6000 = ["6000Z", d1, bbd, bbw, "silver", 1.7, 2.4];

	delta = H - B1 + B1/2 - h;

	color("DarkSlateGray")  {
		translate([(B-B1)/2, H-B1-delta, L]) {
			linear_extrude(L1) {
				difference() {
					polygon(points=[[0,0], [0, B1], [B1, B1], [B1, 0]],
							  convexity=10);
					translate([B1/2, B1/2, 0])	{
						circle(bbd/2);
					}
				}
			}
		}

		render() difference () {
			linear_extrude(L) {
				difference() {
					polygon(points=[[0, 0],
										 [B, 0],
										 [B, H1],
										 [B-(B-B1)/2, H1],
										 [B-(B-B1)/2, H],
										 [(B-B1)/2, H],
										 [(B-B1)/2, H1],
										 [0, H1]],
							  convexity=10);
					translate([B/2, h, 0]) {
						circle(bbd/2);
					}
					translate([(B-P)/2, (H1-E)/2, 0]) {
						circle(d2/2);
					}
					translate([B-(B-P)/2, (H1-E)/2, 0]) {
						circle(d2/2);
					}
					translate([(B-P)/2, H1-(H1-E)/2, 0]) {
						circle(d2/2);
					}
					translate([B-(B-P)/2, H1-(H1-E)/2, 0]) {
						circle(d2/2);
					}
				}
			}

			translate([(B-P)/2, 0, C2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
			translate([B-(B-P)/2, 0, C2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
			translate([(B-P)/2, 0, L-C2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
			translate([B-(B-P)/2, 0, L-C2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
		}
	}
	translate([B/2, h, bbw/2 + L3]) ball_bearing(Z6000);
	translate([B/2, h, bbw/2 + bbw + L3]) ball_bearing(Z6000);


	colar1_depth = L3;
	colar2_depth = (L+L1) - (L3 + 2 * bbw);
	colar_thickness = 1.5;

	translate([B/2, h, bbw/2 + L3]) ball_bearing(Z6000);
	translate([B/2, h, bbw/2 + bbw + L3]) ball_bearing(Z6000);
	color("darkslategray") {
		translate([B/2, h, 0]) BKColar(colar1_depth, d1, colar_thickness);
		translate([B/2, h, 2*bbw + L3]) BKColar(colar2_depth, d1, colar_thickness);
	}
}


module BFxx_base(type) {
	d1 = type[1];
	L = bf_depth(type);
	B = bf_width(type);
	H = type[4];
	b = type[5];
	h = bf_ball_bearing_center(type);
	B1 = type[7];
	H1 = type[8];
	E = type[9];
	P = bf_hole_P(type);
	d2 = type[11];
	X = type[12];
	Y = type[13];
	Z = type[14];
	bbw = bf_ball_bearing_width(type);
	bbd = type[16];

	Bw = (B-B1)/2;
	Bz = (B-P)/2;
	Ey = (H1-E)/2;

	chamfer = 1;

	Z6000 = ["6000Z", d1, bbd, bbw, "silver", 1.7, 2.4];

	color("DarkSlateGray")  {
		difference() {
			linear_extrude(L) {
				difference() {
					polygon(points=[[0, 0], [B, 0],
					                [B, H1-chamfer], [B-chamfer, H1],
					                [B-Bw, H1], [B-Bw, H-chamfer],
					                [B-Bw-chamfer, H], [Bw+chamfer, H],
					                [Bw, H-chamfer], [Bw, H1],
					                [chamfer, H1], [0, H1-chamfer]],
					        convexity=10);
					translate([B/2, h, 0]) {
						circle(bbd/2);
					}
				}
			}
			translate([Bz, 0, L/2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
			translate([B-Bz, 0, L/2]) {
				rotate([-90, 0, 0]) {
					vertical_hole(H1, X, Y, Z);
				}
			}
			translate([Bz, Ey, -1]) {
				cylinder(L+2, d2/2, d2/2);
			}
			translate([B-Bz, Ey, -1]) {
				cylinder(L+2, d2/2, d2/2);
			}
			translate([Bz, H1-Ey, -1]) {
				cylinder(L+2, d2/2, d2/2);
			}
			translate([B-Bz, H1-Ey, -1]) {
				cylinder(L+2, d2/2, d2/2);
			}
		}
	}

	translate([B/2, h, L/2]) ball_bearing(Z6000);

}

module EKxx(type) {
	color("DarkSlateGray") render() EKxx_base(type);
}

module EFxx(type) {
	EFxx_base(type);
}

module EKxx_base(type) {
	d1 = type[1];
	L = ek_depth(type);
	L1 = type[3];
	L2 = type[4];
	L3 = type[5];
	B = ek_width(type);
	H = type[7];
	b = type[8];
	h = type[9];
	B1 = type[10];
	H1 = type[11];
	P = ek_hole_P(type);
	X = ek_hole_diam(type);

	translate([(B-B1)/2, h - B1/2, L]) {
		linear_extrude(L1) {
			difference() {
				polygon(points=[[0, 0], [0, B1], [B1, B1], [B1, 0]],
				        convexity=10);
				translate([B1/2, B1/2, 0])	{
					circle(d1/2);
				}
			}
		}
	}

	difference () {
		linear_extrude(L) {
			difference() {
				polygon(points=[[0, 0],
				                [B, 0],
				                [B, H1],
				                [B-(B-B1)/2, H1],
				                [B-(B-B1)/2, H],
				                [(B-B1)/2, H],
				                [(B-B1)/2, H1],
				                [0, H1]],
				        convexity=10);

				translate([B/2, h, 0]) {
					circle(d1/2);
				}
			}
		}

		translate([(B-P)/2, 0, L/2]) {
			rotate([-90, 0, 0]) {
				linear_extrude(H1) circle(X/2);
			}
		}
		translate([B-(B-P)/2, 0, L/2]) {
			rotate([-90, 0, 0]) {
				linear_extrude(H1) circle(X/2);
			}
		}
	}

}


module EFxx_base(type) {
	d1 = type[1];
	L = ef_depth(type);
	B = ef_width(type);
	H = type[4];
	b = type[5];
	h = type[6];
	B1 = type[7];
	H1 = type[8];
	P = ef_hole_P(type);
	X = type[10];

	Bw = (B-B1)/2;
	Bz = (B-P)/2;

	chamfer = 1;

	bbd = 32;
	bbw = 9;
	Z6000 = ["7000Z", d1, bbd, bbw, "silver", 2.4, 3.7];


	color("DarkSlateGray") render() {
		difference() {
			linear_extrude(L) {
				difference() {
					polygon(points=[[0, 0], [B, 0],
					                [B, H1-chamfer], [B-chamfer, H1],
					                [B-Bw, H1], [B-Bw, H-chamfer],
					                [B-Bw-chamfer, H], [Bw+chamfer, H],
					                [Bw, H-chamfer], [Bw, H1],
					                [chamfer, H1], [0, H1-chamfer]],
					        convexity=10);
					translate([B/2, h, 0]) {
						circle(bbd/2);
					}
				}
			}
			translate([Bz, 0, L/2]) {
				rotate([-90, 0, 0]) {
					linear_extrude(H1) circle(X/2);
				}
			}
			translate([B-Bz, 0, L/2]) {
				rotate([-90, 0, 0]) {
					linear_extrude(H1) circle(X/2);
				}
			}
		}
	}

	translate([B/2, h, L/2]) ball_bearing(Z6000);

}
