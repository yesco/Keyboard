// constants

thickness = 5.07; // material thickness
height = 120;
length = 260-2*thickness;
depth = 16+thickness;

// rail stuff
side_margin = 7.5;
hole_offset = 3.0;
hole_diam = 3.2;


rail_depth = 6;
rail_tongues = 12;

//rail = 2 * hole_offset;
rail = 2 * hole_offset;

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

module nothing() { square(0); }

module rect(width, heigth) { square([thickness, fitting]); }

module side(width, height, fitting, counts, bottomFit) {
  // This punches hole for the rail
//  difference() {
    puzzle(width, height, fitting, counts, bottomFit);
//    translate([0, -10]) {
//      around_box(width, height) {
//        nothing();
//        translate([0, 10]) {
//          square([2.64,100]);
//        //        tongues_out(width, rail_tongues, fitting, thickness);
//        }
//        nothing();
//        nothing();
//      }
//    }
//  }
}

module kbd_hole(depth) {
  translate([thickness*4, depth-thickness*1])
  color("red")
  square([100-3*thickness, 2.64]);
}

module unit(length, depth) {
   // bottom
   puzzle(length, height, rail, [5, 14, 5, 14]);

   // long sides
   translate([0, height + thickness*2 + 5]) {
     side(length, depth, rail, [1, 0, 1, -14], rail);

     translate([0, depth + thickness*2 + 5]) {
           difference() {
             side(length, depth, rail, [1, 0, 1, -14], rail);
             translate([0, depth-thickness*1.2])
               color("red")
                 square([length, thickness*2]);
           }

         // short sides
         translate([0, depth + thickness*2 - 5]) {
             difference() {
               puzzle(height + thickness*2, depth, rail, [-1, 0, -1, -5], rail);
               kbd_hole(depth);
             }

             translate([height + thickness * 2.5, 0]) {
                 difference() {
                   puzzle(height + thickness*2, depth, rail, [-1, 0, -1, -5], rail);
                   kbd_hole(depth);
                 }
             }
         }
      }
   }
}

unit(length, depth);
