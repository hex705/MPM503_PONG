Interfacing MPM503_PONG
=======================


---

NOTE -- when playing against self for development on a single machine

GAME IP will be local machine -->  "127.0.0.1"

GAME PORT is 12000  

This may change on game day.

---




1) The pong game interface is listening for connections via OSC.  You must connect to it at the **IP** and **PORT** given on game day.



2) You must send OSC messages with a specified /addressPattern, a string indicating controllerType and a controller value.


	  addressPattern ::   "/playerOne"  OR "/playerTwo"

	  controllerType ::   type String, content "DIGITAL"  or "ANALOG"

	  controller Value::  type Int,    content "your_controller_value" (see below)


###addressPattern

This element must be spelled exactly as you see here:

			/playerOne   or    /playerTwo

#####NOTE: /playerOne controls the left paddle, /playerTwo controls the right paddle.

###Controller Type


Determined by how you build your interface.

***DIGITAL***

If you make a controller that is based on 2 buttons (or similar), one for UP and one for DOWN.  Then your controller will be categorized as DIGITAL. 

In this situation, the first data added to EACH message will be a string indicating that you are DIGITAL:  

Case / spelling as you see here:

		DIGITAL


***ANALOG***

If you make a controller that is based on some kind of continuous variable (dial etc).  Then your controller will be categorized as ANALOG.


In this situation, the first data added to EACH message will be a string indicating that you are ANALOG:  

Case / spelling as you see here:
		
		ANALOG



### Controller Value

The values your controller needs to send:

***DIGITAL***

If your system is DIGITAL (as explained above) then you need to code such that you send the following to the PONG server:


    -1  if  DOWN is pressed
	 0  if  no buttons are pressed.
	 1  if  UP   is pressed
	
You will need to press your buttons more than once to move -- they do not repeat.


***ANALOG***

If your system is ANALOG (as explained above) then you need to send the sensor value as a number from 0-255 (8-bit).

	0 = top, 127 = middle, 255 = bottom.
	


One player or Two?
=================

While you are developing your controller you can choose the single player version.
 
When asked how many players, select 1 by making sure PONG is the focus window and then press <1>.
	
Now, connect your controller -- PONG will wait for you. (The demo controllers can be connected by pressing <c>)

Once you connect -- select your skill level.  We will play at skill level 1 in class.  Press 1, 2 or 3  -- and game will begin.


Notes:
======


The GAME code needs to be refactored -- so don't look at it as a good implementation -- the point of this exercise is your controller -- not my messy code. 

Depending on how fast our network connections are, you may be asked to add a delay in your controller.


HINT: faster baud (on the serial connection) will likely improve the responsiveness of your system -- i suggest 19200






