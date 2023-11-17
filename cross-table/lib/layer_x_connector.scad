include <../../cnc/lib/fixed_bearings.scad>
include <../../cnc/lib/ballscrew_mounts.scad>
include <../../cnc/lib/sbr_bearing_block.scad>
include <../../cnc/lib/sbr_bearing_blocks.scad>
include <../../cnc/lib/fixed_bearings.scad>
include <../../cnc/lib/sfu1605.scad>


module layer_x_connector(thickness=6) {
    width = 175;
    length = 300;

	BK_HOLE_DIST = bk_hole_P(BK12);

    BB_LENGTH = sbr_bearing_block_length(SBR16UU);
    BB_WIDTH = sbr_bearing_block_width(SBR16UU);
	BB_SCREW_DIA = sbr_bearing_screw_dia(SBR16UU);
	BB_MOUNT_C = sbr_bearing_mount_C(SBR16UU);
    BB_MOUNT_B = sbr_bearing_mount_B(SBR16UU);

	DSG_LENGTH = ballscrew_mount_length(DSG16HH);
	DSG_MOUNT_P = ballscrew_mount_P(DSG16HH);
    DSG_WIDTH = ballscrew_mount_width(DSG16HH);
	DSG_MOUNT_C2 = ballscrew_mount_C2(DSG16HH);

    color([0, 0.5, 0.8, 0.5]) {
        linear_extrude(thickness) {
            difference() {
                square([length, width]);
                union() {

                    // holes for e30x60 profiles
                    for (i = [0:5]) {
                        translate([length-12.5, width-15-i*30]) circle(d=6);
                        translate([12.5, width-15-i*30]) circle(d=6);
                    }

                    // holes for sbr16uu
                    sbr16uu_offset=(250-BB_LENGTH)/2;
                    for (j=[-1:2:1]) {
                        for (i=[0:2]) {
                            translate([(length-250)/2 + BB_LENGTH / 2, (width-125*j)/2]) {
                                translate([-BB_MOUNT_C/2 + i*sbr16uu_offset, -BB_MOUNT_B/2]) circle(d=BB_SCREW_DIA);
                                translate([ BB_MOUNT_C/2 + i*sbr16uu_offset, -BB_MOUNT_B/2]) circle(d=BB_SCREW_DIA);
                                translate([-BB_MOUNT_C/2 + i*sbr16uu_offset,  BB_MOUNT_B/2]) circle(d=BB_SCREW_DIA);
                                translate([ BB_MOUNT_C/2 + i*sbr16uu_offset,  BB_MOUNT_B/2]) circle(d=BB_SCREW_DIA);
                            }
                        }
                    }

                    //holes for dsg16hh
                    translate([length/2, width/2]) {
                        translate([-DSG_MOUNT_C2/2, -DSG_MOUNT_P/2]) circle(d=5);
                        translate([ DSG_MOUNT_C2/2, -DSG_MOUNT_P/2]) circle(d=5);
                        translate([-DSG_MOUNT_C2/2,  DSG_MOUNT_P/2]) circle(d=5);
                        translate([ DSG_MOUNT_C2/2,  DSG_MOUNT_P/2]) circle(d=5);
                    }

                }
            }
        }
    }
}
