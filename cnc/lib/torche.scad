module torche_AT_70() {
    diam = 35;
    length1 = 240;
    length2 = 314;
    length3 = 358;

    translate([0, 0, length3]) rotate([0, 180, 0])
    rotate_extrude(angle = 360, convexity=0) {
        polygon(points=[[0, 0],
                        [diam/2, 0],
                        [diam/2, length2],
                        [diam/2-2.5, length2],
                        [diam/2-2.5, length2+6.25],
                        [diam/2-5, length2+8.75],
                        [diam/2-5, length3-14.5],
                        [diam/2-5-8.5, length3],
                        [0, length3]]);
    }
}
