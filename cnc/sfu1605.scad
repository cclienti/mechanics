use <../libraries/NopSCADlib/vitamins/rod.scad>

fixed_bearing_bk_ax1 = 15;
fixed_bearing_bk_ax2 = 39;
fixed_bearing_bk_offset = fixed_bearing_bk_ax1 + fixed_bearing_bk_ax2;
fixed_bearing_bf_ax = 11;

module sfu1605(total_length) {
	bk_ax1 = fixed_bearing_bk_ax1;
	bk_ax2 = fixed_bearing_bk_ax2;
	bf_ax = fixed_bearing_bf_ax;

	ldscrew_length = total_length-(bk_ax1+bk_ax2+bf_ax);

	translate([0, 0, -(bk_ax1 + bk_ax2 - bf_ax) / 2]) {
		leadscrew(16, ldscrew_length, 16, 5);

		color(grey(90))
			translate([0, 0, ldscrew_length/2]) {
			cylinder(bk_ax2, 6, 6);
			translate([0, 0, bk_ax2]) {
				cylinder(bk_ax1, 5, 5);
			}
		}

		color(grey(90)) {
			translate([0, 0, -ldscrew_length/2 - bf_ax/2]) {
				rotate([0, 0, 0]) cylinder(bf_ax, 5, 5, center=true);
			}
		}
	}
}
