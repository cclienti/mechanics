include <../libraries/NopSCADlib/core.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>
include <../libraries/NopSCADlib/vitamins/rails.scad>
include <../libraries/NopSCADlib/vitamins/leadnuts.scad>
include <../libraries/NopSCADlib/vitamins/bearing_blocks.scad>
include <../libraries/NopSCADlib/vitamins/extrusions.scad>

include <lib/sbr_rails.scad>
include <lib/sbr_bearing_blocks.scad>
include <lib/ballscrew_mounts.scad>
include <lib/sfu1605.scad>
include <lib/fixed_bearings.scad>
include <lib/fixed_bearing_adapter.scad>
include <lib/nema23_mount.scad>
include <lib/torch_adapter.scad>

use <../libraries/NopSCADlib/vitamins/rod.scad>

$show_threads = true;

shaft_length = 700;
rod_center_height = sbr_rail_rod_center_height(SBR16RAIL);



translate([-sbr_bearing_block_length(SBR16RAIL)/2, 0, 0]) {
	rotate([90, 0, 0]) {
		sbr_rail(SBR16RAIL, shaft_length);
		translate([-30, 0, rod_center_height]) {
			sbr_bearing_block(SBR16UU);
		}
		translate([30, 0, rod_center_height]) {
			sbr_bearing_block(SBR16UU);
		}
	}
}
