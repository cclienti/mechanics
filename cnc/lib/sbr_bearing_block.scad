include <../../libraries/NopSCADlib/core.scad>
use <../../libraries/NopSCADlib/vitamins/screw.scad>
use <../../libraries/NopSCADlib/vitamins/nut.scad>
use <../../libraries/NopSCADlib/vitamins/washer.scad>
use <../../libraries/NopSCADlib/vitamins/linear_bearing.scad>
use <../../libraries/NopSCADlib/vitamins/circlip.scad>

function sbr_bearing_block_width(type) = type[3];
function sbr_bearing_block_length(type) = type[4];
function sbr_bearing_block_height(type) = type[5];
function sbr_bearing_hole_dist(type) = type[1];
function sbr_bearing_hole_height(type) = sbr_bearing_block_height(type) - sbr_bearing_hole_dist(type);
function sbr_bearing_screw_dia(type) = type[11];


module sbr_bearing_block(type) {
	translate([0,
	           -sbr_bearing_block_width(type)/2,
	           -sbr_bearing_hole_height(type)]) {
		rotate([90, 0, 90]) {
			sbr_bearing_block_base(type);
		}
	}
}

module sbr_bearing_block_base(type) {
	sbr_h = type[1];
	sbr_E = type[2];
   sbr_W = sbr_bearing_block_width(type);
   sbr_L = sbr_bearing_block_length(type);
   sbr_F = sbr_bearing_block_height(type);
	sbr_T = type[6];
	sbr_h1 = type[7];
	sbr_theta = type[8];
	sbr_B = type[9];
	sbr_C = type[10];
	sbr_S = sbr_bearing_screw_dia(type);
	sbr_l = type[12];
	sbr_bearing = type[13];
	sbr_clip = type[14];

	sbr_chamfer = sbr_l - sbr_T;
	sbr_x = sbr_h1 / (2*tan(sbr_theta/2));
	screw_offset_x = (sbr_W-sbr_B)/2;
	scree_offset_z = (sbr_L-sbr_C)/2;
	hole_height = sbr_bearing_hole_height(type);

	color(grey(90)) render()
	difference() {
		linear_extrude(sbr_L, center=true) {
			difference() {
				polygon(points=[/* 0*/ [sbr_chamfer*2, 0],
				                /* 1*/ [sbr_W-sbr_chamfer*2, 0],
				                /* 2*/ [sbr_W-sbr_chamfer, sbr_chamfer],
				                /* 3*/ [sbr_W-sbr_chamfer, sbr_F-sbr_l],
				                /* 4*/ [sbr_W, sbr_F-sbr_T],
				                /* 5*/ [sbr_W, sbr_F-sbr_chamfer],
				                /* 6*/ [sbr_W-sbr_chamfer, sbr_F],
				                /* 7*/ [sbr_chamfer, sbr_F],
				                /* 8*/ [0, sbr_F-sbr_chamfer],
				                /* 9*/ [0, sbr_F-sbr_T],
				                /*10*/ [sbr_chamfer, sbr_F-sbr_l],
				                /*11*/ [sbr_chamfer, sbr_chamfer]],
				        convexity=10);
				translate([sbr_W/2, hole_height, 0]) {
					circle(bearing_dia(sbr_bearing/2));
				}
			}
		}

		translate([sbr_W/2, hole_height-bearing_rod_dia(sbr_bearing)/2+sbr_x, 0]) {
			sbr_triangle_cutter(3*sbr_h1, 3*sbr_x, sbr_L*1.05);
		}

		translate([screw_offset_x, sbr_F+1, sbr_L/2-scree_offset_z]) {
			rotate([90, 0, 0])
				cylinder(sbr_l+1, sbr_S/2, sbr_S/2);
		}

		translate([screw_offset_x, sbr_F+1, -sbr_L/2+scree_offset_z]) {
			rotate([90, 0, 0])
				cylinder(sbr_l+1, sbr_S/2, sbr_S/2);
		}

		translate([sbr_W-screw_offset_x, sbr_F+1, sbr_L/2-scree_offset_z]) {
			rotate([90, 0, 0])
				cylinder(sbr_l+1, sbr_S/2, sbr_S/2);
		}

		translate([sbr_W-screw_offset_x, sbr_F+1, -sbr_L/2+scree_offset_z]) {
			rotate([90, 0, 0])
				cylinder(sbr_l+1, sbr_S/2, sbr_S/2);
		}

	}

	difference() {
		translate([sbr_W/2, hole_height, 0]) {
			linear_bearing(sbr_bearing);
		}
		translate([sbr_W/2, hole_height-bearing_rod_dia(sbr_bearing)/2+sbr_x, 0]) {
			sbr_triangle_cutter(3*sbr_h1, 3*sbr_x, sbr_L*1.05);
		}
	}

	translate([sbr_W/2, hole_height, bearing_length(sbr_bearing)/2 + circlip_thickness(sbr_clip)/2]) {
		internal_circlip(sbr_clip, 1);
	}

	translate([sbr_W/2, hole_height, -bearing_length(sbr_bearing)/2 - circlip_thickness(sbr_clip)/2]) {
		internal_circlip(sbr_clip, 1);
	}
}

module sbr_triangle_cutter(h1, x, height, center=true) {
	linear_extrude(height, center=center) {
		polygon(points=[[0, 0],
		                [3*h1/2, -3*x],
		                [-3*h1/2, -3*x]],
		        convexity=10);
	}
}
