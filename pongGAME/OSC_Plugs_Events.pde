
void playerOne( String s, int val ) {
  
  playerIndex = 1;
  playerType = s;
  playerMove = val;
  
  if ( !playerOneConnected ) {
    
      playerCount++;
      playerOneConnected = true;
    } 
    
        if (DEBUG) {
          println("debug move playerOne");
        }

  doSomething();
}

void playerTwo( String s, int val ) {
  
    playerIndex = 2;
    playerType = s;
    playerMove = val;
  
  if ( !playerTwoConnected ) {
      playerCount++;
      playerTwoConnected = true;
    }
    
        if (DEBUG) {
      println("playerTwo");
    }
  
    doSomething();
}


/* incoming osc messages are forwarded to the oscEvent method. */
void oscEvent( OscMessage theOscMessage ) {
  println( " a message");
   if( theOscMessage.isPlugged()==false ) {
      println( " You onnected but are not plugged!  Check your addresspattern " ) ; 
      if (theOscMessage.addrPattern().equals("/playerOne")) {
        //connect playerOne
        println("player one is trying to connect");
        playerOne("CONNECT", 0);
      }
      
      if (theOscMessage.addrPattern().equals("/playerTwo")) {
        //connect playerTwo
        playerTwo("CONNECT", 0);
      }
      
   }
   
}

void doSomething() {
//  // get the player
//  //String whichPlayer = theOscMessage.addrPattern();
//
//  if (whichPlayer.equals("/playerOne") )
//  {
//    if ( !playerOneConnected ) {
//      playerCount++;
//      playerOneConnected = true;
//    }
//
//    playerIndex = 1;
//
//    if (DEBUG) {
//      println("playerOne");
//    }
//  }
//
//  else if (whichPlayer.equals("/playerTwo") )
//  {
//
//    if ( !playerTwoConnected ) {
//      playerCount++;
//      playerTwoConnected = true;
//    }
//
//    playerIndex = 2;
//    if (DEBUG)
//    {
//      println("playerTwo");
//    }
//  } 
//  else 
//  {
//    println("\t******   Address pattern error check syntax and spelling ****************");
//  }


  // determine the move
  if (playerIndex > 0 ) { // make sure we have a player

    println(playerMove);

    if (playerType.equals("DIGITAL")) {
      // digital stuff 

      switch ( playerMove ) {
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
        if ( DEBUG) {
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











//void checkForServerInput() {
//  
//
//  if (pongScissors.update() > 0) {  // returns number of elements in MESSAGE 
//       
//       int playerIndex = -1;  // must be playerOne  OR  playerTwo
//       int playerMove = 0;   // must be UP, DOWN, STOP
//      
//      // get the player
//         String whichPlayer = pongScissors.getString(0);
//         
//         if (whichPlayer.equals("/playerOne") )
//         {
//            playerIndex = 1;
//            if (DEBUG) {
//              println("playerOne");
//            }
//           
//         }
//
//         else if (whichPlayer.equals("/playerTwo") )
//         {
//           playerIndex = 2;
//           if (DEBUG)
//           {
//               println("playerTwo");
//           }
//      
//         } 
//         else 
//         {
//           println("\t******   Prefix error check syntax and spelling ****************");
//         }
//         
//       // determine the move
//       if (playerIndex > 0 ) { // make sure we have a player
//       
//       String playerType = pongScissors.getString(1);
//       playerMove = pongScissors.getInt(2);
//        
//       println(playerMove);
//       
//       if (playerType.equals("DIGITAL")) {
//        // digital stuff 
//        
//        switch ( playerMove) {
//         case -1:
//           // down
//           p.player[playerIndex].down(); 
//         
//         break;
//         
//         case 1:
//          // up
//          p.player[playerIndex].up();
//         
//         break;
//         
//         case 0:
//         
//         // hold in place
//         
//         
//         break;
//         default:
//         if( DEBUG) {
//            println("ERR::  invalid move");
//          }
//          break;
//          
//        } // end switch
//        
//       } // end if
//       
//       if (playerType.equals("ANALOG")) {
//         
//           p.player[playerIndex].setPaddleHeight( playerMove ) ;
//
//       }
//       
//  
//        
//       
//      
//        
//      }// end make sure player
//       
//  } // update -- did we get new info
//            
//  
//     
//   
//   
//} // end function

//
//void serverEvent (Server server, Client client) {
//  
//  
//    println ( "New Client Connected " + client.ip() );  // concatenate message
//    
//    
//    
//    playerCount ++;
//    
//    
//    
//  
//    // when a player connects add them to the field
//  
//  
//} // end event
