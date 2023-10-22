include <ballscrew_mounts.scad>
include <fixed_bearings.scad>
include <sbr_bearing_blocks.scad>
include <nema23_mount.scad>


module leg_base(height, sbr_inter_space, thickness) {
    bf_depth = bf_depth(BF12);
	dsg_mount_C1 = ballscrew_mount_C1(DSG16HH);

	bk_hole_dist = bk_hole_P(BK12);
	bk_width = bk_width(BK12);
    bk_center = bk_ball_bearing_center(BK12);

	leg_offset_y = sbr_rail_rod_center_height(SBR16RAIL)+sbr_bearing_hole_dist(SBR16UU)+15;

	sbr_length = sbr_bearing_block_length(SBR16UU);
	sbr_screw_dia = sbr_bearing_screw_dia(SBR16UU);
	sbr_mount_C = sbr_bearing_mount_C(SBR16UU);
    sbr_mount_B = sbr_bearing_mount_B(SBR16UU);
	sbr_pos_z = bk_hole_P(BK12) + 30;
    sbr_x_hole_offset = (sbr_length - sbr_mount_C) / 2;

	dsg_length = ballscrew_mount_length(DSG16HH);
	dsg_mount_C2 = ballscrew_mount_C2(DSG16HH);
	dsg_mount_P = ballscrew_mount_P(DSG16HH);

    dsg_center_y = bk_width/2 + 15 - (bk_width-bk_hole_dist)/2;

	sbr1_min_x_hole = sbr_x_hole_offset;
    sbr2_min_x_hole = sbr_x_hole_offset + sbr_inter_space + sbr_length;
	sbr_min_y_hole = sbr_pos_z - sbr_mount_B/2 + 30;

	dsg_min_x_hole = dsg_length/2 + (dsg_length-dsg_mount_C2)/2;
	dsg_min_y_hole = dsg_center_y - dsg_mount_P/2;

    sbr16uu_dist = 2*sbr_length + sbr_inter_space;

	color([0, 0.5, 0.8, 0.5]) {
        translate([bf_depth, -leg_offset_y, 0]) rotate([90, 0, 0]) {
            linear_extrude(thickness) {
                difference() {
                    polygon(points=[[0, 0],
                                    [sbr16uu_dist, 0],
                                    [sbr16uu_dist, height-30],
                                    [sbr16uu_dist-30, height],
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
                    translate([dsg_mount_C1, dsg_min_y_hole, 0]) {
                        translate([0,            0,           0]) circle(d=sbr_screw_dia);
                        translate([dsg_mount_C2, 0,           0]) circle(d=sbr_screw_dia);
                        translate([0,            dsg_mount_P, 0]) circle(d=sbr_screw_dia);
                        translate([dsg_mount_C2, dsg_mount_P, 0]) circle(d=sbr_screw_dia);
                    }
                    translate([15, height-15]) {
                        translate([0,   0, 0]) circle(d=sbr_screw_dia);
                        translate([0, -30, 0]) circle(d=sbr_screw_dia);
                        translate([0, -sbr_pos_z, 0]) circle(d=sbr_screw_dia);
                        translate([0, -sbr_pos_z-30, 0]) circle(d=sbr_screw_dia);
                        translate([0, -sbr_pos_z-60, 0]) circle(d=sbr_screw_dia);
                        translate([15 + bk_center, -30 - bk_hole_dist/2, 0])
                            nema23_mounting_hole_2d(plinth_diam = 38.1, epsilon = 0.1);
                    }
                }
            }
        }
    }
}


module leg() {
    leg_base(350, 5, 8);
}
