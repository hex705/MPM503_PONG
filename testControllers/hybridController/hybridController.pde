// create a variable that holds paddle position 
// use digital (or any combination of ) circuit inputs
// the circuit reading affects the position variable
// this variable is send in teh same way as an analog controller

import netP5.*;
import oscP5.*;

OscP5 osc;

int myListeningPort = 12001;

// Someone to talk to
NetAddress destination;
String destinationIP = "127.0.0.1"; // pong IP
int destinationPort =   12000;        // pong port

String playerAddressPattern = "/playerOne";


// two variables;

String lastMove="";
String pongMove;


int paddlePosition = 127 ;  // 255 = top of screen, 0 = bottom.

void setup() {

    size(255, 255); 
      
    osc = new OscP5(this, myListeningPort);

    destination = new NetAddress(destinationIP, destinationPort);

      //say hello
     println("hybridControl starting...");
  
     connectToPong();
     
     // instructions
     fill(255,0,0);
     textAlign(CENTER,CENTER);
     text ("hybrid\n\nq= big up\nz = big down\n w = small up\nx = small down\n\nc=connect",width/2,height/2);
 
}

void draw() {
 
   if (keyPressed) {
      if (key == 'q' || key == 'Q')  { paddlePosition -= 10;  println('q'); }
      if (key == 'z' || key == 'Z')  { paddlePosition += 10; println('z'); }
      
      if (key == 'w' || key == 'W')  { paddlePosition -= 1;  println('w'); }
      if (key == 'x' || key == 'X')  { paddlePosition += 1; println('x'); }
      
      if ( paddlePosition > 255) paddlePosition = 255;
      if ( paddlePosition < 0 ) paddlePosition = 0;
      sendOsc( paddlePosition );
      
    }
      
   
}


void oscEvent(OscMessage incoming) {
    // all the received messages come here
    println(incoming);
}

void sendOsc(int pm) {
    //create a message with a unique address pattern
  OscMessage myOutGoingMessage = new OscMessage( playerAddressPattern );  // starts with an ADDRESS PATTERN --> = / + any string you like
  
  // send myBallColor
  myOutGoingMessage.add( "ANALOG" );   // 0
  myOutGoingMessage.add( pm );   // 1                              // add an int to the osc message
 
  osc.send( myOutGoingMessage, destination );  // actually do the sending
   
}


void keyPressed(){
 if (key=='c' || key == 'C'){
    connectToPong();
 } 
}


void connectToPong() {
  
    OscMessage myOutGoingMessage = new OscMessage( playerAddressPattern );
    osc.send( myOutGoingMessage, destination );  // actually do the sending

} 
