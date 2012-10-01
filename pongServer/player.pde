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


