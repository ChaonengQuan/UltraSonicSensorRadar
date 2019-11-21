// Arduino/Procesing coupling example. 
//
// This example demonstrates transmitting values through the
// serial port from Arduino to Processing, using comma-delimited
// values (CSV). 
//

import processing.serial.*;

// Serial port vairables. 
Serial myPort;  // Create object from Serial class
int val;        // Temporary variable storing data received from the serial port
// Array of x/y coordinates recieved over serial port.  Maximum number of recordings to store is MAX_RECORDINGS. 
int MAX_RECORDINGS =60;
int[][] data = new int[MAX_RECORDINGS][2];
int curDataIdx = 0;      // Index of array element that has highest populated value (-1)
// Font (for drawing text)
PFont fontA;
// Screenshot index (for taking screenshots). 
int screenshot_number = 0;


// Called whenever there is serial data available to read
void serialEvent(Serial port) {
  // Data from the Serial port is read in serialEvent() using the readStringUntil() function with * as the end character.
  String input = port.readStringUntil(char(10)); 
  if (input != null) {
    // Helpful debug message: Uncomment to print message received   
    println( "Receiving:" + input);
    input = input.trim();    
    int split_point = input.indexOf(',');
    if (split_point <= 0) return;        // If data does not contain a comma, then disregard it. 
      // Parse data
      // The data is split into an array of Strings with a comma or asterisk as a delimiter and converted into an array of integers.
      float[] vals = float(splitTokens(input, ","));
      int x = int(vals[0]);
      int y = int(vals[1]);
      // Store data
      data[curDataIdx][0] = x;
      data[curDataIdx][1] = y;
      // Increment index that we store new data at. 
      curDataIdx += 1;
      if (curDataIdx >= MAX_RECORDINGS) {
        curDataIdx = 0;
      }
      // Helpful debug message: Display serial data after parsing. 
      println ("Parsed x:" + x + "  y:" + y);
  }
}



/********************************** draw *******************/
void drawRadar() {
  strokeWeight(2);
  noFill();
  stroke(0,100,0); //color: darkgreen
  arc(0,0,800,800,PI,TWO_PI);
  arc(0,0,600,600,PI,TWO_PI);
  arc(0,0,400,400,PI,TWO_PI);
  arc(0,0,200,200,PI,TWO_PI);
  line(-500,0,500,0);
  line(0,0,-500*cos(radians(30)),-500*sin(radians(30)));
  line(0,0,-500*cos(radians(60)),-500*sin(radians(60)));
  line(0,0,-500*cos(radians(90)),-500*sin(radians(90)));
  line(0,0,-500*cos(radians(120)),-500*sin(radians(120)));
  line(0,0,-500*cos(radians(150)),-500*sin(radians(150)));
  line(-500*cos(radians(30)),0,500,0);
}


void drawLine() {
  stroke(124,252,0); //color lawngreen
  strokeWeight(3);
   for (int i=0; i<MAX_RECORDINGS; i++) {        
      int x = data[i][0];            // Grab x/y values from stored data
      int y = data[i][1];
      line(0,0,10*y*cos(radians(x)),-10*y*sin(radians(x))); // draws the line according to the angle
   }
}

void drawRedLine(){
   stroke(139,0,0); //color darkred
   strokeWeight(3);
   for (int i=0; i<MAX_RECORDINGS; i++) {        
      int x = data[i][0];            // Grab x/y values from stored data
      int y = data[i][1];
      if(y<400){
        line(10*y*cos(radians(x)),-10*y*sin(radians(x)), 800*cos(radians(x)), -800*sin(radians(x))); // draws the line according to the angle
      }
      String distance = y + "cm";
      text(distance, 450*cos(radians(x)), -450*sin(radians(x)));
   }
}

void drawText(){
  text("10cm",80,25);
  text("20cm",180,25);
  
  //for (int i=0; i<MAX_RECORDINGS; i++) {  
  //    int y = data[i][1];
  //     String prompt = "Distance to the object: " + y + "   cm";   
  //    text(prompt,-400, 25);
  //}
}
//***************************************************************/

// This function runs a single time after the program beings. 
void setup() {
  size(1000, 600);                    // Window size
  //colorMode(HSB, 255, 255, 255);     // Colour space    
  // Initialize Serial Port
  println ("Available Serial Ports:");
  println (Serial.list());                     // Display a list of ports for the user.  
  String portName = Serial.list()[3];          // Change the index (e.g. 1) to the index of the serial port that the Arduino is connected to.
  print ("Using port: ");                      // Display the port that we are using. 
  println(portName); 
  println("This can be changed in the setup() function.");
  myPort = new Serial(this, portName, 9600);   // Open the serial port. (note, the baud rate (e.g. 9600) must match                                             // the baud rate that the Arduino is transmitting at).
  // Initialize font
  fontA = createFont("Arial-black", 20);
  textFont(fontA, 12);
  // Initialize data array  (set all elements to zero). 
  for (int i=0; i<MAX_RECORDINGS; i++) {
    data[i][0] = 0;
    data[i][1] = 0;
  }  
}


// This function runs repeatedly, like the loop() function in the Arduino language. 
void draw() {
  background(0, 0, 0);             // Set background to white
  // At each iteration, draw the data currently specified in the 'data' array to the screen. 
  translate(500,525); // moves the starting coordinats to new location
  drawRadar();
  drawLine();
  drawRedLine();
  drawText();
  // Note: Serial data is updated in the background using the serialEvent() function above, so we don't 
  // have to explicitly look for it (or parse it here).
}
