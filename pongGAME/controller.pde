
// test tab to ensure serial connections could work -- but it  is
// not written in OSC you will have to make the connection VIA inet


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

