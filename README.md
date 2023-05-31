# ECE-385-Final-Project---Battle-City
This project was created as a final project for my Digital Systems class at UIUC. Me and partner built a multiplayer game on a FPGA called Battle City   The game drew inspiration from the original game of Battle tank 1990.
Through the course of this lab we aimed to build a retro game called Battle city which took inspiration from an original game of Battle Tanks 1990. It’s a multiplayer game which focuses on the fact that the two players will go around shooting each other with the multiple bullets that are there at their disposal with the tanks losing their health everytime a bullet touches them and the first the tank to lose all their health loses the game. The game at its basis is focused around VGA display and mixing game logic to plan and design the entire game. To start with the design, we started looking at lab 6.2 code and modified it to meet our requirements. We decided to plan our design to first focus on getting the game logic for one tank and then expand to the second player.

![newmenu](https://github.com/akshx-at/ECE-385-Final-Project---Battle-City/assets/90465922/99e6ef7b-0d48-4014-994e-618db5d396e4)
![Screenshot 2023-05-31 112625](https://github.com/akshx-at/ECE-385-Final-Project---Battle-City/assets/90465922/9fa444ef-06e8-4760-b7e6-38609e275b8a)

Our design is based on the SoC supported by a DE-10 Lite FPGA board. The physical movement and collision detection aspects of the game were handled by hardware modules defined in .sv files. The DE-10 board’s on-chip memory was used to store the attributes of tanks, obstacles and other sprites The NIOS II CPU was used to interface with the USB keyboard in order to access the standard gaming “WASD” keys for the first tank and then the ‘arrow’ keys for the second tank along with the spacebar and enter for firing bullets. The main point of interaction between the FPGA board and user controls were taken care of by the C code that was written to store the keycodes that came in and to display the characters and sprites on the monitor using a VGA cable.

## Key highlights of the Project : 
A few pictures from our hardware design : ![colormapperpic](https://github.com/akshx-at/ECE-385-Final-Project---Battle-City/assets/90465922/e0cc2126-4d5a-4b89-8e77-8479a16d36f7)

![top level](https://github.com/akshx-at/ECE-385-Final-Project---Battle-City/assets/90465922/89da22de-71aa-436d-8e16-8552793c3712)


<u>Multiple keycode Implementation: </u> Initially we had only 1 PIO block assigned to execute and process 1 keycode at a time. To move and shoot we would need 2 PIO blocks. So we added another PIO block in the
platform designer for this. After we added, we had to make slight modifications in the C
code to account for the extra keycode press. The change in the C code was in adding
another parameter setKeycode and getKeycode functions. After we instantiated those
changes onto our top level and we also made changes in our ball.sv file to take care of the
hierarchy of keycode presses. Once we got that to work, we were able to execute 2
keycode presses at the same time, which involved shooting and moving at the same time.

<u>Finite State Machiene:</u>
![Screenshot 2023-05-31 113310](https://github.com/akshx-at/ECE-385-Final-Project---Battle-City/assets/90465922/6e446f10-3424-4e70-a299-0407d9a392e3)

<u>Sprites:</u>  
The sprites played an important role in the aesthetics of our game. The sprites were generated
with the help of Ian’s shelper tool. We used the sprites for our tanks, background, main
menu, and end screen. The sprites were further integrated with an FSM to generate an
animation. The sprites were generated using a python script, where we entered the image
size along with the bit size to represent the number of colors that were present in the
image that we wanted to create the sprite into. An integral part of each sprite that we
made was to color each sprite background into hot pink so we could have sharp images of
the sprite. Once we put the image into the python script, we would get a color palette
.rom and .mif file which were used to print the sprite onto our screens. The .mif file was
used to specify the color index of each and every pixel that the sprite was going to cover.

<u>Collision detection: </u>
Collision detection was an integral part of our final project. It would not only
control the outcome of our game, but it was also necessary to maintain everything within
the bounds of the screen. As mentioned before, as a design choice we decided to
implement a bitmap instead of color values and coordinates for our collision detection.
We decided to use this because we felt we would not only get more precise results in
terms of collision detection but our code would also be much more efficient and neat.
Initially we created a map in terms of a sprite to generate blocks and boundaries. As we
generated a sprite for that, we got a .mif file for it which we modified for our needs.
Instead of using multiple integers to represent the different colors in our sprite, we
modified into 0’s and 1’s where 1 represented all the obstacles and 0’s represented the
free space for the tanks to move along. These values for individual pixels allowed us to
make our collisions to be very accurate. 

<u>Positive edge detector and slow clock: </u>
We ran into issues attempting to prevent multiple runs of an operation even if the
signal was triggered for a few microseconds, since some of our clocks run at speeds
greater than 25 MHz. Our design used an assortment of clock signals, including
VGA_VS (60 Hz), vga_clk (25 MHz) and MAX10_CLK1_50 (50 MHz). While these
clocks served most modules well, we had to generate a slow clock for certain instances
using a counter. These two basic hardware modules aided multiple aspects of our design.

<u>Random block generation: </u>
we decided to create an LFSR or linear feedback shift register to produce a
single pair of bits to generate the coordinates for one randomly placed power-up sprite.
An LFSR is a type of shift register that generates a pseudo-random sequence of binary
digits. It works by shifting the contents of a register by one bit at each clock cycle, and
then using a linear feedback function to determine the value of the input bit that will be
added to the register. The feedback function is typically implemented using XOR gates,
which take the outputs of certain taps in the register and perform an exclusive-or
operation on them to generate the feedback bit. Specific implementations of an LFSR
also rely on the various errors produced by flip flop race conditions as covered in the first
lab for ECE 385.

# Conclusion:
Through the course of this lab and class we were able to explore and design digital
systems. We were able to apply the concepts we learnt during the class in our final
project, Battle city. From the application of VGA to designing FSM’s of our project, we
were able to apply real life concepts into our project. This helped us gain deep insights
into good and bad digital designs and in the process it has made us better engineers. We
thoroughly enjoyed learning about the intricate details of these systems and how they can
be expanded to be applied to solve real life problems through a FPGA. In the process it
helped us develop design thinking, teamwork and application skills.
We were given the opportunity to interact with great TA’s and CA’s along the process
which helped us to complete the project in the given time frame. The class as a whole
was really well documented but we believe the addition of written quizzes would help the
students better understand the concept and the application of those concepts. Along the
process we encountered problems but while solving them we learnt more details about
the Quartus program.


