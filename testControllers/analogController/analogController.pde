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




void setup() {

    size(255, 255); 
    
    
    osc = new OscP5(this, myListeningPort);

    destination = new NetAddress(destinationIP, destinationPort);


      //say hello
     println("analogControl starting...");
  
     connectToPong();
     
     // instructions
     fill(255,0,0);
     textAlign(CENTER,CENTER);
     text ("analog\n\npress and drag mouse\n up and down\n\nc=connect",width/2,height/2);
  
  
}

void draw() {
 

 ;; // nothing here -- we are looking for mouse dragged event   
}

void mouseDragged() {
  
  sendOsc( mouseY%255 ) ;  
  
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
