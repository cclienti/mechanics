module layer_y_to_x_base(width, length, thickness=6) {
        color([0, 0.5, 0.8, 0.5]) {
            translate([-thickness, -width/2, 0])
                rotate([90, 0, 90]) {
                linear_extrude(thickness) {
                    difference() {
                        polygon(points=[[0, 0],
                                        [width, 0],
                                        [width, length],
                                        [0, length]]);
                    }
                }
            }
        }
}


module layer_y_to_x() {
    width=125;
    length=660;

    translate([0, width/2, 0]) {
        rotate([0, 90, 0]) {
            layer_y_to_x_base(width, length);
        }
    }
}
