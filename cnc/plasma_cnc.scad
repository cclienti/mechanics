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
include <lib/sfu2005.scad>

use <../libraries/NopSCADlib/vitamins/rod.scad>


$show_threads = true;

slot_length = 1000;
rod_length = slot_length-50;
leg_height = 350;
cart_x_pos = 100;


module bearing_rod_block(bfxx, bkxx, sfu1605_length, cart_pos) {
	dsg_length = ballscrew_mount_length(DSG16HH);

	rotate([90, -90, 90])
		BFxx(BF12);
	sfu_offset_x = (bf_depth(bfxx) + bf_ball_bearing_width(bfxx)) / 2 - fixed_bearing_bf_ax;
	translate([sfu_offset_x, -bf_ball_bearing_center(bfxx), bf_width(bfxx)/2])
		sfu1605(sfu1605_length);
	translate([sfu1605_length - fixed_bearing_bk_offset + sfu_offset_x, 0, 0]) rotate([90, -90, 90])
		BKxx(BK12);
	translate([cart_pos, -bf_ball_bearing_center(BF12), bf_width(bfxx)/2]) {
		translate([0, 0, 0]) rotate([90, 0, 90]) leadnut(SFU1610);
		translate([-dsg_length, 0, 0]) rotate([90, 0, 0]) ballscrew_mount(DSG16HH);
	}

}

module cnc_axis(slot_length, rod_length, cart_pos, plate_thickness, sbr_inter_space=5) {
	rod_center_height = sbr_rail_rod_center_height(SBR16RAIL);
	bk_hole_dist = bk_hole_P(BK12);
	bk_width = bk_width(BK12);

	color("white") {
		translate([0, 15, -25]) cube([slot_length, plate_thickness, 160]);
	}

	color("gray") {
		rotate([90, 0, 90]) {
			translate([0, 15, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist+30, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist+60, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
		}
	}

	sbr_length = sbr_bearing_block_length(SBR16UU);
	sbr_pos_offset = sbr_length/2+sbr_inter_space/2;

	translate([0, -15, bk_hole_dist+60]) {
		rotate([90, 0, 0]) {
			sbr_rail(SBR16RAIL, slot_length);
			translate([-sbr_pos_offset + cart_pos, 0, rod_center_height]) {
				sbr_bearing_block(SBR16UU);
			}
			translate([sbr_pos_offset + cart_pos, 0, rod_center_height]) {
				sbr_bearing_block(SBR16UU);
			}
		}
	}

	translate([20, -15, 15 - (bk_width-bk_hole_dist)/2]) {
		bearing_rod_block(BF12, BK12, rod_length, cart_pos);
	}

}

module leg(height, thickness, sbr16uu_dist=100, sbr_inter_space=5) {
	bk_hole_dist = bk_hole_P(BK12);
	bk_width = bk_width(BK12);

	leg_offset_y = sbr_rail_rod_center_height(SBR16RAIL)+sbr_bearing_hole_dist(SBR16UU)+15;

	sbr_length = sbr_bearing_block_length(SBR16UU);
	sbr_pos_offset = sbr_length/2+sbr_inter_space/2;
	sbr_screw_dia = sbr_bearing_screw_dia(SBR16UU);
	sbr_mount_C = sbr_bearing_mount_C(SBR16UU);
	sbr_mount_B = sbr_bearing_mount_B(SBR16UU);
	sbr_pos_z = bk_hole_P(BK12) + 60;

	dsg_width = ballscrew_mount_width(DSG16HH);
	dsg_length = ballscrew_mount_length(DSG16HH);
	dsg_mount_C2 = ballscrew_mount_C2(DSG16HH);
	dsg_mount_P = ballscrew_mount_P(DSG16HH);

	center_x = (sbr16uu_dist)/2;

	dsg_center_y = bk_width/2 + 15 - (bk_width-bk_hole_dist)/2;

	sbr1_min_x_hole = center_x - sbr_inter_space/2 - sbr_length + (sbr_length-sbr_mount_C)/2;
	sbr2_min_x_hole = center_x + sbr_inter_space/2 + (sbr_length-sbr_mount_C)/2;
	sbr_min_y_hole = sbr_pos_z - sbr_mount_B/2;

	dsg_min_x_hole = center_x - dsg_length/2 + (dsg_length-dsg_mount_C2)/2;
	dsg_min_y_hole = dsg_center_y - dsg_mount_P/2;

	color("silver")
	translate([-sbr16uu_dist/2, -leg_offset_y, 0]) rotate([90, 0, 0]) {
		linear_extrude(thickness) {
			difference() {
				polygon(points=[[0, 0],
				                [sbr16uu_dist, 0],
				                [sbr16uu_dist, 150],
				                [50, height],
				                [0, height]],
				        convexity=10);
				translate([sbr1_min_x_hole, sbr_min_y_hole, 0]) {
					translate([0,           0,           0]) circle(d=sbr_screw_dia);
					translate([sbr_mount_C, 0,           0]) circle(d=sbr_screw_dia);
					translate([0,           sbr_mount_B, 0]) circle(d=sbr_screw_dia);
					translate([sbr_mount_C, sbr_mount_B, 0]) circle(d=sbr_screw_dia);
				}
				translate([sbr2_min_x_hole, sbr_min_y_hole, 0]) {
					translate([0,           0,           0]) circle(d=sbr_screw_dia);
					translate([sbr_mount_C, 0,           0]) circle(d=sbr_screw_dia);
					translate([0,           sbr_mount_B, 0]) circle(d=sbr_screw_dia);
					translate([sbr_mount_C, sbr_mount_B, 0]) circle(d=sbr_screw_dia);
				}
				translate([dsg_min_x_hole, dsg_min_y_hole, 0]) {
					translate([0,            0,           0]) circle(d=sbr_screw_dia);
					translate([dsg_mount_C2, 0,           0]) circle(d=sbr_screw_dia);
					translate([0,            dsg_mount_P, 0]) circle(d=sbr_screw_dia);
					translate([dsg_mount_C2, dsg_mount_P, 0]) circle(d=sbr_screw_dia);
				}
				translate([15, height-15]) {
					translate([0,   0, 0]) circle(d=sbr_screw_dia);
					translate([0, -30, 0]) circle(d=sbr_screw_dia);
					translate([0, -60, 0]) circle(d=sbr_screw_dia);
					translate([0, -sbr_pos_z, 0]) circle(d=sbr_screw_dia);
				}
			}
		}
	}
}


translate([cart_x_pos, 0, 0]) leg(leg_height, 8);

translate([cart_x_pos, slot_length+8, 0]) leg(leg_height, 8);
translate([0, slot_length-45-15-45-15, 0]) {
	mirror([0, 1, 0]) cnc_axis(slot_length, rod_length, cart_x_pos, 8);
}

translate([cart_x_pos-35, -60, leg_height-bk_hole_P(BK12)-90]) {
	rotate([0, 0, 90]) cnc_axis(slot_length, rod_length, cart_x_pos, 8);
}
cnc_axis(slot_length, rod_length, cart_x_pos, 8);
