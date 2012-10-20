void checkForKeyboardInput(){

  // check for input    
   if (keyPressed) {
      if (key == 'a' || key == 'A')  p.player[1].up();
      if (key == 'z' || key == 'Z')  p.player[1].down();
  if (p.players >=1){
      if (key == 'k' || key == 'K')  p.player[2].up();
      if (key == 'm' || key == 'M')  p.player[2].down();
  }
     if (key == 'r' || key == 'R') {
        p.softReset();
        STATE = INTRO;
       } 
      
   } // end if pressed
   
   
}  
