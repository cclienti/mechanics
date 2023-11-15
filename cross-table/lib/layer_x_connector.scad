include <../../cnc/lib/fixed_bearings.scad>

module layer_x_connector(thickness=6) {
    width = 175;
    length = 350;

	BK_HOLE_DIST = bk_hole_P(BK12);

    color([0, 0.5, 0.8, 0.5]) {
        linear_extrude(thickness) {
            difference() {
                square([length, width]);
            }
        }
    }
}
