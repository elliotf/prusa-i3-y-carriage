da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

bed_side  = 220;
bed_holes = 209;
thickness = 6;

belt_holder_screw_spacing = 41;

bearing_spacing_x = 170;
bearing_spacing_y = 70;
bearing_length = 24;
bearing_width_at_depth = 10;
bearing_ziptie_spacing = 20;

translate([-bed_holes/2+0.48,-160.46,-thickness/2+0.5]) {
  //% import("i3-original.stl");
}

module y_carriage() {
  difference() {
    y_carriage_body();
    y_carriage_holes();
    material_shaving();
    wire_tiedowns();
  }
}

module y_carriage_body() {
  cube([bed_side,bed_side,thickness],center=true);
}

module y_carriage_holes() {
  //% translate([0,0,0.5]) y_carriage_body();
  // screw holes at corners
  for(x = [0,-bed_holes/2, bed_holes /2]) {
    for (y = [0,-bed_holes/2, bed_holes/2]) {
      translate([x,y,0]) {
        cylinder(r=3.2*da8,h=thickness+2,$fn=8,center=true);
      }
    }
  }

  // 4 bearing holes
  for (x=[-bearing_spacing_x/2,bearing_spacing_x/2]) {
    for (y=[-bearing_spacing_y/2,bearing_spacing_y/2]) {
      translate([x,y,0]) {
        bearing_hole();
      }
    }
  }

  // 3 bearing holes
  for (x=[-bearing_spacing_y/2,bearing_spacing_y/2]) {
    translate([x,bearing_spacing_x/2,0]) {
      rotate([0,0,90]) bearing_hole();
    }
  }
  translate([0,-bearing_spacing_x/2,0]) {
    rotate([0,0,90]) bearing_hole();
  }

  // y belt holder holes
  for (y=[-belt_holder_screw_spacing/2,belt_holder_screw_spacing/2]) {
    translate([0,y,0]) cylinder(r=3*da8,h=thickness+2,$fn=8,center=true);
    translate([y,0,0]) cylinder(r=3*da8,h=thickness+2,$fn=8,center=true);
  }
}

module bearing_hole() {
  cube([bearing_width_at_depth,bearing_length,thickness+2],center=true);
  for (x=[-bearing_ziptie_spacing/2,bearing_ziptie_spacing/2,0]) {
    translate([x,0,0]) cylinder(r=3*da8,h=thickness+2,$fn=8,center=true);
  }
}

module material_shaving() {
  for (x=[-bearing_spacing_x*0.28,bearing_spacing_x*0.28]) {
    translate([x,0,0]) material_hole();
    translate([0,x,0]) material_hole();
    for (y=[-1,1]) {
      translate([x,y*x,0]) scale([.6,.6,1]) material_hole();
    }
  }
  for (x=[-bearing_spacing_x*0.45,bearing_spacing_x*0.45]) {
    for (y=[-bearing_spacing_x*0.45,bearing_spacing_x*0.45]) {
      translate([x,y,0]) scale([.4,.4,1]) material_hole();
    }
  }

  // round corners
  for (x=[-bed_side/2,bed_side/2]) {
    for (y=[-bed_side/2,bed_side/2]) {
      translate([x,y,0]) rotate([0,0,45]) cube([5,5,thickness+2],center=true);
    }
  }
}

module material_hole() {
  intersection() {
    rotate([0,0,22.5]) cylinder(r=da8*bearing_spacing_x*0.25,$fn=8,h=thickness+2,center=true);
  }
}

module wire_tiedowns() {
  for (x=[-bed_holes/2+15,-15,15,bed_holes/2-15]) {
    for (y=[-.46,.46]) {
      translate([x,y*bed_side,0]) tiedown_holes();
    }
  }
  for (y=[-bed_holes/2+15,-15,15,bed_holes/2-15]) {
    for (x=[-.46,.46]) {
      translate([x*bed_side,y,0]) rotate([0,0,90]) tiedown_holes();
    }
  }
}

module tiedown_holes() {
  spacing = 7;
  for(x=[0]) {
    for(y=[-spacing/2,spacing/2]) {
      translate([x,y,0]) cylinder(r=3*da8,$fn=8,h=thickness+2,center=true);
    }
  }
}

//y_carriage_holes();
//y_carriage();
projection(cut=true) y_carriage();
