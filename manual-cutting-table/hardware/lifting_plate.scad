module lifting_plate(thickness=5) {
    width=120;
    height=75;
    linear_extrude(thickness) {
        difference() {
            polygon([[0, 0], [width, 0], [width, height], [0, height]]);

            // 30x120 Alu profile mounting holes
            translate([15, 15]) circle(d=6);
            translate([15+30, 15]) circle(d=6);
            translate([15+30+30, 15]) circle(d=6);
            translate([15+30+30+30, 15]) circle(d=6);

            // Nema14 mounting holes
            translate([17, 48]) circle(d=3);
            translate([17+26, 48]) circle(d=3);

            // KFL08 mounting holes
            translate([11.5, 61]) circle(d=4);
            translate([11.5+18.5, 61]) circle(d=10);
            translate([11.5+18.5+18.5, 61]) circle(d=4);

        }
    }
}
