include <fixed_bearings.scad>
include <nema23_mount.scad>


module plate_base(thickness, sbr_screw_dia=6) {
    bk_hole_dist = bk_hole_P(BK12);
	sbr_pos_z = bk_hole_dist + 30;
    bk_center = bk_ball_bearing_center(BK12);

    plate_width1 = 20 + bk_height(BK12) + 30 + 90;
    plate_width2 = 20 + bk_height(BK12) + 30;
    plate_height1 = 60;
    plate_height2 = 60 + 90 + bk_hole_dist - 30;

    color([0, 0.5, 0.8, 0.5]) {
    translate([-plate_width2 + 15, 0, 0])
        linear_extrude(thickness) {
            difference() {
                polygon(points=[[0, 0],
                                [plate_width1, 0],
                                [plate_width1, plate_height1], //-10],
                                //[plate_width1-10, plate_height1],
                                [plate_width2, plate_height1],
                                [plate_width2, plate_height2],
                                /*[20,*/ [0, plate_height2],
                                //[0, plate_height2-20],
                                [0, plate_height2]
                                ]);
                translate([plate_width2-15,  15,           0]) circle(d=8);
                translate([plate_width2-15,  45,           0]) circle(d=8);
                translate([plate_width2-15,  sbr_pos_z+15, 0]) circle(d=8);
                translate([plate_width2-15,  sbr_pos_z+45, 0]) circle(d=8);
                translate([plate_width2-15,  sbr_pos_z+75, 0]) circle(d=8);
                translate([plate_width2-30-bk_center, 45 + bk_hole_dist/2])
                    nema23_mounting_hole_2d(plinth_diam = 38.1, epsilon = 0.1);
                translate([plate_width2+15, 15])  circle(d=sbr_screw_dia);
                translate([plate_width2+45, 15])  circle(d=sbr_screw_dia);
                translate([plate_width2+75, 15])  circle(d=sbr_screw_dia);
                translate([plate_width2+15, 45])  circle(d=sbr_screw_dia);
                translate([plate_width2+45, 45])  circle(d=sbr_screw_dia);
                translate([plate_width2+75, 45])  circle(d=sbr_screw_dia);

            }
        }
    }
}


module plate() {
    plate_base(8, 6);
}
