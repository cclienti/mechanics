include <../../cnc/lib/ballscrew_mounts.scad>
include <../../cnc/lib/sbr_bearing_block.scad>
include <../../cnc/lib/sbr_bearing_blocks.scad>
include <../../cnc/lib/fixed_bearings.scad>
include <../../cnc/lib/sfu1605.scad>


module layer_y_to_x_base(width, length, sbr16uu_max_space=125, thickness=6) {
    BB_TYPE = SBR16UU;
    BB_LENGTH = sbr_bearing_block_length(BB_TYPE);
    BB_WIDTH = sbr_bearing_block_width(BB_TYPE);
	BB_SCREW_DIA = sbr_bearing_screw_dia(SBR16UU);
	BB_MOUNT_C = sbr_bearing_mount_C(SBR16UU);
    BB_MOUNT_B = sbr_bearing_mount_B(SBR16UU);

	DSG_LENGTH = ballscrew_mount_length(DSG16HH);
	DSG_MOUNT_P = ballscrew_mount_P(DSG16HH);
    DSG_WIDTH = ballscrew_mount_width(DSG16HH);
	DSG_MOUNT_C2 = ballscrew_mount_C2(DSG16HH);

    BK_DEPTH = bk_depth(BK12);
    BK_HOLE_DIST = bk_hole_P(BK12);
    BK_HOLE_C1 = bk_hole_C1(BK12);
    BK_HOLE_C2 = bk_hole_C2(BK12);

    SFU_LENGTH = 550;
    BF_WIDTH = bf_width(BF12);
    BF_DEPTH = bf_depth(BF12);
    BF_HOLE_DIST = bf_hole_P(BF12);
    BF_X_OFFSET = SFU_LENGTH+fixed_bearing_bf_ax+(BF_DEPTH/2);

    bb_x_offset = (BB_LENGTH-BB_MOUNT_C)/2;
    bb_y_offset = (BB_WIDTH-BB_MOUNT_B)/2;

    bk_x_offset = -2.5;

    color([0, 0.5, 0.8, 0.5]) {
        translate([-thickness, -width/2, 0])
            rotate([90, 0, 90]) {
            linear_extrude(thickness) {
                difference() {
                    square([width, length]);
                    union() {
                        // Holes for SBR16UU
                        for (i = [30 : 200 : 630]) {
                            translate([width/2, i]) {
                                translate([sbr16uu_max_space/2 - bb_x_offset, -BB_WIDTH/2+bb_y_offset]) {
                                    translate([0,           0])          circle(d=BB_SCREW_DIA);
                                    translate([0,           BB_MOUNT_B]) circle(d=BB_SCREW_DIA);
                                    translate([-BB_MOUNT_C, 0])          circle(d=BB_SCREW_DIA);
                                    translate([-BB_MOUNT_C, BB_MOUNT_B]) circle(d=BB_SCREW_DIA);
                                }
                                translate([-sbr16uu_max_space/2 + BB_LENGTH - bb_x_offset, -BB_WIDTH/2+bb_y_offset]) {
                                    translate([0,           0])          circle(d=BB_SCREW_DIA);
                                    translate([0,           BB_MOUNT_B]) circle(d=BB_SCREW_DIA);
                                    translate([-BB_MOUNT_C, 0])          circle(d=BB_SCREW_DIA);
                                    translate([-BB_MOUNT_C, BB_MOUNT_B]) circle(d=BB_SCREW_DIA);
                                }
                            }
                        }
                        // Holes for DSG16HH
                        translate([width/2-DSG_WIDTH+0.5,  length/2]) {
                            translate([DSG_WIDTH/2-(DSG_WIDTH-DSG_MOUNT_C2)/2, -DSG_LENGTH/2+(DSG_LENGTH-DSG_MOUNT_P)/2]) {
                                translate([0,            0])           circle(d=BB_SCREW_DIA);
                                translate([DSG_MOUNT_C2, 0])           circle(d=BB_SCREW_DIA);
                                translate([0,            DSG_MOUNT_P]) circle(d=BB_SCREW_DIA);
                                translate([DSG_MOUNT_C2, DSG_MOUNT_P]) circle(d=BB_SCREW_DIA);
                            }
                        }
                        // Holes for SBR16 rails
                        for (i = [0 : 4]) {
                            translate([width-10, length-5-75]) {
                                translate([  0, -i*150]) circle(d=5);
                                translate([-30, -i*150]) circle(d=5);
                            }
                            translate([10, length-5-75]) {
                                translate([ 0, -i*150]) circle(d=5);
                                translate([30, -i*150]) circle(d=5);
                            }
                        }
                        // Holes for BK12/HM12-57
                        translate([width/2+BK_HOLE_DIST/2, fixed_bearing_bk_offset+BK_DEPTH+bk_x_offset-BK_HOLE_C2]) {
                            translate([0,             0])              circle(d=5);
                            translate([0,             -BK_HOLE_C1])    circle(d=5);
                            translate([-BK_HOLE_DIST, 0])              circle(d=5);
                            translate([-BK_HOLE_DIST, -BK_HOLE_C1])    circle(d=5);
                            translate([0,             -BK_HOLE_C1-30]) circle(d=5); // for hm12-57
                            translate([-BK_HOLE_DIST, -BK_HOLE_C1-30]) circle(d=5); // for hm12-57
                        }
                        // Holes for BF12
                        translate([width/2+BF_HOLE_DIST/2, BF_X_OFFSET]) {
                            for (i=[-2 : 0.5 : 2]) translate([0, i])             circle(d=6);
                            for (i=[-2 : 0.5 : 2]) translate([-BF_HOLE_DIST, i]) circle(d=6);
                        }
                    }
                }
            }
        }
    }
}


module layer_y_to_x() {
    extra_width=50;
    width=125+extra_width;
    length=660;

    translate([0, width/2-extra_width/2, 0]) {
        rotate([0, 90, 0]) {
            layer_y_to_x_base(width, length);
        }
    }
}
