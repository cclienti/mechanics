include <../../../cnc/lib/fixed_bearings.scad>

module drill_press_plate(hole_diam=6, thickness=6) {
    width = 260;
    length = 330;

	BK_HOLE_DIST = bk_hole_P(BK12);

    color([0, 0.5, 0.8, 0.5]) {
        linear_extrude(thickness) {
            difference() {
                square([width, length]);
                union() {
                    for (i=[0:3]) {
                        translate([15, 15 + i * 30]) circle(d=hole_diam);
                        translate([45, 15 + i * 30]) circle(d=hole_diam);
                        translate([width-15, 15 + i * 30]) circle(d=hole_diam);
                        translate([width-45, 15 + i * 30]) circle(d=hole_diam);
                        translate([15, length-15 - i * 30]) circle(d=hole_diam);
                        translate([45, length-15 - i * 30]) circle(d=hole_diam);
                        translate([width-15, length-15 - i * 30]) circle(d=hole_diam);
                        translate([width-45, length-15 - i * 30]) circle(d=hole_diam);
                        translate([width/2-BK_HOLE_DIST/2, 15 + i * 30])  circle(d=hole_diam);
                        translate([width/2+BK_HOLE_DIST/2, 15 + i * 30])  circle(d=hole_diam);
                        translate([width/2-BK_HOLE_DIST/2, length-15 - i * 30])  circle(d=hole_diam);
                        translate([width/2+BK_HOLE_DIST/2, length-15 - i * 30])  circle(d=hole_diam);
                    }
                    translate([width/2, length/2+15]) circle(d=47);
                }
            }
        }
    }
}
