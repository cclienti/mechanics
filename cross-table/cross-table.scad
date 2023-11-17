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
include <lib/profile_connector.scad>
include <lib/drill_press_plate.scad>
include <lib/layer_x_connector.scad>


LAYER_Y_DEPTH = 300;
LAYER_Y_SCREW_OFFSET = 15-6;  //E3030/4 - 6mm (C2 in BK12 datasheet)
Y_POS = 120;  // 0 to 129
X_POS = -70;  // -70 to 320

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


module layer_x_strong_guide(x_pos=150, max_space=300, x_offset=-5, bk_x_offset=2.5, layer_width=125) {
    RAIL_LENGTH = 650;
    SFU_LENGTH = 550;
    BF_TYPE = BF12;
    BF_WIDTH = bf_width(BF_TYPE);
    BF_DEPTH = bf_depth(BF_TYPE);
    BF_Z_OFFSET = bf_ball_bearing_center(BF_TYPE);
    BF_X_OFFSET = fixed_bearing_bf_ax+(BF_DEPTH-bf_ball_bearing_width(BF_TYPE))/2; //used for the rod

    BK_TYPE = BK12;
    BK_WIDTH = bk_width(BK_TYPE);
    BK_DEPTH = bk_full_depth(BK_TYPE);

    BB_LENGTH = sbr_bearing_block_length(SBR16UU);

    DSG_LENGTH = ballscrew_mount_length(DSG16HH);

    SFU_OFFSET = SFU_LENGTH-fixed_bearing_bk_offset+BK_DEPTH;

    translate([x_offset, 0, 0]) {
        translate([30-50, Y_TO_X_PLATE_OFFSET, 0]) sbr_rail(SBR16RAIL, RAIL_LENGTH);
        translate([30-50, Y_TO_X_PLATE_OFFSET+layer_width, 0]) sbr_rail(SBR16RAIL, RAIL_LENGTH);
        translate([bk_x_offset, Y_TO_X_PLATE_OFFSET+layer_width/2, BF_Z_OFFSET])  {
            translate([SFU_LENGTH, 0, 0]) {
                rotate([0, 0, 180]) sfu1605(SFU_LENGTH);
                translate([-BF_X_OFFSET, -BF_WIDTH/2, -BF_Z_OFFSET]) rotate([90, 0, 90]) {
                    BFxx(BF_TYPE);
                }
            }
            translate([RAIL_LENGTH/2-125+x_pos, 0, 0]) {
                rotate([0, 90, 0]) leadnut(SFU1610);
                rotate([180, 180, 0]) ballscrew_mount(DSG16HH);
                translate([-DSG_LENGTH/2-125+BB_LENGTH/2, -layer_width/2, 0]) sbr_bearing_block(SBR16UU);
                translate([-DSG_LENGTH/2-125+BB_LENGTH/2,  layer_width/2, 0]) sbr_bearing_block(SBR16UU);
                translate([-DSG_LENGTH/2,                 -layer_width/2, 0]) sbr_bearing_block(SBR16UU);
                translate([-DSG_LENGTH/2,                  layer_width/2, 0]) sbr_bearing_block(SBR16UU);
                translate([-DSG_LENGTH/2+125-BB_LENGTH/2, -layer_width/2, 0]) sbr_bearing_block(SBR16UU);
                translate([-DSG_LENGTH/2+125-BB_LENGTH/2,  layer_width/2, 0]) sbr_bearing_block(SBR16UU);
            }

            translate([fixed_bearing_bk_offset-BK_DEPTH, -BK_WIDTH/2, -BF_Z_OFFSET]) rotate([90, 0, 90]) {
                BKxx(BK_TYPE);
            }
        }
    }
}

module top_support() {
    length = 350;
    translate([length/2, 105+25+30, 15]) rotate([90, 0, 90]) extrusion(E3060, length, cornerHole = true);
    translate([length/2, 60+25+30, 0]) rotate([0, 90, 0]) extrusion(E3060, length, cornerHole = true);
    translate([length/2, 25+30, 0]) rotate([0, 90, 0]) extrusion(E3060, length, cornerHole = true);
    translate([-6, 25, 15]) rotate([0, 90, 0]) profile_connector_E30x150();
    translate([length, 25, 15]) rotate([0, 90, 0]) profile_connector_E30x150();

}

translate([  0, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([200, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([400, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);
translate([600, 0, 0]) layer_y_strong_guide(LAYER_Y_DEPTH, Y_POS);

translate([300, 0, 0]) layer_y_screw(LAYER_Y_DEPTH, Y_POS);

color("LightBlue") layer_y_frame(LAYER_Y_DEPTH);


translate([0, 0, 45+6]) layer_x_strong_guide(X_POS);

translate([-30, Y_TO_X_PLATE_OFFSET, 45]) layer_y_to_x();
translate([X_POS+2.5+25, Y_TO_X_PLATE_OFFSET-50/2, 45+6+45]) layer_x_connector();
translate([X_POS+2.5+25, Y_TO_X_PLATE_OFFSET-50/2, 45+6+45+6+15]) top_support();

translate([-36, -30, 0]) rotate([0, 90, 0]) profile_connector_E30x150();
translate([630, -30, 0]) rotate([0, 90, 0]) profile_connector_E30x150();
translate([-36, LAYER_Y_DEPTH-150, 0]) rotate([0, 90, 0]) profile_connector_E30x150();
translate([630, LAYER_Y_DEPTH-150, 0]) rotate([0, 90, 0]) profile_connector_E30x150();

translate([-30, -30, -36]) rotate([0, 0, 0]) profile_connector_E60x120();
translate([-30, LAYER_Y_DEPTH-120, -36]) rotate([0, 0, 0]) profile_connector_E60x120();
translate([570, -30, -36]) rotate([0, 0, 0]) profile_connector_E60x120();
translate([570, LAYER_Y_DEPTH-120, -36]) rotate([0, 0, 0]) profile_connector_E60x120();

translate([170, -30, -36]) {
    drill_press_plate();
    translate([260/2, 330/2+15, -170]) cylinder(500, r=2.5);
}
