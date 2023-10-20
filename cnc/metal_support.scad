
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


module arc(r1, r2, a1, a2) {
  difference() {
    difference() {
      polygon([[0,0], [cos(a1) * (r1 + 50), sin(a1) * (r1 + 50)], [cos(a2) * (r1 + 50), sin(a2) * (r1 + 50)]]);
      circle(r = r2);
    }
    difference() {
      circle(r=r1 + 100);
      circle(r=r1);
    }
  }
}


// for the doc, see docs/arc-length.odg
module meta_support_plate(x, D, thickness=2, plate_width, fn=48) {
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
            sector(r, alpha, fn);
            sector(r-thickness, alpha+1, fn);
        }
    }

}


meta_support_plate(50, 1000, 2, 40, 1024);
