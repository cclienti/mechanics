include <../libraries/NopSCADlib/core.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>
include <../libraries/NopSCADlib/vitamins/rails.scad>
include <../libraries/NopSCADlib/vitamins/leadnuts.scad>
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
