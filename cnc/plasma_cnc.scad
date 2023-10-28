include <../libraries/NopSCADlib/core.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>
include <../libraries/NopSCADlib/vitamins/rails.scad>
include <../libraries/NopSCADlib/vitamins/leadnuts.scad>
include <../libraries/NopSCADlib/vitamins/bearing_blocks.scad>
include <../libraries/NopSCADlib/vitamins/extrusions.scad>

include <lib/sbr_rails.scad>
include <lib/sbr_bearing_blocks.scad>
include <lib/sfu1605.scad>
include <lib/fixed_bearings.scad>
include <lib/fixed_bearing_adapter.scad>
include <lib/torch_adapter.scad>
include <lib/sfu2005.scad>

include <lib/metal_support.scad>
include <lib/plate.scad>
include <lib/leg.scad>
include <lib/torche.scad>
include <lib/z_axis.scad>

use <../libraries/NopSCADlib/vitamins/rod.scad>


//$show_threads = true;

// Profile ALU: https://www.systeal.com/fr/profiles-serie-30-type-b/1731-profile-aluminium-30x90-fente-8-mm.html
// Profile ALU: https://www.systeal.com/fr/profiles-serie-30-type-b/921-profile-aluminium-30x60-fente-8-mm.html


rod_length = 950;
nema_coupler_length = 30;
slot_length = rod_length + 15; //nema_coupler_length - 15;
sbr_offset = 25;
leg_height = 350;
cart_x_pos = 100; //30 - 800;
sbr_inter_space = 5;


module bearing_rod_block(sfu1605_length, cart_pos, sbr_inter_space=5, center_nuts=false) {
	dsg_length = ballscrew_mount_length(DSG16HH);
    bf_depth = bf_depth(BF12);
	sbr_length = sbr_bearing_block_length(SBR16UU);

	rotate([90, -90, 90]) BFxx(BF12);

	sfu_offset_x = (bf_depth(BF12) + bf_ball_bearing_width(BF12)) / 2 - fixed_bearing_bf_ax;
	translate([sfu_offset_x, -bf_ball_bearing_center(BF12), bf_width(BF12)/2]) sfu1605(sfu1605_length);
	translate([sfu1605_length - fixed_bearing_bk_offset + sfu_offset_x, 0, 0]) rotate([90, -90, 90]) BKxx(BK12);

    bf_offset = bf_depth + (center_nuts ? sbr_length + (sbr_inter_space - dsg_length)/2 : 0);
    echo(bf_offset=bf_offset);

	translate([cart_pos, -bf_ball_bearing_center(BF12), bf_width(BF12)/2]) {
		translate([dsg_length + bf_offset, 0, 0]) rotate([90, 0, 90]) leadnut(SFU1610);
		translate([bf_offset, 0, 0]) rotate([90, 0, 0]) ballscrew_mount(DSG16HH);
	}
}

module cnc_axis(slot_length, rod_length, cart_pos, sbr_inter_space=5, center_nuts=false) {
	dsg_length = ballscrew_mount_length(DSG16HH);
	rod_center_height = sbr_rail_rod_center_height(SBR16RAIL);
	bk_hole_dist = bk_hole_P(BK12);
	bk_width = bk_width(BK12);
    bf_depth = bf_depth(BF12);

	color("gray") {
		rotate([90, 0, 90]) {
			translate([0, 0, slot_length/2]) extrusion(E3060, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist+30, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
			translate([0, 15+bk_hole_dist+60, slot_length/2]) extrusion(E3030, slot_length, cornerHole = true);
		}
	}

	sbr_length = sbr_bearing_block_length(SBR16UU);
	sbr_pos_offset = (sbr_length + sbr_inter_space) / 2;

	translate([0, -15, bk_hole_dist+60]) {
		rotate([90, 0, 0]) {
			translate([8, 0, 0]) sbr_rail(SBR16RAIL, rod_length);
			translate([bf_depth, 0, rod_center_height]) {
				translate([sbr_length/2 + cart_pos, 0, 0]) sbr_bearing_block(SBR16UU);
				translate([sbr_length/2+sbr_length+sbr_inter_space + cart_pos, 0, 0]) sbr_bearing_block(SBR16UU);
			}
		}
	}

	translate([0, -15, 15 - (bk_width-bk_hole_dist)/2]) {
		bearing_rod_block(rod_length, cart_pos, sbr_inter_space, center_nuts);
	}

}

module z_axis_mounting_plate_base(y_offset=25, thickness=8, sbr_length, sbr_interspace=5, sbr_screw_dia=5) {
    sbr_length = sbr_bearing_block_length(SBR16UU);
    sbr_width =  sbr_bearing_block_width(SBR16UU);
    sbr_mount_C = sbr_bearing_mount_C(SBR16UU);
    sbr_mount_B = sbr_bearing_mount_B(SBR16UU);
    sbr_x_hole_offset = (sbr_length - sbr_mount_C) / 2;
	sbr_pos_z = bk_hole_P(BK12) + 30;
	sbr1_min_x_hole = sbr_x_hole_offset;
    sbr2_min_x_hole = sbr_x_hole_offset + sbr_inter_space + sbr_length;
	sbr_min_y_hole = (sbr_bearing_block_width(SBR16UU) - sbr_mount_B)/2 + y_offset;

	dsg_length = ballscrew_mount_length(DSG16HH);
	dsg_mount_C2 = ballscrew_mount_C2(DSG16HH);
	dsg_mount_P = ballscrew_mount_P(DSG16HH);

    dsg_min_y_hole = y_offset + sbr_width / 2 + bk_hole_P(BK12)/2 + 45 - dsg_mount_P/2;

    plate_height = 190;
    plate_width = 2 * sbr_length + sbr_interspace;

    color([0, 0.5, 0.8, 0.5]) {
        translate([-thickness, -plate_width/2, 0])
            rotate([90, 0, 90]) {
            linear_extrude(thickness) {
                difference() {
                    polygon(points=[[0, 0],
                                    [plate_width, 0],
                                    [plate_width, plate_height],
                                    [0, plate_height]]);
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
                    translate([plate_width/2 - dsg_mount_C2/2, dsg_min_y_hole, 0]) {
                        translate([0,            0,           0]) circle(d=sbr_screw_dia);
                        translate([dsg_mount_C2, 0,           0]) circle(d=sbr_screw_dia);
                        translate([0,            dsg_mount_P, 0]) circle(d=sbr_screw_dia);
                        translate([dsg_mount_C2, dsg_mount_P, 0]) circle(d=sbr_screw_dia);
                    }
                    translate([plate_width/2, y_offset/2]) {
                        translate([-30, 0]) circle(d=5);
                        translate([-10, 0]) circle(d=5);
                        translate([ 10, 0]) circle(d=5);
                        translate([ 30, 0]) circle(d=5);
                    }
                    translate([plate_width/2, plate_height - y_offset/2]) {
                        translate([-30, 0]) circle(d=5);
                        translate([-10, 0]) circle(d=5);
                        translate([ 10, 0]) circle(d=5);
                        translate([ 30, 0]) circle(d=5);
                    }
                }
            }
        }
    }
}

module z_axis_mounting_plate() {
    sbr_length = sbr_bearing_block_length(SBR16UU);
    z_axis_mounting_plate_base(25, 8, sbr_length, 5);
}


module torche_translate(cart_pos, slot_length, leg_height, sbr_inter_space=5, mounting_plate_width=8) {
    plate_offset = 25;
    sbr_pos_z = bk_hole_P(BK12) + 30;
    sbr_offset = sbr_rail_rod_center_height(SBR16RAIL) + sbr_bearing_hole_dist(SBR16UU);
    sbr_length = sbr_bearing_block_length(SBR16UU);
    x_offset = sbr_offset + 30 + bf_depth(BF12);
    y_offset = sbr_offset + 35 + sbr_length + sbr_inter_space/2;
    translate([cart_pos + x_offset + mounting_plate_width,
               slot_length - cart_pos - y_offset,
               leg_height - bk_hole_P(BK12) - 90 - sbr_bearing_block_width(SBR16UU)/2 - plate_offset]) {
        z_axis_mounting_plate();
    }
    translate([cart_pos + x_offset + mounting_plate_width,
               slot_length - cart_pos - y_offset,
               leg_height-183.5]) {
        rotate([0, 90, 0]) z_axis(20);
        //translate([35/2 + 56, 0, 0]) torche_AT_70();
    }

}


cnc_axis(slot_length, rod_length, cart_x_pos, sbr_inter_space, false);
translate([cart_x_pos, 0, 0]) leg();

translate([cart_x_pos+bf_depth(BF12) + 15, slot_length-60, leg_height-30]) {
    rotate([180, 0, -90]) cnc_axis(slot_length, rod_length, cart_x_pos, 5, true);
}

translate([cart_x_pos, slot_length+8, 0]) leg();
translate([0, slot_length-45-15-45-15, 0]) {
	mirror([0, 1, 0]) cnc_axis(slot_length, rod_length, cart_x_pos, 5, false);
}

translate([-8, 0, -30]) rotate([90, 0, 90]) plate();
translate([slot_length, 0, -30]) rotate([90, 0, 90]) plate();
translate([slot_length+8, slot_length-45-15-45-15, -30]) rotate([90, 0, -90]) plate();
translate([0, slot_length-45-15-45-15, -30]) rotate([90, 0, -90]) plate();

translate([slot_length-15, slot_length/2-60, 0])
rotate([0, 0, 90]) rotate([90, 0, 90]) extrusion(E3060, slot_length-150, cornerHole = true);

translate([15, slot_length/2-60, 0])
rotate([0, 0, 90]) rotate([90, 0, 90]) extrusion(E3060, slot_length-150, cornerHole = true);

translate([slot_length/4, slot_length/2-60, 0])
rotate([0, 0, 90]) rotate([90, 0, 90]) extrusion(E3060, slot_length-150, cornerHole = true);

translate([slot_length/2, slot_length/2-60, 0])
rotate([0, 0, 90]) rotate([90, 0, 90]) extrusion(E3060, slot_length-150, cornerHole = true);

translate([3*slot_length/4, slot_length/2-60, 0])
rotate([0, 0, 90]) rotate([90, 0, 90]) extrusion(E3060, slot_length-150, cornerHole = true);

translate([0, 40, 30]) metal_support(slot_length, slot_length-210, 40, 50, 2);

torche_translate(cart_x_pos, slot_length, leg_height);
