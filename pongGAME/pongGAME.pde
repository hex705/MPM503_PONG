// pong v2.0
// August, 2013
// OSC based pong game

// TODO:
// add better check for hit.

// import the library -- install it if you don't have it

int maximumScore = 1;

import oscP5.*;
import netP5.*;

  
OscP5 oscP5;  // osc object
OscMessage currentMessage;



// listening
int iNet_myListeningPort  = 12000;  // port I am listening on 


final int INTRO = 0;
final int PLAY  = 1;
final int WIN   = 2;
final int GOAL  = 3;

final int RALLY = 4;
final int SERVE = 5;
final int FLASH = 6;
final int RESET = 7;

final int AWAIT_PLAYERS     = 8;
final int NUMBER_OF_PLAYERS = 9;

boolean playerOneConnected = false;
boolean playerTwoConnected = false;

int playerIndex = -1;
int playerMove = -1;
String playerType = "";

int STATE = 9;
int ROLL = 0;
int count =0;

Pong p;

// PFont f;
PFont scoreFont;
PFont alertFont;

boolean DEBUG = true;
int playerCount = 0;

void setup() {

  size(1024, 768);
  background(0);

  /* instantiate oscP5 object, listen for incoming messages at port 12000 */
  oscP5 = new OscP5(this, iNet_myListeningPort); 

  // http://www.fontpalace.com/font-download/OCR+A+Extended/
  
  scoreFont = loadFont( "OCRAExtended-128.vlw" );

  textFont ( scoreFont, 128);

   oscP5.plug(this,"playerOne","/playerOne");
   
   oscP5.plug(this,"playerTwo","/playerTwo");

   p = new Pong(1, maximumScore);

}


void draw() {

  switch (STATE) {
    
    case NUMBER_OF_PLAYERS:
    
      getNumberOfPlayers();  
    
    break;
    
    case AWAIT_PLAYERS:

      maintainScreen();
      displayWaitMessage();
      
      if (playerCount == p.players)  {STATE = INTRO;}

    break;


    case INTRO:
  
        maintainScreen();
        getSkillLevel();       

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
      
     // checkForServerInput();
     
      for (int i = 1; i <= p.players; i ++ ) {
          p.player[i].update();
      }
        
      p.drawScore();
  
}


void displayWaitMessage() { 

  textFont(scoreFont, 20);
  fill(0);
  noStroke();

  rect(width/2-100, height/2-50, 400, 150);
  fill(255, 0, 0);

  text ("Waiting for players", width/2, height/2+50);
  
  String cc = ( "\nCurrently " + playerCount + " connected.");
  text ( cc , width/2, 350);
  textFont ( scoreFont, 128);
  
  
}

void getNumberOfPlayers() { 
  fill(0);
    noStroke();
    rect(width/2-200, height/2-40, 400, 75);
    
    fill(255, 0, 0);
    textFont(scoreFont, 20);
    textAlign(CENTER,CENTER);
    text ("How many players?", width/2, height/2);
    textFont ( scoreFont, 128);
    textAlign(CENTER,LEFT);
    
    if (keyPressed == true) { 
      println("key " +  key);
      if (key > '0' && key < '3') {
        println("\t"+key);

       p = new Pong(key-48, maximumScore);
       
       STATE = AWAIT_PLAYERS;
      }
    }
}


void getSkillLevel(){
  
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
  
}



void keyPressed(){
 if (key=='r' || key == 'R'){
    STATE = RESET;
 } 
}
