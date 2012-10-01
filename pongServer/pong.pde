
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



