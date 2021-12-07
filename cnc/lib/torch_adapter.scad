module spacer(outer_diam, inner_diam, length) {
	linear_extrude(length) {
		difference() {
			circle(outer_diam/2);
			circle(inner_diam/2);
		}
	}
}

module sbr16_holes(sbr16uu_hole_x, sbr16uu_hole_y, hole_diam) {
	translate([0, 0, 0]) circle(hole_diam/2);
	translate([0, sbr16uu_hole_y, 0]) circle(hole_diam/2);
	translate([sbr16uu_hole_x, 0, 0]) circle(hole_diam/2);
	translate([sbr16uu_hole_x, sbr16uu_hole_y, 0]) circle(hole_diam/2);
}

module dsg16_holes(dsg16hh_hole_x, dsg16hh_hole_y, hole_diam) {
	translate([0, 0, 0]) circle(hole_diam/2);
	translate([0, dsg16hh_hole_y, 0]) circle(hole_diam/2);
	translate([dsg16hh_hole_x, 0, 0]) circle(hole_diam/2);
	translate([dsg16hh_hole_x, dsg16hh_hole_y, 0]) circle(hole_diam/2);

}

module torch_adapter(thickness, hole_diam) {
	dsg16hh_hole_x = 24;
	dsg16hh_hole_y = 40;
	sbr16uu_hole_x = 30;
	sbr16uu_hole_y = 32;
	sbr_to_sbr_dist = 50;
	sbr_to_dsg_dist = 60 - dsg16hh_hole_y/2 + sbr16uu_hole_y/2;

	adapter_width = 100;
	adapter_height = 200;

	max_hole_dist_x = sbr_to_sbr_dist + sbr16uu_hole_x;
	max_hole_dist_y = sbr_to_dsg_dist + dsg16hh_hole_y;

	linear_extrude(thickness) {
		difference() {
			square([adapter_width, adapter_height]);
			translate([(adapter_width-max_hole_dist_x)/2, adapter_height-max_hole_dist_y-10, 0]) {
				translate([0, 0, 0])
					sbr16_holes(sbr16uu_hole_x, sbr16uu_hole_y, hole_diam);
				translate([sbr_to_sbr_dist, 0, 0])
					sbr16_holes(sbr16uu_hole_x, sbr16uu_hole_y, hole_diam);
				translate([(sbr_to_sbr_dist-sbr16uu_hole_x)/2 + sbr16uu_hole_x - dsg16hh_hole_x/2, sbr_to_dsg_dist, 0])
					dsg16_holes(dsg16hh_hole_x, dsg16hh_hole_y, hole_diam);
			}
		}
	}

	translate([(adapter_width-max_hole_dist_x)/2, adapter_height-max_hole_dist_y-10, 0]) {
		translate([0, 0, -10]) spacer(10, 6, 10);
		translate([0, sbr16uu_hole_y, -10]) spacer(10, 6, 10);
		translate([sbr16uu_hole_x, 0, -10]) spacer(10, 6, 10);
		translate([sbr16uu_hole_x, sbr16uu_hole_y, -10]) spacer(10, 6, 10);
		translate([sbr_to_sbr_dist, 0, -10]) spacer(10, 6, 10);
		translate([sbr_to_sbr_dist, sbr16uu_hole_y, -10]) spacer(10, 6, 10);
		translate([sbr_to_sbr_dist+sbr16uu_hole_x, 0, -10]) spacer(10, 6, 10);
		translate([sbr_to_sbr_dist+sbr16uu_hole_x, sbr16uu_hole_y, -10]) spacer(10, 6, 10);

	}

}
