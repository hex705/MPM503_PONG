import netP5.*;
import oscP5.*;



OscP5 osc;


int myListeningPort = 12001;

// Someone to talk to
NetAddress destination;
String destinationIP = "127.0.0.1"; // pong IP
int destinationPort =   12000;        // pong port

String playerAddressPattern = "/playerTwo";


// two variables;

String lastMove="";
String pongMove;




void setup() {

    size(255, 255); 
    
    
    osc = new OscP5(this, myListeningPort);

    destination = new NetAddress(destinationIP, destinationPort);


      //say hello
     println("digitalControl starting...");
  
     connectToPong();
     
     // instructions
     fill(255,0,0);
     textAlign(CENTER,CENTER);
     text ("digital\n\ns=up\nx=down\n\nc=connect",width/2,height/2);
  
  
}

void draw() {
    // get messages from arduino 
  
int playerMove = 0;
     if (keyPressed) {
      if (key == 's' || key == 'S')  { playerMove = 1;  println('s'); }
      if (key == 'x' || key == 'X')  { playerMove = -1; println('x'); }
      
      if (key == 'c' || key == 'C' ) connectToPong();
      
  
     // if (key == 'k' || key == 'K')  p.player[2].up();
     // if (key == 'm' || key == 'M')  p.player[2].down();
      
       sendOsc( playerMove );
      
      } // end if pressed
}

void oscEvent(OscMessage incoming) {
    // all the received messages come here
    println(incoming);
}

void sendOsc(int pm) {
    //create a message with a unique address pattern
  OscMessage myOutGoingMessage = new OscMessage( playerAddressPattern );  // starts with an ADDRESS PATTERN --> = / + any string you like
  
  // send myBallColor
  myOutGoingMessage.add( "DIGITAL" );   // 0
  myOutGoingMessage.add( pm );   // 1                              // add an int to the osc message
 
  osc.send( myOutGoingMessage, destination );  // actually do the sending
   
}



void connectToPong() {
  
    OscMessage myOutGoingMessage = new OscMessage( playerAddressPattern );
    osc.send( myOutGoingMessage, destination );  // actually do the sending

} 
