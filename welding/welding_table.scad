module regular_45deg_trapezoid(l, h, thickness) {
	difference() {
		cube(size=[l, h, thickness], center=true);
		translate([l/2, h/2, 0]) {
			rotate([0, 0, 45]) {
				cube(size=[h*sqrt(2), h*sqrt(2), thickness*2], center=true);
			}
		}
		translate([-l/2, h/2, 0]) {
			rotate([0, 0, 45]) {
				cube(size=[h*sqrt(2), h*sqrt(2), thickness*2], center=true);
			}
		}
	}
}

module notches(l, h, thickness, num_hole, hole_distance) {
	size = num_hole * hole_distance;
	for(i=[1: num_hole - 1]) {
		translate([-size/2 + i * hole_distance, 0, 0]) {
			regular_45deg_trapezoid(l, h, thickness);
		}
	}
}

module welding_table(thickness, num_hole_x, num_hole_y, hole_distance_x, hole_distance_y, hole_diam, laser_width) {
	size_x = num_hole_x * hole_distance_x;
	size_y = num_hole_y * hole_distance_y;

	echo(size_x = size_x);
	echo(size_y = size_y);

	notche_l = hole_distance_y/2;
	notche_h = 2*thickness;

	difference() {
		cube(size=[size_x, size_y, thickness], center=true);
		for(i=[1: num_hole_x]) {
			for(j=[1: num_hole_y]) {
				translate([-size_x/2 + i * hole_distance_x - hole_distance_x / 2,
				           -size_y/2 + j * hole_distance_y - hole_distance_y / 2, 0]) {
					cylinder(h=thickness * 2, d=hole_diam, center=true);
				}
			}
		}
		translate([(-size_x-thickness)/2, 0, 0]) {
			rotate([0, 0, 90]) {
				notches(notche_l+laser_width*2*sqrt(2), notche_h, thickness*2, num_hole_y+2, hole_distance_y);
			}
		}
		translate([0, (-size_y-thickness)/2, 0]) {
			rotate([0, 0, -180]) {
				notches(notche_l+laser_width*2*sqrt(2), notche_h, thickness*2, num_hole_x+2, hole_distance_x);
			}
		}
		translate([size_x/2, 0, 0]) {
			cube(size=[laser_width, size_y*2, thickness*2], center=true);
		}
		translate([0, size_y/2, 0]) {
			cube(size=[size_x*2, laser_width, thickness*2], center=true);
		}
	}

	translate([(size_x-thickness-laser_width)/2, 0, 0]) {
		rotate([0, 0, 90]) {
			notches(notche_l, notche_h, thickness, num_hole_y, hole_distance_y);
		}
	}

	translate([0, (size_y-thickness-laser_width)/2, 0]) {
		rotate([0, 0, -180]) {
			notches(notche_l, notche_h, thickness, num_hole_x, hole_distance_x);
		}
	}
}

laser_width=0.2;
thickness=5;
projection() welding_table(thickness, 10, 20, 50, 50, 16, laser_width);
/* translate([500, 0, 0]) { */
/* 	color("red") */
/* 		welding_table(thickness, 10, 20, 50, 50, 16, laser_width); */
/* } */
/* translate([0, 1000, 0]) { */
/* 	color("green") */
/* 		welding_table(thickness, 10, 20, 50, 50, 16, laser_width); */
/* } */
/* translate([500, 1000, 0]) { */
/* 	color("blue") */
/* 		welding_table(thickness, 10, 20, 50, 50, 16, laser_width); */
/* } */
/* translate([1300, -250, 0]) { */
/* 	rotate([0, 0, -90]) { */
/* 		color("yellow") { */
/* 			welding_table(thickness, 10, 20, 50, 50, 16, laser_width); */
/* 		} */
/* 	} */
/* } */
