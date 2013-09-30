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


