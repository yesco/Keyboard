// constants

thickness = 5.07; // material thickness
kbdthick = 2.8;
kbdless = 2.64;

height = 130;
length = 260-2*kbdthick;
depth = 30+thickness;
addon = 15;

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

module lid (width, height) {
    difference () {
        square([width+thickness*3, height]);

        translate([0, thickness*6.0])
            square([thickness*1.5, height]);
        translate([width+thickness*1.5, thickness*6.0])
            square([thickness*1.5, height]);

        translate([0, 0])
            square([thickness*1.5, thickness*3.5]);
        translate([width+thickness*1.5, thickness*0])
            square([thickness*1.5, thickness*3.5]);
    }
}

module nothing() { square(0); }

module rect(width, heigth) { square([thickness, fitting]); }

module side(width, height, fitting, counts) {
  // This punches hole for the rail
//  difference() {
    puzzle(width, height, fitting, counts);
//    translate([0, -10]) {
//      around_box(width, height) {
//        nothing();
//        translate([0, 10]) {
//          square([kbdless,100]);
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
  square([100-3*thickness, kbdless]);
}

module slide_hole(depth) {
  translate([thickness*4, depth+addon-thickness*2]) {
    color("red")
    square([120-3*thickness, thickness]);
    color("cyan")
    translate([120-45, -20]) {
      translate([5, 10])square([15, 10]);
      rotate([0,0,-37]) square([thickness, 30]);
    }
    color("blue")
    translate([120-30, -20]) {
      translate([-3, 10])square([15, 10]);
      rotate([0,0,-30]) square([thickness, 30]);
    }
  }
}

module unit(length, depth) {
   // bottom
   puzzle(length, height, rail, [5, 14, 5, 14]);

   // long sides
   translate([0, height + thickness*2 + 5]) {
     side(length, depth, rail, [2, 0, 2, -14]);

     translate([0, depth + thickness*2 + 5]) {
           difference() {
             side(length, depth, rail, [2, 0, 2, -14]);
             translate([0, depth-thickness*1.2])
               color("red")
                 square([length, thickness*2]);
           }

         // short sides
         translate([0, depth + thickness*2 - 5]) {
             difference() {
               union() {
                 puzzle(height + thickness*2, depth, rail, [-2, 0, -2, -5], rail);
                 translate([thickness, 0])
                   square([height, depth+addon]);
               }
               kbd_hole(depth);
               slide_hole(depth);
             }

             translate([height + thickness * 2.5, 0]) {
                 difference() {
                   union() {
                     puzzle(height + thickness*2, depth, rail, [-2, 0, -2, -5], rail
);
                     translate([thickness, 0])
                       square([height, depth+addon]);
                 }

                   kbd_hole(depth);
                   slide_hole(depth);
                 }
             }
         }

         // lid
         translate([0, depth*3.5]) {
             lid(length, height, rail, [5, 14, 5, 14]);
         }
      }
   }
}

unit(length, depth);
