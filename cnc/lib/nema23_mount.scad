include <../../libraries/NopSCADlib/utils/rounded_cylinder.scad>


module oblong_circle(diam, length) {
	rotate([0, 0, 0]) rounded_corner(diam/2, length/2, diam/2);
	rotate([180, 0, 0]) rounded_corner(diam/2, length/2, diam/2);
	rotate([0, 0, 180]) rounded_corner(diam/2, length/2, diam/2);
	rotate([0, 180, 0]) rounded_corner(diam/2, length/2, diam/2);
}


module nema23_mounting_hole_2d(plinth_diam=38.1, epsilon=0.1) {
    hole_dist = 47.14/2;
    translate([-hole_dist, -hole_dist, 0]) circle(d=5+epsilon);
    translate([-hole_dist, +hole_dist, 0]) circle(d=5+epsilon);
    translate([+hole_dist, +hole_dist, 0]) circle(d=5+epsilon);
    translate([+hole_dist, -hole_dist, 0]) circle(d=5+epsilon);
    circle(d=plinth_diam + epsilon);
}


module nema23_mount(adapter_thickness, bk_shaft_center) {
	linear_extrude(adapter_thickness) {
		difference() {
			polygon(points=[[0, 0], [120, 0], [120, 100],
			                [0, 100]]);
			// Slot profile hole
			translate([15, 15, 0]) circle(3);
			translate([45, 15, 0]) circle(3);
			translate([75, 15, 0]) circle(3);
			translate([105, 15, 0]) circle(3);

			// Bracket holes
			bracket_hole_center_y = 12.5;
			oblong_length = 25;
			oblong_diam = 6;
			translate([15, 30+oblong_length/2-oblong_diam/2, 0]) oblong_circle(oblong_diam, oblong_length);
			translate([45, 30+oblong_length/2-oblong_diam/2, 0]) oblong_circle(oblong_diam, oblong_length);

			// Nema 23 holes
			shaft_pos_y = 30 + bk_shaft_center;
			nema_23_hole_dist = 47.14;
			nema_23_hole_diam = 38.1;

			translate([90, shaft_pos_y, 0]) circle(nema_23_hole_diam/2+0.5);
			translate([90-nema_23_hole_dist/2, shaft_pos_y-nema_23_hole_dist/2, 0]) circle(2.5);
			translate([90+nema_23_hole_dist/2, shaft_pos_y-nema_23_hole_dist/2, 0]) circle(2.5);
			translate([90-nema_23_hole_dist/2, shaft_pos_y+nema_23_hole_dist/2, 0]) circle(2.5);
			translate([90+nema_23_hole_dist/2, shaft_pos_y+nema_23_hole_dist/2, 0]) circle(2.5);

		}
	}
}
