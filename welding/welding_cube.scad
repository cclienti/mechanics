module welding_teeth(size, thickness, num_teeth_per_edge, epsilon) {
	face_size =  size + 2*thickness;
	teeth_length = size / num_teeth_per_edge;

	translate([-face_size/2-thickness, -thickness-epsilon, -thickness]) {
		cube(size=[teeth_length+2*thickness+epsilon/2, 2*(thickness+epsilon), 2*thickness]);
		for (i = [1:num_teeth_per_edge/2-1]) {
			translate([2*thickness+2*i*teeth_length-epsilon/2, 0, 0]) {
				cube(size=[teeth_length+epsilon, 2*(thickness+epsilon), 2*thickness]);
			}
		}
	}
}

module welding_mounting_holes(size, thickness, mounting_diam, hole_offset, hole_period) {
	translate([-size/2+10,
	           -size/2+hole_offset+hole_period/2, 0]) {
		cylinder(h=2*thickness, r=mounting_diam/2, center=true);
	}
	translate([-size/2+hole_offset+hole_period/2,
	           -size/2+10, 0]) {
		cylinder(h=2*thickness, r=mounting_diam/2, center=true);
	}
}

module welding_face(size, thickness, num_teeth_per_edge,
                    hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon) {

	face_size =  size + 2*thickness;
	teeth_length = size / num_teeth_per_edge;
	num_holes_x = floor(size / hole_period_x) - 1;
	num_holes_y = floor(size / hole_period_y) - 1;
	hole_offset_x = (size - num_holes_x * hole_period_x) / 2;
	hole_offset_y = (size - num_holes_y * hole_period_y) / 2;

	difference() {
		cube(size=[face_size, face_size, thickness], center=true);

		// North teeth
		translate([0, face_size/2, 0]) {
			rotate([0, 180, 0]) {
				welding_teeth(size, thickness, num_teeth_per_edge, epsilon);
			}
		}

		// South teeth
		translate([0, -face_size/2, 0]) {
			rotate([0, 0, 0]) {
				welding_teeth(size, thickness, num_teeth_per_edge, epsilon);
			}
		}

		// East teeth
		translate([-face_size/2, 0, 0]) {
			rotate([0, 180, 90]) {
				welding_teeth(size, thickness, num_teeth_per_edge, epsilon);
			}
		}

		// West teeth
		translate([face_size/2, 0, 0]) {
			rotate([0, 180, -90]) {
				welding_teeth(size, thickness, num_teeth_per_edge, epsilon);
			}
		}

		// Two axes holes
		for (i = [0:num_holes_x]) {
			for (j = [0:num_holes_y]) {
				translate([-size/2+hole_offset_x+i*hole_period_x,
				           -size/2+hole_offset_y+j*hole_period_y, 0]) {
					cylinder(h=2*thickness, r=hole_diam/2, center=true);
				}
			}
		}

		hole_offset = min(hole_offset_x, hole_offset_y);
		hole_period = min(hole_period_x, hole_period_y);

		// Mounting holes
		rotate([0, 0, 0])
			welding_mounting_holes(size, thickness, mounting_diam, hole_offset, hole_period);

		mirror([1, 0, 0])
			welding_mounting_holes(size, thickness, mounting_diam, hole_offset, hole_period);

		mirror([0, 1, 0])
			welding_mounting_holes(size, thickness, mounting_diam, hole_offset, hole_period);

		mirror([1, 1, 0])
			welding_mounting_holes(size, thickness, mounting_diam, hole_offset, hole_period);
	}
}


module welding_cube(size, thickness, num_teeth_per_edge,
                    hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon) {

	color("red") {
		translate([0, 0, size/2+thickness/2]) {
			rotate([0, 0, 0]) {
				welding_face(size, thickness, num_teeth_per_edge,
				             hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon);
			}
		}
	}

	color("cyan") {
		rotate([0, 0, 0])
			translate([size/2+thickness/2, 0, 0]) {
			rotate([0, 90, 0]) {
				welding_face(size, thickness, num_teeth_per_edge,
				             hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon);
			}
		}
	}

	color("yellow") {
		translate([0, -size/2-thickness/2, 0]) {
			rotate([90, 0, 0]) {
				welding_face(size, thickness, num_teeth_per_edge,
				             hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon);
			}
		}
	}

	color("red") {
		rotate([0, 0, 90])
			translate([0, 0, -size/2-thickness/2]) {
			rotate([0, 180, 90]) {
				welding_face(size, thickness, num_teeth_per_edge,
				             hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon);
			}
		}
	}

	color("yellow") {
		translate([0, size/2+thickness/2, 0]) {
			rotate([270, 0, 0]) {
				welding_face(size, thickness, num_teeth_per_edge,
				             hole_diam, hole_period_x, hole_period_y, mounting_diam, epsilon);
			}
		}
	}
}


$fn=100;
projection() welding_face(250, 4, 10, 16, 55, 52.7777778, 6, 0.25); // for DXF export
//welding_cube(250, 4, 10, 16, 55, 52.7777778, 6, 0.25);
