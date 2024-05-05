module prop(width=120, holes_dist=80, hole_diam=12, thickness=4)
{
    color(c="DarkSlateGray")
    linear_extrude(height=thickness) {
        difference() {
            polygon(points=[[-width/2, -width/2],
                            [ width/2, -width/2],
                            [ width/2,  width/2],
                            [-width/2,  width/2]]);
            translate([ holes_dist/2,  holes_dist/2]) circle(d=12);
            translate([ holes_dist/2, -holes_dist/2]) circle(d=12);
            translate([-holes_dist/2,  holes_dist/2]) circle(d=12);
            translate([-holes_dist/2, -holes_dist/2]) circle(d=12);
        }
    }
}

module tube(width=40, plate_width=120, plate_angle=20, thickness=2)
{
    hyp = width / sin(20);
    adj = hyp * cos(20);
    toff = (plate_width/2 - width/2) * tan(30);

    echo("Tube length: ", toff + adj);
    echo("Tube offset after cut at ", plate_angle, "° : ", toff);

    color("cyan")
    rotate([0, 0, -90]) {
        translate([width/2, 0, 0])
            rotate([0, -90, 0]) {
            difference() {
                linear_extrude(width) {
                    polygon([[width, -toff],
                             [width, adj],
                             [0, 0],
                             [0, -toff]
                             ]);
                }
                translate([thickness, -1-toff, thickness]) cube([width-2*thickness, adj+toff+2, width-2*thickness]);
            }
        }
    }
}

module triangle(width, thickness, hole_diam=20)
{
    height = width * cos(30);
    center = height - width / sqrt(3);

    echo("Triangle width: ", width, ", height: ", height, ", center: ", center);

    color(c="gray", alpha=0.8) {
        rotate([0, 0, 90]) {
            translate([-width/2, -center, -thickness]) {
                linear_extrude(thickness) {
                    difference() {
                        polygon([[0, 0], [width/2, height], [width, 0]]);
                        translate([width/2, center]) circle(d=hole_diam);
                    }
                }
            }
        }
    }
}


plate_width = 120;
plate_angle = 20;
plate_thickness = 4;
tube_width = 40;

triangle_plate_width = plate_width/sqrt(3);
prop_dist = triangle_plate_width/2;


triangle(plate_width, 4);
translate([0, 0, tube_width]) triangle(tube_width, 2);

rotate([0, 0, 0])  {
    translate([triangle_plate_width/2, 0, 0]) {
        rotate([0, -plate_angle, 0]) {
            translate([plate_width/2, 0, -plate_thickness]) {
                prop(plate_width, thickness=plate_thickness);
            }
        }
        tube(tube_width, plate_width, plate_angle);
    }
}

rotate([0, 0, 120])  {
    translate([triangle_plate_width/2, 0, 0]) {
        rotate([0, -plate_angle, 0]) {
            translate([plate_width/2, 0, -plate_thickness]) {
                prop(plate_width, thickness=plate_thickness);
            }
        }
        tube(tube_width, plate_width, plate_angle);
    }
}

rotate([0, 0, 240])  {
    translate([triangle_plate_width/2, 0, 0]) {
        rotate([0, -plate_angle, 0]) {
            translate([plate_width/2, 0, -plate_thickness]) {
                prop(plate_width, thickness=plate_thickness);
            }
        }
        tube(tube_width, plate_width, plate_angle);
    }
}
