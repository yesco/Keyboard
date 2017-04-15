// constants
side_margin = 7.5;
hole_offset = 3.0;
height = 128.5;
hp_size = 5.08;
hole_diam = 3.2;
rail = 2 * hole_offset;
rail_depth = 6;

// material thickness
thickness = 3.175;
rail_tongues = 18;

function width(hp) = side_margin * 2 + hp * hp_size;


module around_box (height, width) {
    for (i=[0:$children-1]) {
        rotate([0, 0, -90 * i]) {
            translate([i == 1 ? -width : 0 + i == 2 ? -height : 0,
                       i == 2 ? -width : 0 + i == 3 ? -height : 0]) {
                children(i);
            }
        }
    }
}



module tongues(length, count, fitting, thickness) {
    margin = (length - (fitting * (2 * count - 1))) / 2;
    for (i=[0:count-1]) {
        translate([0, margin + i * 2 * fitting]) {
            square([thickness, fitting]);
        }
    }
}

module tongues_in(length, count, fitting, thickness) {
    if (count < 0) {
        tongues(length, - count, fitting, thickness);
    }
}

module tongues_out(length, count, fitting, thickness) {
    if (count > 0) {
        translate([-thickness, 0]) {
            tongues(length, count, fitting, thickness);
        }
    }
}



module puzzle (width, height, fitting, counts) {
    difference () {
        union () {
            square([width, height]);
            around_box(width, height) {
                tongues_out(height, counts[0], fitting, thickness);
                tongues_out(width, counts[1], fitting, thickness);
                tongues_out(height, counts[2], fitting, thickness);
                tongues_out(width, counts[3], fitting, thickness);
            }
        }
        around_box(width, height) {
                tongues_in(height, counts[0], fitting, thickness);
                tongues_in(width, counts[1], fitting, thickness);
                tongues_in(height, counts[2], fitting, thickness);
                tongues_in(width, counts[3], fitting, thickness);
        }
    }
}

module side(width, height, fitting, counts) {
    difference() {
        puzzle(width, height, fitting, counts);
        translate([0, -10]) {
            around_box(width, height) {
                square(0);
                tongues_out(width, rail_tongues, fitting, thickness);
                square(0);
                square(0);
            }
        }
    }
}

module rail_board(width, fitting, counts) {
    difference () {
        puzzle(width, rail, fitting, counts);
        for (i=[0:width/hp_size - 2]) {
            translate([6 + i * hp_size, 3]) {
                circle(d=hole_diam);
            }
        }
    }
}

module unit(hp, depth) {
    puzzle(hp * hp_size, height, rail, [5, 14, 5, 14]);
       translate([0, height + thickness * 2 + 5]) {
        side(hp * hp_size, depth, rail, [3, 0, 3, -14]);
        translate([0, depth + thickness * 2 + 5]) {
            side(hp * hp_size, depth, rail, [3, 0, 3, -14]);
            translate([0, depth + thickness * 2 + 5]) {
                puzzle(height + thickness * 2, depth, rail, [-3, 0, -3, -5]);
                translate([height + thickness * 3 + 5, 0]) {
                    puzzle(height + thickness * 2, depth, rail, [-3, 0, -3, -5]);
  
                }
                translate([0, depth + thickness * 2 + 5]) {
                    rail_board(hp * hp_size, rail, [0, rail_tongues, 0, 0]);
                    translate([0, rail + thickness + 5]) {
                        rail_board(hp * hp_size, rail, [0, rail_tongues, 0, 0]);
                    }
                }
            }
        }
    }
}

unit(48, 60);
