module shutter_blade(width, length, thickness, groove_depth, chamfer) {
    w = width;
    t = thickness;
    g = groove_depth;
    c = chamfer;

    t2 = t/2;
    g2 = g/2;

    linear_extrude(length) {
        polygon(points=[[c, 0], [w-2*c, 0], [w-c, 0], [w, c], [w, t2-g2],
                        [w-g, t2-g2], [w-g, t2+g2], [w, t2+g2], [w, t-c],
                        [w-c, t], [c, t], [0, t-c], [0, t2+g2], [-g, t2+g2],
                        [-g, t2-g2], [0, t2-g2], [0, c]]);
    }
}

module first_shutter_blade(width, length, thickness, groove_depth, chamfer) {
    w = width;
    t = thickness;
    g = groove_depth;
    c = chamfer;

    t2 = t/2;
    g2 = g/2;

    linear_extrude(length) {
        polygon(points=[[c, 0], [w-2*c, 0], [w-c, 0], [w, c], [w, t2-g2],
                        [w-g, t2-g2], [w-g, t2+g2], [w, t2+g2], [w, t-c],
                        [w-c, t], [c, t], [0, t-c], [0, c]]);
    }
}

module last_shutter_blade(width, length, thickness, groove_depth, chamfer) {
    w = width;
    t = thickness;
    g = groove_depth;
    c = chamfer;

    t2 = t/2;
    g2 = g/2;

    linear_extrude(length) {
        polygon(points=[[c, 0], [w-2*c, 0], [w-c, 0], [w, c], [w, t-c],
                        [w-c, t], [c, t], [0, t-c], [0, t2+g2], [-g, t2+g2],
                        [-g, t2-g2], [0, t2-g2], [0, c]]);
    }
}


module hbar(width, length, thickness, chamfer) {
    w = width;
    t = thickness;
    c = chamfer;
    c2 = chamfer*sqrt(2);

    translate([length, 0, width]) {
        rotate([180, 90, 0]) {
            difference() {
                linear_extrude(length) {
                    polygon(points=[[0, 0], [w, 0], [w, t-c], [w-c, t], [c, t], [0, t-c]]);
                }
                translate([width/2, thickness, 0]) rotate([45, 0, 0]) cube([width, c2, c2], center=true);
                translate([width/2, thickness, length]) rotate([45, 0, 0]) cube([width, c2, c2], center=true);
            }
        }
    }
}

module zbar(hbar_internal_dist, hbar_length, width, thickness, chamfer, sym=true) {
    H = hbar_internal_dist;
    V = hbar_length;
    L = width;
    c2 = chamfer * sqrt(2);
    length = -(H*H*sqrt(V*V-L*L+H*H)-H*L*V)/(L*L-H*H);
    beta = acos(H/length);
    x = L * length / H;
    echo(str("zbar length: ", length));
    echo(str("zbar cut angle: ", beta, "°"));
    rotate([90, 0, 0]) {
        difference() {
            linear_extrude(thickness) {
                polygon(points=[[0, 0], [x, 0], [V, H], [V-x, H]]);
            }
            translate([x/2, 0, thickness]) rotate([45, 0, 0]) cube([x+20, c2, c2], center=true);
            translate([V-x/2, H, thickness]) rotate([45, 0, 0]) cube([x+20, c2, c2], center=true);
            translate([V/2-x/2, H/2, thickness]) rotate([45, 0, 90-beta]) cube([length+20, c2, c2], center=true);
            translate([V/2+x/2, H/2, thickness]) rotate([45, 0, 90-beta]) cube([length+20, c2, c2], center=true);
        }
    }
}

module shutter(first_width, blade_width, last_width, num_blades, length, thickness) {

    first_shutter_blade(first_width, length, thickness, 5, 5);

    for (i = [0: num_blades-3]) {
        translate([blade_width*i+first_width, 0, 0])
            shutter_blade(blade_width, length, thickness, 5, 5);
    }

    translate([(num_blades-2)*blade_width+first_width, 0, 0])
        last_shutter_blade(last_width, length, thickness, 5, 5);



}


// bar_pos = ((88.3+88.3*5+65)-520)/2;
// color("White") {
//     shutter(88.3, 88.3, 65, 7, 1278, 26);
//     translate([bar_pos, 0, 145]) hbar(95, 520, 26, 5);
//     translate([bar_pos, 0, 800+95+145]) hbar(95, 520, 26, 5);
//     //translate([bar_pos, 0, 145+95]) zbar(800, 520, 95, 26, 5);
//     translate([bar_pos+520, 0, 145+95]) mirror([1, 0, 0]) zbar(800, 520, 95, 26, 5);
// }
// color("White") {
//     translate([1800, 0, 0]) {
//         shutter(88.3, 88.3, 65, 7, 1278, 26);
//         translate([bar_pos, 0, 145]) hbar(95, 520, 26, 5);
//         translate([bar_pos, 0, 800+95+145]) hbar(95, 520, 26, 5);
//         translate([bar_pos, 0, 145+95]) zbar(800, 520, 95, 26, 5);
//     }
// }

bar_pos = ((495)-430)/2;
color("White") {
    shutter(70.9, 88.3, 70.9, 6, 1680, 26);
    translate([bar_pos, 0, 1680-180.8-1295-95/2]) hbar(95, 430, 26, 5);
    translate([bar_pos, 0, 1680-180.8-95/2]) hbar(95, 430, 26, 5);
    translate([bar_pos+430, 0, 1680-180.8-1295+95/2]) mirror([1, 0, 0]) zbar(1295-95, 430, 95, 26, 5);
}
color("White") {
    translate([1495, 0, 0]) {    shutter(70.9, 88.3, 70.9, 6, 1680, 26);
        translate([bar_pos, 0, 1680-180.8-1295-95/2]) hbar(95, 430, 26, 5);
        translate([bar_pos, 0, 1680-180.8-95/2]) hbar(95, 430, 26, 5);
        translate([bar_pos, 0, 1680-180.8-1295+95/2]) zbar(1295-95, 430, 95, 26, 5);
    }
}
