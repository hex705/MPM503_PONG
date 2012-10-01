// pong v1.0
// Nov 26, 2011

//import processing.serial.*;
// import
import processing.net.*;
Server pongServer;

int serverPORT = 12345;

Scissors pongScissors;  // new scissors object



final int INTRO = 0;
final int PLAY  = 1;
final int WIN   = 2;
final int GOAL  = 3;

final int RALLY = 4;
final int SERVE = 5;
final int FLASH =6;
final int RESET =7;

final int AWAIT_PLAYERS = 8;
final int NUMBER_OF_PLAYERS = 9;

int STATE = 9;
int ROLL = 0;
int count =0;

Pong p;

// PFont f;
PFont scoreFont;
PFont alertFont;

boolean DEBUG = false;

int playerCount = 0;

void setup() {

  size(640, 480);
  background(0);

  pongServer   = new Server  ( this, serverPORT );
  pongScissors = new Scissors( pongServer       );  // pongServer is the Stream 

  String[] fontList = PFont.list();
 


  // http://www.fontpalace.com/font-download/OCR+A+Extended/
  scoreFont = loadFont( "OCRAExtended-128.vlw" );

  textFont ( scoreFont, 128);


  p = new Pong(2);

  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 9600);
}


void draw() {

  switch (STATE) {
    
    case NUMBER_OF_PLAYERS:
    
    textFont(scoreFont, 20);
    fill(0);
    noStroke();

    rect(190, 175, 400, 125);
    fill(255, 0, 0);

    text ("How many players?", 220, 200);
    textFont ( scoreFont, 128);


    if (keyPressed == true) { 
      println("key " + key);
      if (key > '0' && key < '3') {
        println("\t"+key);

       p = new Pong(key-48);
       
       STATE = AWAIT_PLAYERS;
      }
    }
    
    break;
    
  case AWAIT_PLAYERS:

      maintainScreen();
      displayWaitMessage();
      
      if (playerCount == 2)  {STATE = INTRO;}

  break;


  case INTRO:
  
    maintainScreen();

    textFont(scoreFont, 20);
    fill(0);
    noStroke();

    rect(190, 175, 400, 125);
    fill(255, 0, 0);

    text ("SELECT LEVEL: \n\r1) Super Simple\n\r2) Moderately Impossible\n\r3) Bone Crushing", 220, 200);
    textFont ( scoreFont, 128);


    if (keyPressed == true) { 
        println("key " + key);
      if (key > '0' && key < '9') {
        println("\t"+key);

        p.setSkill(key);
      }


      STATE = SERVE;
    }

    break ;

  case SERVE:
    p.serve();
    break;

  case RALLY:

    p.update();
    break;

  case GOAL:
    STATE = SERVE;
    delay(250);     
    break;

  case WIN:
    println("Player " + p.winner + " wins!!");
    STATE = FLASH;
    count = 0;
    break;

  case FLASH:

    color c;
    if ( count % 2 == 0 ) {
      c = color(255, 0, 0);
    } 
    else {
      c= color(255);
    }

    p.flashWinner( c );
    delay(300);
    count++;

    if (count >= 6) STATE = RESET;
    break;

  case RESET:
    p.gameReset();
    
    STATE = NUMBER_OF_PLAYERS;

    break;
  }// end switch
} // end draw 





void maintainScreen() {
 
      p.f.update();
      
      checkForServerInput();
     
      p.player[1].update();
      p.player[2].update();
      
      p.drawScore();
 
  
}


void displayWaitMessage() { 

  textFont(scoreFont, 20);
  fill(0);
  noStroke();

  rect(190, 175, 400, 100);
  fill(255, 0, 0);

  text ("Waiting for players", 220, 200);
  
  String cc = ( "\nCurrently " + playerCount + " connected.");
  text ( cc , 210, 220);
  textFont ( scoreFont, 128);
  
  
}


