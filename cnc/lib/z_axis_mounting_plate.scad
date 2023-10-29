include <ballscrew_mounts.scad>
include <fixed_bearings.scad>
include <sbr_bearing_blocks.scad>
include <sbr_rails.scad>

module z_axis_mounting_plate_base(y_offset=25, thickness=8, sbr_interspace=5, sbr_screw_dia=5) {
    sbr_length = sbr_bearing_block_length(SBR16UU);
    sbr_width =  sbr_bearing_block_width(SBR16UU);

    plate_height = 190;
    plate_width = 2 * sbr_length + sbr_interspace + 10;

    sbr_mount_C = sbr_bearing_mount_C(SBR16UU);
    sbr_mount_B = sbr_bearing_mount_B(SBR16UU);
    sbr_x_hole_offset = plate_width/2 - sbr_length - sbr_interspace/2 + (sbr_length - sbr_mount_C) / 2;

	sbr1_min_x_hole = sbr_x_hole_offset;
    sbr2_min_x_hole = sbr_x_hole_offset + sbr_interspace + sbr_length;
	sbr_min_y_hole = (sbr_bearing_block_width(SBR16UU) - sbr_mount_B)/2 + y_offset;

	dsg_length = ballscrew_mount_length(DSG16HH);
	dsg_mount_C2 = ballscrew_mount_C2(DSG16HH);
	dsg_mount_P = ballscrew_mount_P(DSG16HH);

    dsg_min_y_hole = y_offset + sbr_width / 2 + bk_hole_P(BK12)/2 + 45 - dsg_mount_P/2;


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
    z_axis_mounting_plate_base(25, 8, 5, 5);
}
