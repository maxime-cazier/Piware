This project is a video game prototype inspired by the ***WarioWare*** series, in which the player must complete a series of mini-games at an increasingly rapid pace.

This project is divided into two parts. The first part, located in the **PiServer** folder, is a **websocket server** that sends data from sensors connected to the machine's pin to the client while receiving commands to alter these components (in this case, diodes). This server has been tested on a **Raspberry Pi Zero 2 WH** with an **ultrasonic distance sensor**, **push buttons**, three **5k Ohm resistors** (used for the buttons to connect the pin to the 3.3V output), three **220-ohm resistors** (for the diodes), one **2k-ohm resistor** and one **1k-ohm resistor** (for the voltage divider bridge required to convert the 5V output of the ultrasonic sensor to the 3.3V required at the input of the Raspberry Pi pins) and **three diodes**. This part is used to control the game (like a controller with buttons and sensor).

The second part is in **Lua** and uses the **Love2d** framework. It is the part that contains the mini-games themselves.

The two instances communicate with each other via a **websocket protocol**

In **PiWare/config.lua**, it is possible to change the server's IP address, and in **PiServer/pin/pin.go**, it is possible to modify the pins associated with the controller.


It is advisable to arrange the buttons from left to right (as this is how they will be represented in the game).


**Installation and setup:**


**Server part:**


You must install the **Go compiler**: https://go.dev/

Then install the required packages listed in **go.mod**.


Once done, run the command `go run main.go` in the **PiServer** folder.


**Client part:**


You must install the **Love2d framework**: https://love2d.org/
This framework come with a **lua compiler** so it's not needed to install one

Once done, run the command `love .` in the **PiWare** folder after setting the server's IP address in **config.lua** and ran the server

**Credits:**

Inspired by the ***WarioWare*** series, a ***Nintendo*** series, all rights reserved
**Google Gemini 3.0** for AI assistance for the "draw" frunction of the client
**Google Nano Banana** for creating the Pin,Button,Spaceship,Asteroid,... images.
***Source of the font:*** https://www.dafont.com/grapesoda-2.font