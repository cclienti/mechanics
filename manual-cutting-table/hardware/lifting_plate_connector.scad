module lifting_plate_connector(thickness=5) {
    width=120;
    height=45;
    linear_extrude(thickness) {
        difference() {
            polygon([[0, 0], [120, 0], [120, 45], [0, 45]]);

            translate([14,    7.5])    circle(d=6);
            translate([14,    7.5+30]) circle(d=6);
            translate([14+32, 7.5])    circle(d=6);
            translate([14+32, 7.5+30]) circle(d=6);

            translate([30, 22.5]) circle(d=5);
            translate([30,    12.5])    circle(d=4);
            translate([30,    12.5+20])    circle(d=4);

            translate([78,    12.5])    circle(d=4);
            translate([78,    12.5+20]) circle(d=4);
            translate([78+24, 12.5])    circle(d=4);
            translate([78+24, 12.5+20]) circle(d=4);


        }
    }
}
