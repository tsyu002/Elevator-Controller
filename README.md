# Elevator-Controller
Elevator Controller Implemented on FPGA (VHDL)

In Collaboration with Viet-Huy Nguyen

The design was implemented on a Digilent Basys 3 Artix-7 FPGA

•	The elevator controller designed is capable of traveling from floors 1 to 9. 
•	A floor request can be made from within the elevator (FS). 
•	A request to go up can be made from floors 1 through 8 (ER).
•	A request to go down can be made from floors 2 through 9 (ER).

•	The current floor will be displayed on the right most position of the seven-segment display.

•	Two LED’s are used in the design.
  o	When LDO is lit, the elevator is traveling up
  o	When LD1 is lit, the elevator is traveling down
  o	When both LED’s are lit, the elevator is stopped at a floor
  
•	Five push buttons are utilized in the design
  o	BTNL is used as a reset, where the elevator will immediately go to floor 1 and reset all pending requests
  o	BTNC is used to send the floor select when on the elevator
  o	BTNR is used as a stop, where the elevator will suspend travel and stop at the next floor
  o	BTND is used when on a floor and requesting to go down
  o	BTNU is used when on a floor and requesting to go up
  
•	Eight toggles are used in the design
  o	SW0 to SW3 are used to represent the floor number (in binary representation) requested when in the elevator
    	SW0 for 0
    	SW1 for 2
    	SW2 for 4
    	SW8 for 8
  o	SW12 to SW15 are used to represent the floor (in binary representation) that an up or down request is made from
    	SW12 for 0
    	SW13 for 2
    	SW14 for 4
    	SW15 for 8
    
•	Functionality of the up and down movement of the elevator was proven by visually inspecting whether the LED’s corresponding to the directions were lit
•	Functionality of the current floor was shown using the seven-segment display
•	The reset feature was validated through whether the seven-segment display changed to represent floor 1.
•	The stop feature was shown through whether the seven-segment display showed the elevator to stop on the next floor when the elevator was in motion. Additionally, the LED’s were inspected to ensure that the elevator was no longer moving up or down.

•	Additionally a test bench was written with 6 different cases to simulate the design
  o	Test 1: Go to floor 5 from floor 1
  o	Test 2: Up request from floor 2 while elevator is on floor 5
  o	Test 3: Go to floor 9 from floor 2,  Up request from floor 6 after delay
  o	Test 4: Down request from floor 3. Up request made from floor 4 after delay
  o	Test 5: Go to floor 8. After delay send stop request. After second delay cancel stop request
  o	Test 6: Reset request is sent
