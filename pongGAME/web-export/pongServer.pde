// pong v1.0
// Sept 29, 2012

// add better check for hit.



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


  p = new Pong(1);

  //String portName = Serial.list()[0];
  //myPort = new Serial(this, portName, 9600);
}


void draw() {

  switch (STATE) {
    
    case NUMBER_OF_PLAYERS:
    
    textFont(scoreFont, 20);
    fill(0);
    noStroke();

    rect(190, 175, 400, 75);
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
      
      if (playerCount == p.players)  {STATE = INTRO;}

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
     
      for (int i = 1; i <= p.players; i ++ ) {
          p.player[i].update();
      }
  
      
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


import processing.net.* ;
import processing.serial.*;

class Scissors {
  
 // package variables
  char START_BYTE  =  '*' ;   //  42 = * 
  char DELIMITER   =  ',' ;   //  44 = ,  
  char END_BYTE    =  '#';   //  35 = # 
  char WHITE_SPACE =  ' ';   //  32 = ' ' 
  
  String TOKENS = new String( "" + START_BYTE + DELIMITER + END_BYTE);  // MAKE A STRING OF TOKENS
  
  String incomingData;
  String[] parsedData;
  
  int TYPE = -1;

  Server server;
  Client c;
  Serial s;

  
  boolean DEBUG = false;

  Scissors (Client _c ) {
       TYPE = 1; 
       c= _c;
    
  }
  
  Scissors (Serial _s) {
      TYPE = 2;
      s = _s;
  }

	Scissors (Server _server) {
      TYPE = 3;
      server = _server;
  }
  
  int update(){
	
		if (TYPE == 3 ) {
			// see if any clients have spoken to the server.
			  Client serverClient = server.available();

		      if (serverClient != null ) {
			
				incomingData = serverClient.readStringUntil( END_BYTE );
				
				if (DEBUG) {
					println("SERVER INCOMING data stream (raw)  " +incomingData);
				}
				
			    serverClient.clear();
		         
		      }  // if serverClient
		
		      
		
	    } // end type = 3
          
       
          if (TYPE == 1 ) {
              incomingData = c.readStringUntil( END_BYTE );
              if (DEBUG) {
              println("CLIENT INCOMING data stream (raw)  " +incomingData);
              }
          }  /// end type =2 
          
          
          if (TYPE == 2 ) {
              incomingData = s.readStringUntil( END_BYTE );
              if (DEBUG) {
              println("SERIAL data stream (raw)  " +incomingData);
              }
              
          }
        
        
          if( incomingData != null ){   // make sure you have something
          
            int startPos = incomingData.indexOf( START_BYTE );
            int endPos   = incomingData.indexOf( END_BYTE )  ;
            if (DEBUG) {
            println( "start " + startPos + " end " + endPos);
            }
            
                if ( ( startPos >= 0 ) && ( endPos > startPos ) ){ // make sure the something has a start and end
                 
                    incomingData = incomingData.substring(startPos,endPos);
                    parsedData = splitTokens( incomingData, TOKENS  ); 
                } 
                else {
                    if (DEBUG) {
                      println("incomplete message");
                    }
                     return -1;
                }
              
          } // end IF
          else {
            if(DEBUG) {
            println("Stream Error");
            }
            return -1;
          }
      
      
     if (TYPE == 1)  c.clear();
     if (TYPE == 2)  s.clear();
    
     
     return parsedData.length;
      
   }  // end read net packet
 
 
  String getString(int position) {
    return parsedData[position];
  } 
  
  float getFloat(int position) {
    return Float.parseFloat( parsedData[position] );
  } 
  
  int getInt(int position) {
    
    return Integer.parseInt( parsedData[position] );
  } 
 
  // getters and setters
  void setStartByte(char s) {
    START_BYTE = s;
  }
   void setEndByte(char e) {
     END_BYTE = e;
  }
   void setDelimiter(char d) {
     DELIMITER = d;
  }
 
 
  char getStartByte() {
      return START_BYTE;
  }
  
  char getEndByte() {
     return END_BYTE;
  }
  
  char getDelimiter() {
     return DELIMITER;
  }

  String getRaw() {
	      //println ("debug: " + incomingData);
	      return incomingData;
  }
  
  
} // end class
class Ball{
  
  // instance variables
  
  float locX, locY;
  float velX, velY;
  int ballSize = 10;
  
  // constructor
  Ball(){
    
    locX = (int)random(0,width);
    locY = (int)random(0,height);
    velX = 100;
    velY =  1;

  } // end constructor
  
 
  
  void update(){
   // println("Ball update");
     moveBall();     // method in Ball class
     check();
     display();   
  }
  
  void moveBall(){
    
    locX += velX;
    locY += velY;
    
  }// end move
  

  // checks for contact with wall and Paddle
  void check(){

    //check for a top of bottom
     if ( (locY < ( ballSize + 5)) || (locY > (height-ballSize-15)) ){
       velY *= -1;
       
     }
     
     // check for on goal line
     
    // if ((locX < - ballSize/2) || (locX > width+ballSize/2)) {
       //p.goal(velX);
    // }
    

  }// end check
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect ( locX, locY, ballSize, ballSize);
    rectMode(CORNER);
  } // end display
  
  
} // end Ball class

//
//Serial myPort;                       // The serial port
//int[] serialInArray = new int[3];    // Where we'll put what we receive
//int serialCount = 0;                 // A count of how many bytes we receive
//int lPos, rPos;		             // Starting position of the ball
//boolean firstContact = false;        // Whether we've heard from the microcontroller
//
//
//
//void serialEvent(Serial myPort) {
//  // read a byte from the serial port:
//  int inByte = myPort.read();
//  // if this is the first byte received, and it's an A,
//  // clear the serial buffer and note that you've
//  // had first contact from the microcontroller. 
//  // Otherwise, add the incoming byte to the array:
//  if (firstContact == false) {
//    if (inByte == 'A') { 
//      myPort.clear();          // clear the serial port buffer
//      firstContact = true;     // you've had first contact from the microcontroller
//      myPort.write('A');       // ask for more
//    } 
//  } 
//  else {
//    // Add the latest byte from the serial port to array:
//    serialInArray[serialCount] = inByte;
//    serialCount++;
//    
//  println(" \t\t\t\traw " + serialInArray[1]);
//  
//    // If we have 3 bytes:
//    if (serialCount > 2 ) {
//      p.player[1].setPaddleHeight ( (int) map (serialInArray[0],123,255,0,255) );
//      p.player[2].setPaddleHeight ( (int) map (serialInArray[1],124,238,0,255) );
//     
//
//      // Send a capital A to request new sensor readings:
//      myPort.write('A');
//      // Reset serialCount:
//      serialCount = 0;
//    }
//  }
//}

class Field{

  
  int numberPlayers;
  Ball ball;
  
  Field(int _pp, int s){
    
      numberPlayers = _pp;
      ball = new Ball();
      
      update();
        
      println("Field Inititalized");
  }
      
    
   void update(){
     
     drawField();
     if (numberPlayers == 2 ) {
     drawNet();
     }
      
      if (STATE != 8 && STATE != 0 && STATE != 9 ){ 
        ball.update();
      }
     
   }
   
   void drawField(){
     
      // redraw field -- background then filed then ball then players
     fill(0);
     strokeWeight(0);
     rect(-1,-1,width+1, height+1);


      switch (numberPlayers) {
       case 0:
        println("you have to have at least 1 player");
        break;
      
      case 1:
        drawSides(1,1,1,0);
        break;
      
      case 2:
        drawSides(1,0,1,0);
        break;   
      }
        
     
   }
   
   
          

  void drawSides(int t, int r, int b, int l){
     
     stroke (255);
     strokeWeight(10);
     strokeCap(PROJECT);
    
     if (t==1) line (10,10,width-10,10);
     if (r==1) line (width-10,10,width-10,height-10);
     if (b==1) line (width-10,height-10,10,height-10);
     if (l==1) line (10,height-10,10,10);
     
  }
 
 
 void drawNet(){
   
   strokeWeight(8);
   for (int i = 10; i < height-10; i += 10){   
     if (i % 20 == 0 )  line (width/2, i, width/2,i+3);
   }
   
 } // end draw net
  
}// end field


void checkForKeyboardInput(){

  // check for input    
   if (keyPressed) {
      if (key == 'a' || key == 'A')  p.player[1].up();
      if (key == 'z' || key == 'Z')  p.player[1].down();
  
      if (key == 'k' || key == 'K')  p.player[2].up();
      if (key == 'm' || key == 'M')  p.player[2].down();
   } // end if pressed
   
   
}  
class Player {
  
  int id=  0;
  int x = -10;
  int y =  0;
  int skillScale = 25;
  int skill;
  int score;
  
  Player(int _id, int _skill){
    
    id    = _id;
    println("skill scale in init " + skillScale);
    skill = _skill*skillScale;
        println("skill in init " + skill);
    if (id == 1) {
        x=30;
      } else {
        x=(width-30);
    }
    
    y = height/2 - skill/2;
   
    println("Player " + id + " created");
 
    
  } // end player constructor
  
 
  void setSkill(int s){
    switch (s) {
      case 1:
        s = 3;
      break;
   
      case 3:
       s =1;
      break;
    }
    
    skill = s * skillScale;
  }
  
  void update(){
    drawPaddle();
  }
  
  void drawPaddle(){
    drawPaddle(color(255));
  }
  
  void drawPaddle(color i ){
    stroke(i);
    strokeWeight(10);
    line (x,y,x,y+skill);
  
  }
  
  void up(){
    //println("up");
    y -= 10;
    if (y <= 10) y = 10;
  }
  
  void down(){
    y += 10;
    if (y >= height-10-skill) y = (height-10-skill);
  
  }
  
  void setPaddleHeight(int h){  // input can be 0 - 255
     y = (int) map (h,0,255, 10, height - ( skill+10 )); 
  }
  
  
  boolean hitTheBall(float ballY, int bSize) {
    boolean hit = false;
   // if ( (ballY+bSize/2 > y) && (ballY+bSize/2 < (y+skill) )) {
    if ( (ballY > y) && (ballY < (y+skill) )) {
      if (DEBUG) {
      println(" in player hittheball == yup its a hit");
      }
      hit = true;
    }

   return hit;
   
  }
  
  int getScore(){
    return score;
  }
  
  int getX(){
    return x;
  }
  
} // end player 



class Pong{

    Field f; 
    
    PFont scoreFont;

    
    int players = 1;
    Player[] player;
    int skillLevel = 3;
    
    boolean serve = true;
    int lastPoint = 1;
    int winner;
    int maxScore = 3;
    
    
    Pong(int _p){
      
      players = _p;
      f = new Field( players,1 );
      player = new Player[3];
      
      player[1] = new Player(1, skillLevel);
     
      if (players == 2) {
          player[2] = new Player(2, skillLevel);
      }
      
      gameReset();
      
      println("Game inititalized");
      
    }// end constructor

 
  void gameReset() {
    
    for (int i = 1; i <= players; i ++){
          player[i].score = 0;
    }
    
    ballReset();
    
    f.drawField();
    f.drawNet();
    
     for (int i = 1; i <= players; i ++ ) {
          player[i].update();
   
     }
    
    
    drawScore();
    
    STATE= 9;
    
    playerCount =0;
    
    
    
  }
  
  void serve(){ 
     ballReset();
     STATE = RALLY; 
  }
    
 void update(){
  checkForKeyboardInput();
  checkForServerInput();
   // update field
   f.update();
   
   
   // update players
   for (int i = 1; i <=players; i ++ ) {
       player[i].update();
   }
   //player[2].update();
   
   // check score
   checkForHit();
   checkForWin();
 
   drawScore();
   
 } // end update
  
  void drawScore(){
      
//textFont(scoreFont, 88);
     fill(255,0,0);
     
     if (players == 1) {
     
       String s = ("" + player[1].getScore() );
       text(s,505,115);
     
     }
     else if (players == 2) {
 
       String s = ( player[1].getScore()  + " " + player[2].getScore());
       text(s,205,105);
     }
    
  }

void checkForHit(){

   // println("checking");
   
   
   
    if (f.ball.locX-f.ball.ballSize/2  <= player[1].x) {
      
      if (player[1].hitTheBall(f.ball.locY, f.ball.ballSize) ) {
        f.ball.velX *= -1.1;
      } else {
        f.ball.locX = -5;
         goal(f.ball.velX);  // used to be in ball
      }
   }
     
   if (players == 2) {
     
     if (f.ball.locX+f.ball.ballSize/2 >=player[2].x) {
       
        if (player[2].hitTheBall(f.ball.locY, f.ball.ballSize) ) {
          f.ball.velX *= -1.1;
        } else {
        f.ball.locX = width +5;
        goal(f.ball.velX); // used to be in ball. 
      }
        
     }
    }
    
    if (players == 1 ) {
     if (f.ball.locX +f.ball.ballSize/2 >= width - 10) {
      // hit side
       f.ball.velX *= -1.3; 
    }
    }
            
 } // end checkForGoal 
 
 
 void goal(float vel) {
   int pointGetter = 1; 
   if (vel < 0  && players == 2 )  {
     pointGetter +=1; // if the ball was moving left then p 2 scored.
   }
    player[pointGetter].score+=1;
    lastPoint = pointGetter;
    STATE = GOAL;
  
 } // end goal
 
 void checkForWin(){
  // println("did i win");
   for(int i=1; i <=players; i++){
    // println("checking each player");
    // println(" a score " + player[i].getScore() );
     if ( player[i].getScore() >= maxScore) {
     //  println("we have a ner");
         winner = i;
         STATE = WIN;
     }//end if
   }// end for
 }// end check 
    
 
 void setSkill( int i ) {
   println("\t\tsetting skill on pong ... " + (i-48));
   for(int j = 1; j < players; j ++ ) {
     player[j].setSkill(i-48);
   }
 
     
 } // end set skill 
 
 void flashWinner(color c) {
   

       player[winner].drawPaddle( c );
 
   
 } // end flash 
 
 void setPlayerCount(int k){
      k = k - 48;
       
 }
 
  void ballReset() {
    println("last point " + lastPoint);
    int ballX = (lastPoint == 1) ? 40 : width-40;
    f.ball.locX = ballX;
    f.ball.locY = player[lastPoint].y+10;

    float vX = (lastPoint == 1) ? -2 : 2;
    f.ball.velX = vX;
    f.ball.velY = -0.5;    
  }
   
 
 
} // end game 




void checkForServerInput() {
  

  if (pongScissors.update() > 0) {  // returns number of elements in MESSAGE 
       
       int playerIndex = -1;  // must be playerOne  OR  playerTwo
       int playerMove =0;   // must be UP, DOWN, STOP
      
      // get the player
         String whichPlayer = pongScissors.getString(0);
         
         if (whichPlayer.equals("playerOne") )
         {
            playerIndex = 1;
            if (DEBUG) {
              println("playerOne");
            }
           
         }

         else if (whichPlayer.equals("playerTwo") )
         {
           playerIndex = 2;
           if (DEBUG)
           {
               println("playerTwo");
           }
      
         } 
         else 
         {
           println("\t******   Prefix error check syntax and spelling ****************");
         }
         
       // determine the move
       if (playerIndex > 0 ) { // make sure we have a player
       
       String playerType = pongScissors.getString(1);
        playerMove = pongScissors.getInt(2);
       
       if (playerType.equals("DIGITAL")) {
        // digital stuff 
        
        switch ( playerMove) {
         case -1:
           // down
           p.player[playerIndex].down(); 
         
         break;
         
         case 1:
          // up
          p.player[playerIndex].up();
         
         break;
         
         case 0:
         
         // hold in place
         
         
         break;
         default:
         if( DEBUG) {
            println("ERR::  invalid move");
          }
          break;
          
        } // end switch
        
       } // end if
       
       if (playerType.equals("ANALOG")) {
         
           p.player[playerIndex].setPaddleHeight( playerMove ) ;

       }
       
  
        
       
      
        
      }// end make sure player
       
  } // update -- did we get new info
            
  
     
   
   
} // end function


void serverEvent (Server server, Client client) {
  
  
    println ( "New Client Connected " + client.ip() );  // concatenate message
    
    
    
    playerCount ++;
    
    
    
  
    // when a player connects add them to the field
  
  
} // end event



