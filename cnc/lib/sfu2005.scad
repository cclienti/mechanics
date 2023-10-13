use <../../libraries/NopSCADlib/vitamins/rod.scad>

SFU2005 = ["SFU2005", "Leadscrew nut for SFU2005",    20, 36, 42.5, 58,    10, 0,   6, 6.7,   47/2,    M6_cap_screw, 5, 10, 44, "#DFDAC5"];

fixed_bearing_bk_ax1 = 20;
fixed_bearing_bk_ax2 = 40;
fixed_bearing_bk_offset = fixed_bearing_bk_ax1 + fixed_bearing_bk_ax2;
fixed_bearing_bf_ax = 13;

module sfu2005(total_length) {
	bk_ax1 = fixed_bearing_bk_ax1;
	bk_ax2 = fixed_bearing_bk_ax2;
	bf_ax = fixed_bearing_bf_ax;

	ldscrew_length = total_length-(bk_ax1+bk_ax2+bf_ax);

	rotate([0, 90, 0])
	translate([0, 0, ldscrew_length/2 + fixed_bearing_bf_ax]) {
		leadscrew(20, ldscrew_length, 20, 5);

		color(grey(90))
			translate([0, 0, ldscrew_length/2]) {
			cylinder(bk_ax2, 7.5, 7.5);
			translate([0, 0, bk_ax2]) {
				cylinder(bk_ax1, 6, 6);
			}
		}

		color(grey(90)) {
			translate([0, 0, -ldscrew_length/2 - bf_ax/2]) {
				rotate([0, 0, 0]) cylinder(bf_ax, 7.5, 7.5, center=true);
			}
		}
	}
}
