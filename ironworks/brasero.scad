// See documentation schematics in docs/octagon_inclined_face.*
function d1(b, h) = sqrt((b-h)^2 + h^2);
function beta(b, h) = acos((b-h)/d1(b,h));
function r(b) = b / cos(45/2);
function d2(b, h) = sqrt((r(b) - h/cos(45/2))^2 + h^2);
function a(b, h) = sqrt(d2(b, h)^2-d1(b, h)^2);

module iso_triangle(b, h, thickness) {
	a = a(b, h);
	echo(a = a);
	echo(d1 = d1(b, h));
	linear_extrude(thickness) {
		polygon(points=[[0, 0], [-a, -d1(b, h)], [a, -d1(b, h)]]);
	}
}

module block(b, h, border_height, thickness) {
	angle = beta(b, h);
	echo(angle = angle);

	rotate([-angle, 0, 0]) {
		iso_triangle(b, h, thickness);
	}
	translate([-a(b, h), b-h-thickness, h+thickness]) {
		cube([2*a(b, h), thickness, border_height]);
	}
}

/*
for ( i = [0 : 7] ) {
	rotate([0, 0, (45)*i]) {
		block(300, 70, 50, 2);
	}
 }
*/

projection() iso_triangle(300, 70, 2);
