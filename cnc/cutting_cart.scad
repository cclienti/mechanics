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

rail_length = 750;
shaft_length = 700;
rod_center_height = sbr_rail_rod_center_height(SBR16RAIL);
fixed_bearing_adapter_height = 10;
slot_type = E3060; // Use two E3060 to simulate a 30x120
slot_profile_width = 120;
slot_profile_height = 30;


color("gray") {
	translate([-4, slot_profile_width/2, slot_profile_height/2])
	rotate([0, 90, 0]) {
		translate([0, -slot_profile_width/4, 0]) extrusion(E3060, rail_length, cornerHole = true);
		translate([0, slot_profile_width/4, 0]) extrusion(E3060, rail_length, cornerHole = true);
	}
}

translate([-sbr_bearing_block_length(SBR16RAIL)/2, slot_profile_width/4, slot_profile_height]) {
	rotate([0, 0, 0]) {
		sbr_rail(SBR16RAIL, shaft_length);
		translate([-25, 0, rod_center_height]) {
			sbr_bearing_block(SBR16UU);
		}
		translate([25, 0, rod_center_height]) {
			sbr_bearing_block(SBR16UU);
		}
	}
}

translate([0, 3*slot_profile_width/4,
           slot_profile_height+rod_center_height+fixed_bearing_adapter_height]) {
	rotate([0, 90, 0]) {
		sfu1605(shaft_length);
	}
	translate([-ballscrew_mount_length(DSG16HH)/2-sbr_bearing_block_length(SBR16RAIL)/2, 0, 0]) {
		rotate([0, 90, 180]) {
			leadnut(SFU1610);
		}
		ballscrew_mount(DSG16HH);
	}
}

translate([-shaft_length/2+(bf_depth(BF12)-bf_ball_bearing_width(BF12))/2+fixed_bearing_bf_ax,
           bk_width(BK12)/2 + 3*slot_profile_width/4,
           slot_profile_height + fixed_bearing_adapter_height]) {
	rotate([90, 0, 270]) {
		BFxx(BF12);
	}
	translate([20, 0, -fixed_bearing_adapter_height]) {
		rotate([180, 180, 0])
		fixed_bearing_bf_adapter(60, bf_width(BF12), fixed_bearing_adapter_height,
		                         bf_depth(BF12)/2, bf_hole_P(BF12), slot_profile_width/4, bk_hole_diam(BK12));
	}
}

translate([shaft_length/2 - fixed_bearing_bk_offset,
           -bk_width(BK12)/2 + 3*slot_profile_width/4,
           slot_profile_height + fixed_bearing_adapter_height]) {
	rotate([90, 0, 90]) {
		BKxx(BK12);
	}
	translate([-17.5, 0, -fixed_bearing_adapter_height]) {
		fixed_bearing_bk_adapter(60, 60, fixed_bearing_adapter_height,
		                         bk_hole_C1(BK12), bk_hole_P(BK12),
		                         slot_profile_width/4, bk_hole_diam(BK12));
	}
}


translate([shaft_length/2-fixed_bearing_bk_ax1,
           3*slot_profile_width/4,
           slot_profile_height + rod_center_height + fixed_bearing_adapter_height]) {
	rotate([0, 90, 0]) {
		cylinder(30, 12.5, 12.5);
	}
}

translate([shaft_length/2+25,
           3*slot_profile_width/4,
           slot_profile_height + rod_center_height + fixed_bearing_adapter_height]) {
	rotate([0, -90, 0]) {
		NEMA(NEMA23);
	}
}

translate([shaft_length/2+21, 0, 0]) rotate([90, 0, 90]) nema23_mount(4, fixed_bearing_adapter_height+rod_center_height);

color("lightgray")
translate([-70, -80, 85]) torch_adapter(5, 5);
