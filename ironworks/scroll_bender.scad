module quadrant(outer_radius, thickness, rounded=true) {
	difference() {
		if (rounded) {
			cylinder(thickness, outer_radius, outer_radius, center=true);
		}
		else {
			rotate([0, 0, 45]) {
				cube(size=[outer_radius*2/sqrt(2), outer_radius*2/sqrt(2), thickness], center=true);
			}
		}
		translate([outer_radius + 1, 0, 0]) {
			cube(size=[(outer_radius + 1) * 2, outer_radius * 4, thickness + 2], center=true);
		}
		translate([0, -outer_radius-1, 0]) {
			cube(size=[outer_radius * 4, (outer_radius + 1) * 2, thickness + 2], center=true);
		}
	}
}

module quadrant2(outer_radius, width1, width2, thickness, rounded=true) {
	// See explanations in docs/quadrant.svg

	l1 = outer_radius - width1;
	l2 = outer_radius - width2;
	hyp = sqrt(l1*l1 + l2*l2);

	xA = -l1;
	yA = 0;

	xC = l2;
	yC = l2 - l1;

	center_x = (xA + xC) / 2;
	center_y = (yA + yC) / 2;
	alpha = acos(l1/hyp);

	difference() {
		if (rounded) {
			cylinder(thickness, outer_radius, outer_radius, center=true);
		}
		else {
			rotate([0, 0, 45]) {
				cube(size=[outer_radius*2/sqrt(2), outer_radius*2/sqrt(2), thickness], center=true);
			}
		}
		translate([center_x, center_y, 0]) {
			rotate([0, 0, alpha]) {
				cube(size=[hyp, hyp, thickness + 2], center=true);
			}
		}
		translate([outer_radius + 1, 0, 0]) {
			cube(size=[(outer_radius + 1) * 2, outer_radius * 4, thickness + 2], center=true);
		}
		translate([0, -outer_radius-1, 0]) {
			cube(size=[outer_radius * 4, (outer_radius + 1) * 2, thickness + 2], center=true);
		}
	}
}


module part1(thickness) {
	// The two first quadrant with a 10-radius are ignored to left
	// space in order to insert the metal bar to bend.
	translate([0, 0, 0]) {
		rotate([0, 0, 0]) {
			quadrant(20, thickness);
		}
	}
	translate([0, -10, 0]) {
		rotate([0, 0, -90]) {
			quadrant(30, thickness);
		}
	}
	translate([-20, -10, 0]) {
		rotate([0, 0, -180]) {
			quadrant2(50, 30, 45, thickness);
		}
	}
}

module part2(thickness) {
	translate([-20, 20, 0]) {
		rotate([0, 0, -270]) {
			quadrant2(80, 45, 45, thickness);
		}
	}
	translate([30, 20, 0]) {
		rotate([0, 0, 0]) {
			quadrant2(130, 45, 45, thickness);
		}
	}
}

module part2prime(thickness) {
	translate([-20, 20, 0]) {
		rotate([0, 0, -270]) {
			quadrant2(80, 45, 45, thickness);
		}
	}
	translate([-20, 20, 0]) {
		rotate([0, 0, 0]) {
			quadrant2(80, 45, 20, thickness);
		}
	}
}

module part3(thickness) {
	translate([30, -30, 0]) {
		rotate([0, 0, -90]) {
			quadrant2(180, 45, 45, thickness);
		}
	}
}

module part3prime(thickness) {
	translate([-20, -30, 0]) {
		rotate([0, 0, -90]) {
			quadrant2(130, 20, 25, thickness);
		}
	}
}

module part4prime(thickness) {
	translate([30, -30, 0]) {
		rotate([0, 0, -180]) {
			quadrant2(180, 45, 45, thickness);
		}
	}
}


module hole_part1(thickness) {
	translate([0, 10, 0]) {
		cylinder(thickness * 2, 3, 3, center=true);
	}
	translate([10, -10, 0]) {
		cylinder(thickness * 2, 4, 4, center=true);
	}
	translate([-10, -30, 0]) {
		cylinder(thickness * 2, 4, 4, center=true);
	}
}

module hole_part2prime(thickness) {
	translate([-60, -20, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
	translate([-60, 60, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
}

module hole_part2(thickness) {
	hole_part2prime(thickness);
	translate([-10, 110, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
}

module hole_part3prime(thickness) {
	translate([20, 70, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
	translate([70, 20, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
}

module hole_part4prime(thickness) {
	translate([60, 0, 0]) {
		rotate([0, 0, -90]) {
			hole_part3(thickness);
		}
	}
}

module hole_part3(thickness) {
	translate([80, 110, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
	translate([170, 20, 0]) {
		cylinder(thickness * 2, 5, 5, center=true);
	}
}

module tray(thickness, scroll_thickness) {
	color("red") {
		difference() {
			translate([50, -40, -scroll_thickness/2]) {
				cylinder(thickness, 250, 250, center=true);
			}
			translate([50, -40, -scroll_thickness/2]) {
				cylinder(thickness*2, 4, 4, center=true);
			}
			hole_part1(20);
			hole_part2(20);
			hole_part3(20);
			hole_part3prime(20);
			hole_part4prime(20);
		}
	}
}

//$fn=100;


projection()
	difference() {
		part1(20);
		hole_part1(20);
	}
	;
/*
difference() {
	part2(20);
	hole_part2(20);
}

difference() {
	part3(20);
	hole_part3(20);
}

difference() {
	part2prime(20);
	hole_part2prime(20);
}

difference() {
	part3prime(20);
	hole_part3prime(20);
}
/*
difference() {
	part4prime(20);
	hole_part4prime(20);
	}*/

//tray(8, 20);
