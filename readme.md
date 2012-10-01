Interfacing MPM503_PONG
=======================

1) The pong game interface is a **SERVER**.  You must connect to it at the **IP** and **PORT** given on game day.



2) You must send messages with three **ELEMENTS**:

	They are whichplayer [0],  type of Controller [1],  value of your controller [2]

	  element[0]:  type String, content "playerOne"  OR "playerTwo"

	  element[1]:  type String, content "DIGITAL"  or "ANALOG"

	  element[3]:  type Int,    content "your_controller_value".


###element[0]


The content for this ELEMENT will be given to you at the moment you play.  You should be able to quickly switch players.


This element must be spelled exactly as you see here:

			playerOne   or    playerTwo


###element[1]


Determined by how you build your interface.

***DIGITAL***

If you make a controller that is based on 2 buttons (or similar), one for UP and one for DOWN.  Then your controller will be categorized as DIGITAL. 

In this situation, your second element ( index = 1 ) should tell PONG that you are DIGITAL:  

Case / spelling as you see here:

		DIGITAL


***ANALOG***

If you make a controller that is based on some kind of continuous variable (dial etc).  Then your controller will be categorized as ANALOG.


In this situation, your second element ( index = 1 ) should tell PONG that you are ANALOG:  

Case / spelling as you see here:
		
		ANALOG



element[3]
----------
The values your controller needs to send:

***DIGITAL***

If your system is DIGITAL (as explained above) then you need to code such that you send the following to the PONG server:


    -1  if  DOWN is pressed
	 0  if  no buttons are pressed.
	 1  if  UP   is pressed
	
You will need to press you buttons more than once to move -- they do not repeat.


***ANALOG***

If your system is ANALOG (as explained above) then you need to send the sensor value as a number from 0-255 (8-bit).

	0 = top, 127 = middle, 255 = bottom.
	


One player or Two?
=================

While you are developing your controller you can choose the single player version.
 
When asked how many players, select 1 by making sure PONG is the focus window and then press <1>.
	
Now, connect your client -- PONG will wait for you.

Once you connect -- select your skill level.  We will play at skill level 1 in class.  Press 1, 2 or 3  -- and game will begin.


Notes:
======


The code needs to be refactored -- so don;t look at it as a good implementation -- the point of this exercise is your controller -- not my messy code. 

Depending on how fast our network connections are, you may be asked to add a delay in your client.



HINT: faster baud will likely improve the responsiveness of your system -- i suggest 19200






