module fixed_bearing_bk_adapter(length, width, height, bk_hole_dist_C1, bk_hole_dist_P, slot_profile_hole_dist, hole_diam) {
	linear_extrude(height) {
		difference() {
			polygon(points=[[0, 0], [0, width], [length, width], [length, 0]], convexity=10);
			// BK Holes
			translate([(length-bk_hole_dist_C1)/2, (width-bk_hole_dist_P)/2, 0])
				circle(hole_diam/2);
			translate([(length-bk_hole_dist_C1)/2, bk_hole_dist_P+(width-bk_hole_dist_P)/2, 0])
				circle(hole_diam/2);
			translate([bk_hole_dist_C1+(length-bk_hole_dist_C1)/2, (width-bk_hole_dist_P)/2, 0])
				circle(hole_diam/2);
			translate([bk_hole_dist_C1+(length-bk_hole_dist_C1)/2, bk_hole_dist_P+(width-bk_hole_dist_P)/2, 0])
				circle(hole_diam/2);

			// Slot profile holes
			translate([10, (width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);
			translate([10, slot_profile_hole_dist+(width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);

			translate([length-10, (width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);
			translate([length-10, slot_profile_hole_dist+(width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);

		}

	}
}

module fixed_bearing_bf_adapter(length, width, height, bf_hole_dist_L, bf_hole_dist_P, slot_profile_hole_dist, hole_diam) {
	linear_extrude(height) {
		difference() {
			polygon(points=[[0, 0], [0, width], [length, width], [length, 0]], convexity=10);
			// BF Holes
			translate([length/2, (width-bf_hole_dist_P)/2, 0])
				circle(hole_diam/2);
			translate([length/2, width-(width-bf_hole_dist_P)/2, 0])
				circle(hole_diam/2);

			// Slot profile holes
			translate([length-10, (width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);
			translate([length-10, slot_profile_hole_dist+(width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);

			// Slot profile holes
			translate([10, (width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);
			translate([10, slot_profile_hole_dist+(width-slot_profile_hole_dist)/2, 0])
				circle(hole_diam/2);

		}

	}
}
