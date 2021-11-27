include <../libraries/NopSCADlib/core.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>
include <../libraries/NopSCADlib/vitamins/rails.scad>
include <../libraries/NopSCADlib/vitamins/leadnuts.scad>
include <../libraries/NopSCADlib/vitamins/bearing_blocks.scad>
use <../libraries/NopSCADlib/vitamins/rod.scad>
// include <../libraries/NopSCADlib/vitamins/ball_bearings.scad>
// ball_bearing(BB6201);

$show_threads = true;

translate([0, 75, 0]) {
	rail_assembly(HGH20CA_carriage, 1500, 50);
}

translate([0, -75, 0]) {
	rail_assembly(HGH20CA_carriage, 1500, 50);
}


translate([800, 0, NEMA23[1]/2]) {
	rotate([0, -90, 0]) {
		NEMA(NEMA23);
	}
}

translate([0, 0, NEMA23[1]/2]) {
	rotate([0, 90, 0]) {
		leadscrew(10, 1500, 16, 4);
	}
}

translate([0, 0, NEMA23[1]/2]) {
	rotate([0, 90, 180]) {
		leadnut(SFU1610);
	}
}


translate([0, -200, 0]) {
	rotate([-90,  0, 90]) {
		scs_bearing_block(SCS16UU);
	}
}
/*
linear_extrude(40) {
	circle(20);
	polygon(points=[[0,0],[100,0],[0,100],[10,10],[80,10],[10,80]], paths=[[0,1,2],[3,4,5]],convexity=10);
}
*/
