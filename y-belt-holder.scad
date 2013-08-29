da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

belt_tooth_distance = 2;
belt_tooth_ratio = 0.5;
belt_tooth_height = 2;

shaft_center_to_carriage = 30;
pulley_diam = 12;

pulley_to_carriage = shaft_center_to_carriage - pulley_diam/2;

mount_hole_distance = 41;
screw_diam = 3;
screw_nut_diam = 5.5;
screw_nut_depth = 2;
thickness = 3;
belt_width = 6;
belt_thickness = 1;

total_length = mount_hole_distance + screw_diam + thickness*2;
total_width = belt_width + thickness*2.5;
shoulder_height = thickness + screw_nut_depth;

excess_channel_height = pulley_to_carriage - shoulder_height - thickness;

total_height = pulley_to_carriage + thickness*2;
body_height = total_height - shoulder_height;
body_length = total_length - thickness*3 - screw_diam*2 - 1;

belt_cut_width = total_width - thickness;
belt_cut_y = (total_width-belt_cut_width)/-2-0.05;
belt_tooth_cut_height = belt_thickness + belt_tooth_height*2;

module holder_base() {
  // base
  translate([0,0,shoulder_height/2]) cube([total_length, total_width, shoulder_height],center=true);

  // clamp
  translate([0,0,shoulder_height+body_height/2])
    cube([body_length, total_width, body_height],center=true);

  // belt
  % translate([0,0,pulley_to_carriage]) cube([total_length*2,belt_width,belt_thickness],center=true);
}

module holder_holes() {
  for(side=[-1,1]) {
    // mount holes
    translate([side*mount_hole_distance/2,0,0]) {
      cylinder(r=screw_diam*da6,h=total_height*3,$fn=6,center=true);
      translate([0,0,shoulder_height])
        cylinder(r=screw_nut_diam*da6,h=screw_nut_depth*2,$fn=6,center=true);
    }
  }

  translate([0,belt_cut_y,pulley_to_carriage]) {
    // belt body
    cube([total_length+1,belt_cut_width,belt_thickness],center=true);

    // belt teeth
    for (x = [-15:15] ){
      translate([belt_tooth_distance/4 + x*belt_tooth_distance + 0.05,0,0])
        cube([belt_tooth_distance*belt_tooth_ratio,belt_cut_width,belt_tooth_cut_height],center=true);
    }

    // angled opening
    translate([0,-belt_cut_width/2+0.05,0]) rotate([45,0,0])
      cube([total_length+1,belt_tooth_cut_height+1,belt_tooth_cut_height+1],center=true);

  }

  translate([0,belt_cut_y-thickness/2,shoulder_height]) {
    // place to put excess belt
    translate([0,0,excess_channel_height/2+thickness-0.05])
      cube([6,belt_cut_width,excess_channel_height],center=true);
    translate([0,0,belt_width/2]) cube([6,total_width*2,belt_width],center=true);
  }

  // slim one side of clamp
  translate([0,-total_width/2,total_height/2]) cube([total_length+1,thickness+0.5,total_height+1],center=true);
}

module belt_holder() {
  difference() {
    holder_base();
    holder_holes();
  }
}

/*
intersection() {
  translate([0,0,total_width/2]) rotate([-90,0,0]) belt_holder();
  translate([0,total_height/1.25,0]) cube([20,20,60],center=true);
}
*/

module belt_holder_plate() {
  translate([0,0,total_width/2]) rotate([-90,0,0]) belt_holder();
}

belt_holder_plate();

//belt_holder();
