$fn=30;

r=9; // outer radius (thick end)
r1=7; // outer radius (thin end)
r2=1.25; // cable radius
r3=3.5; // larger cable radius to allow it to pass around pcb
r4=4; // radius of glue hole (approx, it projects beyond body)
l1=12; // length overlapping pcb
l2=4; // length projecting
l3=5; // length of internal cable/pcb overlap space - exlucdes rounded edges
l=l1+l2; // total length
t_pcb = 2; // thinkness of pcb
trap_angle = 74; // angle at trap end
e=0.1; // episilon

module wedge(ang) {
  // extrude an equilateral triangle with base of length 1 and opposite angle a
   x = (90-(ang/2));
   a = ang;
   b = tan(x)*0.5;    
   linear_extrude(1) polygon(points = [[0,0], [-0.5, b], [0.5, b]]);
}

difference() {
  // body
  cylinder(l,r1,r);
    
  // cable hole via projecting section
  translate([0,0,-1*e]) {
      cylinder(l2+2*e,r2,r2);
  }
  
  // wedge for PCB // 1 is pcb_thickness/2 so paramaterize that
  translate([0, t_pcb/2, l2]) {
      rotate([90,0,0]) {
        scale([2*l,2*l,t_pcb]) wedge(trap_angle);
      }
  }
  
  // make internal space for the cable to go under/over pcb
  translate([0,0,l2+2]) {
      #sphere(r3 );
      cylinder(l3,r3,r3);
  }
  translate([0,0,l2+2+l3]) #sphere(r3);

  // cable hole offset in overlapping section
  translate([0,t_pcb,l1]) cylinder(l1,r2,r2); 


  // glue injection hole
  translate([0,0,l1-1]) rotate([270,0,0]) #cylinder(r,0,r4);
  
  // for debugging - chop it in half
  // translate([-20,0,0]) cube([40,20,20]);
}


