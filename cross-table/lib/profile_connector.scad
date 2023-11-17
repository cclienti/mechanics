module profile_connector(profile_width=30, num_holes=4, hole_diam=6, thickness=6) {
    marging = 1;
    width = profile_width;
    length = num_holes * profile_width;

    color([0, 0.5, 0.8, 0.5]) {
        linear_extrude(thickness) {
            difference() {
                translate([marging/2, marging/2]) {
                    square([width-marging, length-marging]);
                }
                union() {
                    for (i = [0 : num_holes-1]) {
                        translate([width/2, width/2 + i * width]) circle(d=hole_diam);
                    }
                }
            }
        }
    }
}

module profile_connector_double(profile_width=30, num_holes=4, hole_diam=6, thickness=6) {
    marging = 1;
    width = profile_width * 2;
    length = num_holes * profile_width;

    color([0, 0.5, 0.8, 0.5]) {
        linear_extrude(thickness) {
            difference() {
                translate([marging/2, marging/2]) {
                    square([width-marging, length-marging]);
                }
                union() {
                    for (i = [0 : num_holes-1]) {
                        translate([width/4, width/4 + i * width/2]) circle(d=hole_diam);
                        translate([3*width/4, width/4 + i * width/2]) circle(d=hole_diam);
                    }
                }
            }
        }
    }
}

module profile_connector_E30x120() {
    profile_connector(profile_width=30, num_holes=4, hole_diam=6, thickness=6);
}

module profile_connector_E30x150() {
    profile_connector(profile_width=30, num_holes=5, hole_diam=6, thickness=6);
}

module profile_connector_E60x120() {
    profile_connector_double(profile_width=30, num_holes=4, hole_diam=6, thickness=6);
}
