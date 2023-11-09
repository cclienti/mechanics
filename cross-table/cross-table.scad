include <../libraries/NopSCADlib/core.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>
include <../libraries/NopSCADlib/vitamins/rod.scad>
include <../libraries/NopSCADlib/vitamins/leadnuts.scad>
include <../libraries/NopSCADlib/vitamins/sk_brackets.scad>
include <../libraries/NopSCADlib/vitamins/bearing_blocks.scad>
include <../libraries/NopSCADlib/vitamins/extrusions.scad>
include <../libraries/NopSCADlib/vitamins/stepper_motors.scad>


include <../cnc/lib/fixed_bearings.scad>
include <../cnc/lib/sfu1605.scad>
include <../cnc/lib/ballscrew_mounts.scad>
include <../cnc/lib/sbr_rails.scad>
include <../cnc/lib/sbr_bearing_blocks.scad>

include <lib/layer_y_to_x.scad>


LAYER_Y_DEPTH = 300;
LAYER_Y_SCREW_OFFSET = 15-6;  //E3030/4 - 6mm (C2 in BK12 datasheet)
Y_POS = 129;  // 0 to 129

Y_TO_X_PLATE_OFFSET = (LAYER_Y_SCREW_OFFSET + bk_full_depth(BK12) -
                       sbr_bearing_block_length(SBR16UU)/3 + Y_POS);


module layer_y_strong_guide(length, pos, max_space=125) {
    RAIL_TYPE = SBR16RAIL;
    RAIL_WIDTH = sbr_rail_width(RAIL_TYPE);
    RAIL_OFFSET = sbr_rail_rod_center_height(RAIL_TYPE);

    BB_TYPE = SBR16UU;
    BB_LENGTH = sbr_bearing_block_length(BB_TYPE);

    DSG_LENGTH = ballscrew_mount_length(DSG16HH);
    BK_DEPTH = bk_full_depth(BK12);

    rotate([0, 0, 90]) sbr_rail(RAIL_TYPE, length);

    translate([0, Y_TO_X_PLATE_OFFSET, 0]) {
        translate([0, BB_LENGTH/2, RAIL_OFFSET]) {
            rotate([0, 0, 90]) sbr_bearing_block(BB_TYPE);
        }
        translate([0, max_space-BB_LENGTH/2, RAIL_OFFSET]) {
            rotate([0, 0, 90]) sbr_bearing_block(BB_TYPE);
        }
    }
}

module layer_y_screw(length, pos, max_space=125) {
    SFU_LENGTH = 250;
    BF_TYPE = BF12;
    BF_WIDTH = bf_width(BF_TYPE);
    BF_DEPTH = bf_depth(BF_TYPE);
    BF_Z_OFFSET = bf_ball_bearing_center(BF_TYPE);
    BF_Y_OFFSET = fixed_bearing_bf_ax+(BF_DEPTH-bf_ball_bearing_width(BF_TYPE))/2; //used for the rod

    BK_TYPE = BK12;
    BK_WIDTH = bk_width(BK_TYPE);
    BK_DEPTH = bk_full_depth(BK_TYPE);

    DSG_LENGTH = ballscrew_mount_length(DSG16HH);

    SFU_OFFSET = SFU_LENGTH-fixed_bearing_bk_offset+BK_DEPTH;

    echo("usable Y rod length",
         SFU_LENGTH-(fixed_bearing_bf_ax+fixed_bearing_bk_offset+bf_ball_bearing_width(BF_TYPE)/2));

    translate([-BF_WIDTH/2, SFU_OFFSET+BF_DEPTH-BF_Y_OFFSET+LAYER_Y_SCREW_OFFSET, 0]) {
        rotate([90, 0, 0]) {
            BFxx(BF_TYPE);
        }
    }

    translate([BK_WIDTH/2, LAYER_Y_SCREW_OFFSET, 0]) {
        rotate([90, 0, 180]) BKxx(BK_TYPE);
    }

    translate([0, LAYER_Y_SCREW_OFFSET, BF_Z_OFFSET]) rotate([0,0,90]) {
        translate([SFU_OFFSET, 0, 0]) rotate([0, 0, 180]) sfu1605(SFU_LENGTH);
        translate([pos + BK_DEPTH, 0, 0]) {
            translate([DSG_LENGTH, 0, 0]) rotate([0, 90, 0]) leadnut(SFU1610);
            rotate([0, 0, 0]) ballscrew_mount(DSG16HH);
       }

    }

    //translate([0, SFU_LENGTH+BF_Y_OFFSET+2, BF_Z_OFFSET]) rotate([90, 0, 0]) NEMA(NEMA23);
}

module layer_y_frame(length) {
    WIDTH = 600;
    SK_TYPE = SK16;
    SK_DEPTH = sk_size(SK_TYPE)[2];
    SK_WIDTH = sk_size(SK_TYPE)[0];
    SK_SCREW = sk_screw_separation(SK_TYPE);
	BK_HOLE_DIST = bk_hole_P(BK12);

    // Perpendicular profiles to ballscrew
    translate([WIDTH/2, 0, -15]) rotate([0, 90, 0]) {
        extrusion(E3060, WIDTH+60, cornerHole = true);
    }
    translate([WIDTH/2, length-15, -15]) rotate([0, 90, 0]) {
        extrusion(E3030, WIDTH+60, cornerHole = true);
    }

    // Parallel profiles to ballscrew (outer)
    translate([0, length/2, -15]) rotate([90, 90, 0]) {
        extrusion(E3060, length-60, cornerHole = true);
    }
    translate([WIDTH, length/2, -15]) rotate([90, 90, 0]) {
        extrusion(E3060, length-60, cornerHole = true);
    }

    // Parallel profiles to ballscrew (inner)
    translate([WIDTH/3, length/2, -15]) rotate([90, 90, 0]) {
        extrusion(E3060, length-60, cornerHole = true);
    }
    translate([2*WIDTH/3, length/2, -15]) rotate([90, 90, 0]) {
        extrusion(E3060, length-60, cornerHole = true);
    }

    // Support the BF12
    translate([WIDTH/2 - BK_HOLE_DIST/2, length/2, -15]) rotate([90, 0, 0]) {
        extrusion(E3030, length-60, cornerHole = true);
    }
    translate([WIDTH/2 + BK_HOLE_DIST/2, length/2, -15]) rotate([90, 0, 0]) {
        extrusion(E3030, length-60, cornerHole = true);
    }
}


module layer_x_strong_guide(max_space=300, layer_width=125) {
    SFU_LENGTH = 550;
    BF_TYPE = BF12;
    BF_WIDTH = bf_width(BF_TYPE);
    BF_DEPTH = bf_depth(BF_TYPE);
    BF_Z_OFFSET = bf_ball_bearing_center(BF_TYPE);
    BF_X_OFFSET = fixed_bearing_bf_ax+(BF_DEPTH-bf_ball_bearing_width(BF_TYPE))/2; //used for the rod

    BK_TYPE = BK12;
    BK_WIDTH = bk_width(BK_TYPE);
    BK_DEPTH = bk_full_depth(BK_TYPE);

    DSG_LENGTH = ballscrew_mount_length(DSG16HH);

    SFU_OFFSET = SFU_LENGTH-fixed_bearing_bk_offset+BK_DEPTH;

    translate([30, Y_TO_X_PLATE_OFFSET, 0]) sbr_rail(SBR16RAIL, 600);
    translate([30, Y_TO_X_PLATE_OFFSET+layer_width, 0]) sbr_rail(SBR16RAIL, 600);
    translate([0, Y_TO_X_PLATE_OFFSET+layer_width/2, BF_Z_OFFSET])  {
        translate([SFU_LENGTH, 0, 0]) {
            rotate([0, 0, 180]) sfu1605(SFU_LENGTH);
            translate([-BF_X_OFFSET, -BF_WIDTH/2, -BF_Z_OFFSET]) rotate([90, 0, 90]) {
                BFxx(BF_TYPE);
            }
        }
        translate([fixed_bearing_bk_offset-BK_DEPTH, -BK_WIDTH/2, -BF_Z_OFFSET]) rotate([90, 0, 90]) {
            BKxx(BK_TYPE);
        }
    }

}

translate([  0, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([200, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([400, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([600, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);

translate([300, 0, 0]) layer_y_screw(LAYER_Y_DEPTH, Y_POS);

color("LightBlue") layer_y_frame(LAYER_Y_DEPTH);

translate([-30, Y_TO_X_PLATE_OFFSET, 45]) layer_y_to_x();

translate([0, 0, 45+6]) layer_x_strong_guide();
