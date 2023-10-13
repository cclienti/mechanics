function ballscrew_mount_width(type) = type[2];
function ballscrew_mount_height(type) = type[3];
function ballscrew_mount_length(type) = type[6];
function ballscrew_mount_C1(type) = type[7];
function ballscrew_mount_C2(type) = type[8];
function ballscrew_mount_P(type) = type[9];

module ballscrew_mount(type) {
	translate([ballscrew_mount_length(type),
	           -ballscrew_mount_width(type)/2 ,
	           -ballscrew_mount_height(type)/2]) {
		rotate([0, -90, 0]) {
			ballscrew_mount_base(type);
		}
	}
}

module ballscrew_mount_base(type) {
	D = type[1];
	B = ballscrew_mount_width(type);
	H = ballscrew_mount_height(type);
	h = type[4];
	E = type[5];
	L = ballscrew_mount_length(type);
	C1 = type[7];
	C2 = ballscrew_mount_C2(type);
	P = ballscrew_mount_P(type);
	X = type[10];
	W = type[11];
	Y = type[12];

	screw_depth = 10;

	render()
	difference() {
		linear_extrude(L) {
			difference() {
				polygon(points=[[E, 0], [H, 0], [H, B], [E, B], [0, B-E], [0, E]],
				        convexity=10);
				translate([H-h, B/2, 0]) {
					circle(D/2);
				}
			}
		}
		translate([H-h, B/2, L-screw_depth]) {
			rotate([0, 0, 90]) {
				rotate([0, 0,   0]) translate([W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
				rotate([0, 0, -45]) translate([W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
				rotate([0, 0,  45]) translate([W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
				rotate([0, 0,   0]) translate([-W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
				rotate([0, 0, -45]) translate([-W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
				rotate([0, 0,  45]) translate([-W/2, 0, 0]) 	cylinder(screw_depth+1, Y/2, Y/2);
			}
		}
		translate([H-screw_depth, B/2, L/2]) {
			rotate([0, 90, 0]) {
				translate([C2/2, P/2, 0]) cylinder(screw_depth+1, Y/2, Y/2);
				translate([C2/2, -P/2, 0]) cylinder(screw_depth+1, Y/2, Y/2);
				translate([-C2/2, P/2, 0]) cylinder(screw_depth+1, Y/2, Y/2);
				translate([-C2/2, -P/2, 0]) cylinder(screw_depth+1, Y/2, Y/2);
			}
		}
	}
}
