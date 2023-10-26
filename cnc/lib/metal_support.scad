module sector(radius, angle, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat(
        [[0, 0]],
        [for(a = [-angle : step : +angle - 360])
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angle), r * sin(angle)]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}


// for the doc, see docs/arc-length.odg
module support_blade(x, D, thickness=2, plate_width, fn=48) {
    d = D / 2;
    r = (d^2 + x^2) / (2 * x);
    alpha = acos(1 - (x / r));
    L = 2 * alpha * r * PI / 180;
    echo("Metal support plate length (mm): ", L);
    echo("Angle (deg): ", alpha);

    color("gray")
    translate([-r+x, 0, 0])
    linear_extrude(plate_width) {
        difference() {
            sector(r, alpha+1, fn);
            sector(r-thickness, alpha+2, fn);
        }
    }

}


module corner(width, length, thickness, notch_spacing=100, notch_width=2, reverse_notch=false) {
    color("gray") render() {
        difference() {
            linear_extrude(length) {
                union() {
                    polygon(points=[[0, width],
                                    [0, 0],
                                    [width, 0],
                                    [width, thickness],
                                    [thickness, thickness],
                                    [thickness, width]],
                            convexity=3);
                    rotate(45) sector(thickness * 2, 45);
                }
            }
            start = reverse_notch ? notch_spacing * 1.5 : notch_spacing / 2;
            stop = reverse_notch ? notch_spacing / 2 : notch_spacing * 1.5;
            for (i =  [start : notch_spacing : length-stop]) {
                translate([-0.01, thickness, i])
                    cube([thickness+0.02, width*2, notch_width]);
            }
        }

    }

}

module metal_support(length, width, blade_height, blade_spacing, blade_thickness = 2) {
    translate([0, 0, 0]) {
        rotate([90, 0, 90]) corner(blade_height/2, length, 3, blade_spacing, blade_thickness, false);
    }
    translate([0, width/2, 0])  {
        mirror([0, 0, 0]) rotate([90, 0, 90]) corner(blade_height/2, length, 3, blade_spacing, blade_thickness, true);
    }
    translate([0, width/2, 0]) {
        mirror([0, 1, 0]) rotate([90, 0, 90]) corner(blade_height/2, length, 3, blade_spacing, blade_thickness, true);
    }
    translate([0, width, 0]) {
        mirror([0, 1, 0]) mirror([0, 1, 0]) rotate([90, 0, 90]) corner(blade_height/2, length, 3, blade_spacing, blade_thickness, false);
    }

    for(i=[0: blade_spacing : length - 2 * blade_spacing]) {
        translate([blade_spacing/2+i+ blade_thickness/2, width/2, 2 * blade_thickness])
            support_blade(blade_spacing, width, 2, blade_height, 1024);
    }
}
