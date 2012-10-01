class Ball{
  
  // instance variables
  
  float locX, locY;
  float velX, velY;
  int ballSize = 10;
  
  // constructor
  Ball(){
    
    locX = (int)random(0,width);
    locY = (int)random(0,height);
    velX = -0.00001;
    velY =  1;

  } // end constructor
  
 
  
  void update(){
     move();     // method in Ball class
     check();
     display();   
  }
  
  void move(){
    
    locX += velX;
    locY += velY;
    
  }// end move
  

  // checks for contact with wall and Paddle
  void check(){

    //check for a top of bottom
     if ( (locY < ( ballSize + 5)) || (locY > (height-ballSize-15)) ){
       velY *= -1;
       
     }
     
     if ((locX < -ballSize/2) || (locX > width+ballSize/2)) {
       p.goal(velX);
     }
    

  }// end check
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect ( locX, locY, ballSize, ballSize);
    rectMode(CORNER);
  } // end display
  
  
} // end Ball class
