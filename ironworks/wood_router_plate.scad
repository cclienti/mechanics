module rounding_plate(diam, thickness) {
	difference() {
		translate([diam/2, diam/2, 0]) {
			cube(size=[diam, diam, thickness], center=true);
		}
		cylinder(thickness*2, diam/2, diam/2, center=true);
	}
}

module wood_router_plate(width, height, thickness, rounding_diam) {
	router_screw_width = 106;
	router_screw_height = 56;
	router_screw_diam = 4.5;
	router_hole_diam = 70;
	router_extra_hole_radius = 8;
	plate_screw_diam = 5.5;
	plate_screw_distance = 15;
	plunge_screw_diam = 10;
	plunge_screw_x_pos = router_hole_diam/2 + 50;

	difference() {
		// plate
		cube(size=[width, height, thickness], center=true);

		// router screw holes
		translate([router_screw_width/2, router_screw_height/2, 0]) {
			cylinder(thickness*2, router_screw_diam/2, router_screw_diam/2, center=true);
		}
		translate([-router_screw_width/2, router_screw_height/2, 0]) {
			cylinder(thickness*2, router_screw_diam/2, router_screw_diam/2, center=true);
		}
		translate([router_screw_width/2, -router_screw_height/2, 0]) {
			cylinder(thickness*2, router_screw_diam/2, router_screw_diam/2, center=true);
		}
		translate([-router_screw_width/2, -router_screw_height/2, 0]) {
			cylinder(thickness*2, router_screw_diam/2, router_screw_diam/2, center=true);
		}

		// router hole
		cylinder(thickness*2, router_hole_diam/2, router_hole_diam/2, center=true);
		translate([router_hole_diam/2, 0, 0]) {
			cylinder(thickness*2, router_extra_hole_radius, router_extra_hole_radius, center=true);
		}
		translate([-router_hole_diam/2, 0, 0]) {
			cylinder(thickness*2, router_extra_hole_radius, router_extra_hole_radius, center=true);
		}

		// rounding corners
		translate([width/2-rounding_diam/2, height/2-rounding_diam/2, 0]) {
			rotate([0, 0, 0]) {
				rounding_plate(rounding_diam, thickness*2);
			}
		}
		translate([-width/2+rounding_diam/2, height/2-rounding_diam/2, 0]) {
			rotate([0, 0, 90]) {
				rounding_plate(rounding_diam, thickness*2);
			}
		}
		translate([width/2-rounding_diam/2, -height/2+rounding_diam/2, 0]) {
			rotate([0, 0, -90]) {
				rounding_plate(rounding_diam, thickness*2);
			}
		}
		translate([-width/2+rounding_diam/2, -height/2+rounding_diam/2, 0]) {
			rotate([0, 0, 180]) {
				rounding_plate(rounding_diam, thickness*2);
			}
		}

		// plate screw holes
		translate([width/2-plate_screw_distance, height/2-plate_screw_distance, 0]) {
			cylinder(thickness*2, plate_screw_diam/2, plate_screw_diam/2, center=true);
		}
		translate([-width/2+plate_screw_distance, height/2-plate_screw_distance, 0]) {
			cylinder(thickness*2, plate_screw_diam/2, plate_screw_diam/2, center=true);
		}
		translate([width/2-plate_screw_distance, -height/2+plate_screw_distance, 0]) {
			cylinder(thickness*2, plate_screw_diam/2, plate_screw_diam/2, center=true);
		}
		translate([-width/2+plate_screw_distance, -height/2+plate_screw_distance, 0]) {
			cylinder(thickness*2, plate_screw_diam/2, plate_screw_diam/2, center=true);
		}

		// plunge screw
		translate([plunge_screw_x_pos, 0, 0]) {
			cylinder(thickness*2, plunge_screw_diam/2, plunge_screw_diam/2, center=true);
		}
	}

}

$fn=50;
 wood_router_plate(250, 200, 5, 13);
