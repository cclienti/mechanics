module torche_adapter_base(thickness, width=90, length=120) {
    nut_width = 80;
    y_offset = (width - nut_width)/2;
    x_offset = 26;
	color([0, 0.5, 0.8, 0.5]) {
        difference() {
            linear_extrude(thickness) {
                difference() {
                    polygon(points=[[-x_offset, 0],
                                    [-x_offset, 90],
                                    [length-x_offset, 90],
                                    [length-x_offset, 0]]);
                    translate([10, y_offset + 10]) circle(d=5);
                    translate([40, y_offset + 10]) circle(d=5);
                    translate([10, y_offset + 70]) circle(d=5);
                    translate([40, y_offset + 70]) circle(d=5);
                    // translate([15, y_offset +  5]) circle(d=5);
                    // translate([35, y_offset +  5]) circle(d=5);
                    // translate([15, y_offset + 75]) circle(d=5);
                    // translate([35, y_offset + 75]) circle(d=5);
                    translate([length - x_offset - 15, width/2]) circle(d=5);
                    translate([- x_offset + 15, width/2]) circle(d=5);
                }
            }
        }
    }

}


module torche_adapter() {
    rotate([0, 90, 0]) torche_adapter_base(8, 90, 130);
}
