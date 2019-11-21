// Watch Tower
// this object contains 2 seperate parts.
// part1: the bottom disk that holds the servo arm
// part2: the upper parts that mounts to part1, which holds the ultasonic sensor
// @author: Chaoneng Quan
// Watch tower bottom part that holds the servo arm

$fn = 100;

//servo arm 
servoArmL = 32 + 0.2; // 0.5 wiggle room
servoArmW = 7 + 0.1; // 0.1 wiggle room
servoArmThickness = 1.4 + 0.1; // 0.1 wiggle room
servoArmEdgeCircleD = 4 + 0.1; // 0.1 wiggle room

//disk
diskR = 20;
diskH = 3;
    

/**************************************Part 1************************************/
translate([0,0,5])difference(){ 
    cylinder(r=diskR, h=diskH);
    //center hole
    translate([0,0,-1]) cylinder(d=servoArmW,h=diskH+2);
    //servo arm shape polydron
    translate([0,0,diskH-servoArmThickness]) hull(){
    cylinder(d=servoArmW,h=servoArmThickness+1);
    translate([servoArmL/2 - servoArmEdgeCircleD/2,0,0]) cylinder(d=servoArmEdgeCircleD,h=servoArmThickness+1);
    translate([-(servoArmL/2 - servoArmEdgeCircleD/2),0,0]) cylinder(d=servoArmEdgeCircleD,h=servoArmThickness+1);
    }
    //cable passthrough cube
    cableCubeL = 15;
    cableCubeW = 4;
    cableCubeH = diskH;
    // 3mm away from the center hole
    translate([0,servoArmW/2 + 3, 0]) cube([cableCubeL,cableCubeW,cableCubeH*2+1],true);
    //a sphere shape cavity for opening 
    translate([diskR,0,0]) cube([4,diskR,diskH*2+1],true);
}

/**************************************Part 2************************************/
//lift up the top part for 20 units temproraliy

//center cable tube
tubeR = 15;
tubeH = 25;
// sensor
sensorL = 45.12+1;
sensorW = 20.64;
// sensor wall
//sensorWallThickness = SWT
SWT = 2;


translate([0,0,20]){
    difference(){
        //cap thickness
        capT = 3;
        union(){
            translate([0,0,-capT])cylinder(r=diskR+capT, h=diskH*2);
            // Center cable tube
            translate([0,0,diskH]) cylinder(r=tubeR,h=tubeH);
        }
        //cavity for center cable tube
        translate([0,0,-1])cylinder(r=tubeR-2,diskH+tubeH+1.1);
        translate([0,0,-capT-1])cylinder(r=diskR, h=diskH+1);
    }
}
    
/**************************************Part 2.1************************************/
//sensor cover

sensorCoverD = 50;
sensorCoverH = 25;
sensorCoverThickness = 2;

translate([0,0,20+SWT+tubeH]){
    
    difference(){
        cylinder(d=sensorCoverD+sensorCoverThickness, h=sensorCoverH + sensorCoverThickness - sensorCoverThickness);
        
        translate([0,0,sensorCoverThickness]) cylinder(d=sensorCoverD-2, h=sensorCoverH+1);
        //cable tube cavity
        translate([0,0,-1])cylinder(r=tubeR-SWT,h=sensorCoverThickness+2);
        
        translate([-sensorCoverD/2-3,-sensorCoverD/2-3,sensorCoverThickness]) cube([           sensorCoverD+6,sensorCoverD/2+3,sensorCoverH+1]);
    }
    //sensor Wall
    translate([-sensorL/2,sensorCoverThickness,sensorCoverThickness]) rotate([90,0,0])difference(){
        cube([sensorL,sensorW,SWT]);
        //two screw holes
        translate([1+2.25/2,1+2.25/2,-1]) cylinder(d=2.5,h=SWT+2);
        translate([sensorL-(1+2.25/2),sensorW-(1+2.25/2),-1]) cylinder(d=2.5,h=SWT+2);
        //cable pin cavity
        translate([sensorL/2,0,0]) cube([14,5,SWT*2+1],true); 
    }
    
    //sensor wall sides
    translate([-sensorL/2-2,sensorCoverThickness-2,sensorCoverThickness]) cube([2,2,sensorW]);
    translate([sensorL/2,sensorCoverThickness-2,sensorCoverThickness]) cube([2,2,sensorW]);
    // sensor face cover foundations
    
 
}

//sensor cylinder
sensorCylinderD = 16 + 0.5;

//Part 3.1 the sensor face cover
translate([0,0,20+SWT+tubeH+30]){
    
    
        difference(){
            cylinder(d=sensorCoverD+sensorCoverThickness, h=sensorCoverH +          sensorCoverThickness);
            translate([0,0,-1]) cylinder(d=sensorCoverD-2, h=sensorCoverH+1);
            translate([-sensorCoverD/2-sensorCoverThickness,0,-1])cube([sensorCoverD+sensorCoverThickness*2,(sensorCoverD+sensorCoverThickness)/2,sensorCoverH+1]);
            translate([0,0,-1]) cylinder(d=sensorCoverD+sensorCoverThickness+1, h=sensorCoverThickness+1);
            //sensor cylinders cavity
            translate([-sensorL/2 + 2.2 + sensorCylinderD/2,0,1.5+sensorCylinderD/2+sensorCoverThickness]) rotate([90,0,0])cylinder(d=sensorCylinderD,h=30);
            translate([sensorL/2 - 2.2 - sensorCylinderD/2,0,1.5+sensorCylinderD/2+sensorCoverThickness]) rotate([90,0,0])cylinder(d=sensorCylinderD,h=30);
        }  
        
        difference(){
            translate([0,0,sensorCoverH+SWT-5]) cylinder(d=sensorCoverD+sensorCoverThickness+5,h=5);
            translate([0,0,sensorCoverH+SWT-6]) cylinder(d=sensorCoverD+sensorCoverThickness+0.5,h=5);
        }
}

