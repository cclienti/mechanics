include <../../libraries/NopSCADlib/vitamins/extrusions.scad>
include <../../libraries/NopSCADlib/vitamins/rod.scad>
include <nema23_mount.scad>

module z_axis_motor_plate() {
    color("DarkSlateGray") {
        linear_extrude(10) {
            difference() {
                polygon(points=[[0, 0],
                                [80, 0],
                                [80, 65],
                                [77, 68],
                                [3, 68],
                                [0, 65]]);
                translate([40, 40]) nema23_mounting_hole_2d(plinth_diam = 38.1, epsilon = 0.1);
                translate([10, 10]) circle(r=4);
                translate([30, 10]) circle(r=4);
                translate([50, 10]) circle(r=4);
                translate([70, 10]) circle(r=4);
            }
        }
    }
}

module z_axis_plate() {
    color("DarkSlateGray") {
        linear_extrude(10) {
            difference() {
                polygon(points=[[0, 0],
                                [80, 0],
                                [80, 53],
                                [77, 56],
                                [3, 56],
                                [0, 53]]);
                translate([40, 40]) circle(r=6);
                translate([10, 10]) circle(r=4);
                translate([30, 10]) circle(r=4);
                translate([50, 10]) circle(r=4);
                translate([70, 10]) circle(r=4);
            }
        }
    }
}

module z_axis_bearing() {
    color("DarkSlateGray") {
        translate([0, 80, 0]) {
            rotate([90, 0, 0]){
                linear_extrude(80) {
                    polygon(points=[[0, 0],
                                    [24, 0],
                                    [24, 37],
                                    [12, 37],
                                    [12, 12],
                                    [0, 12]]);
                }
            }
        }
    }
}

module z_axis_nut() {
    color("DarkSlateGray") {
        difference() {
            cube([50, 80, 32]);
            translate([10, 10, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([40, 10, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([10, 70, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([40, 70, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([15, 5, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([35, 5, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([15, 75, 32-8]) cylinder(8.1, 2.5, 2.5);
            translate([35, 75, 32-8]) cylinder(8.1, 2.5, 2.5);
        }
    }
}

module z_axis(pos) {
    extrude_length = 190;
    translate([-extrude_length-10, -40, 0]) {
        translate([26, 0, 20]) z_axis_bearing();

        translate([24+16+10+pos, 0, 24]) z_axis_nut();

        color("silver") {
            translate([extrude_length/2 + 20, 40, 40]) rotate([0, 90, 0]) leadscrew(12, extrude_length, 12, 8);
        }
        color("gray") {
            translate([10+30, 6+10, 40]) rotate([0, 90, 0]) cylinder(extrude_length-24, 6, 6);
            translate([10+30, 6+60, 40]) rotate([0, 90, 0]) cylinder(extrude_length-24, 6, 6);
        }
        translate([extrude_length/2 + 10, 40, 10]) {
            rotate([0, -90, 180]) {
                translate([-10, 40, -extrude_length/2 - 10]) rotate([0, 0, -90]) z_axis_motor_plate();
                extrusion(E2080, extrude_length, cornerHole = true);
                translate([-10, 40, extrude_length/2]) rotate([0, 0, -90]) z_axis_plate();
            }
        }
    }
}
