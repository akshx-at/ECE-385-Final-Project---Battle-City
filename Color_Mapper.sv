//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

//4'h7, 4'h4, 4'h5 ... remove from explosion!

module  color_mapper (input [9:0] DrawX, DrawY, 

							input [9:0] T1Bullet1X, T1Bullet1Y, T1Bullet1S, T1bullet1flag,
							input [9:0]	T1Bullet2X, T1Bullet2Y, T1Bullet2S, T1bullet2flag,
							input [9:0] T1Bullet3X, T1Bullet3Y, T1Bullet3S, T1bullet3flag,
							
							input [9:0] T2Bullet1X, T2Bullet1Y, T2Bullet1S, T2bullet1flag,
							input [9:0]	T2Bullet2X, T2Bullet2Y, T2Bullet2S, T2bullet2flag,
							input [9:0] T2Bullet3X, T2Bullet3Y, T2Bullet3S, T2bullet3flag,
							
							input logic vga_clk, blank, game_on, explosion1_on, explosion2_on, death_screenP1, death_screenP2,
							input logic tank1spritedetector, tank2spritedetector,
							input logic tank1gaya, tank2gaya,
							input logic [5:0] healthoftank1, healthoftank2,
							
							input [1:0] tank1_Direction, tank2_Direction,
							input [9:0] tankX, tankY, tank_size,
							input [9:0] tank2X, tank2Y, tank2_size,
							
							input logic [2:0] CM_sprite_signal,
							
							input logic [19:0] randcoordwire,
							input logic obstacle_EN, reset,
							output logic [7:0] Red, Green, Blue,
							output logic LEDOut, LEDOut8, tank1shieldacquired, tank2shieldacquired
							);
   
//    logic ball_on;
//logic flag_LED; // FOR LED CHECKS

// CLOCK VARIABLES SET
logic negedge_vga_clk;
assign negedge_vga_clk = ~vga_clk;

//int tank1health, tank2health; // does typecasting like this work?


////////////////////////////////////////////////////////////////////////////////////
////////////////////////MENU SCREEN/////////////////////////////////////////////////
logic [14:0] rom_address_p1;

logic [1:0] rom_q_p1;

logic [3:0] palette_red_p1, palette_green_p1, palette_blue_p1;

assign rom_address_p1 = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);

p1win_rom p1win_rom (

              .clock   (negedge_vga_clk),

              .address (rom_address_p1),

              .q       (rom_q_p1)

);

 

p1win_palette p1win_palette (

              .index (rom_q_p1),

              .red   (palette_red_p1),

              .green (palette_green_p1),

              .blue  (palette_blue_p1)

);

/////////////////////////////////////////////

logic [14:0] rom_address_p2;

logic [1:0] rom_q_p2;

logic [3:0] palette_red_p2, palette_green_p2, palette_blue_p2;

assign rom_address_p2 = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);

p2win_rom p2win_rom (

              .clock   (negedge_vga_clk),

              .address (rom_address_p2),

              .q       (rom_q_p2)

);

 

p2win_palette p2win_palette (

              .index (rom_q_p2),

              .red   (palette_red_p2),

              .green (palette_green_p2),

              .blue  (palette_blue_p2)

);

////////////////////////////////////////////

//logic [14:0] rom_address_menu2;
//
//logic [1:0] rom_q_menu2;
//
//logic [3:0] palette_red_menu2, palette_green_menu2, palette_blue_menu2;
//
//assign rom_address_menu2 = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);
//
//menu2_rom menu2_rom (
//
//              .clock   (negedge_vga_clk),
//
//              .address (rom_address_menu2),
//
//              .q       (rom_q_menu2)
//
//);
//
// 
//
//menu2_palette menu2_palette (
//
//              .index (rom_q_menu2),
//
//              .red   (palette_red_menu2),
//
//              .green (palette_green_menu2),
//
//              .blue  (palette_blue_menu2)
//
//);

////////////////////////////////////

logic [14:0] rom_address_menu1;

logic [1:0] rom_q_menu1;

logic [3:0] palette_red_menu1, palette_green_menu1, palette_blue_menu1;

assign rom_address_menu1 = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);

menu1_rom menu1_rom (

              .clock   (negedge_vga_clk),

              .address (rom_address_menu1),

              .q       (rom_q_menu1)

);

 

menu1_palette menu1_palette (

              .index (rom_q_menu1),

              .red   (palette_red_menu1),

              .green (palette_green_menu1),

              .blue  (palette_blue_menu1)

);


//////////////////////////////////////////////////////
///////////////////MAP GENERATOR SEGEMENT/////////////
//////////////////////////////////////////////////////

//logic [19:0] walls [15];								  
//logic [3:0] i;
//								  
//								  
//always_ff @(posedge vga_clk) begin
//	
//	if (reset) begin
//		for (i = 4'd0; i < 4'd15; i++) begin
//			walls[i] <= 20'd0;
//			LEDOut8 = 1'b1;	
//		end
//	end
//		
//	if (obstacle_EN) begin 
//		
//		for (i = 4'd0; i < 4'd15; i++) begin
//		
//			if (walls[i] == 20'd0) walls[i] <= randcoordwire;
//			
//		end
//	end
//
//end


///////////////////////////////// TANK 1 ///////////////////////////////////////

	 logic T1bullet1_on;
	 logic T1bullet2_on;
	 logic T1bullet3_on;
	 
	 
	 logic tank_on_up;
	 logic tank_on_down;
	 logic tank_on_left;
	 logic tank_on_right;

//********************************************************************
// tank_up
	logic [9:0] rom_address_up;
	logic [2:0] rom_q_up;
	logic [3:0] palette_red_up, palette_green_up, palette_blue_up;
	assign rom_address_up = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);
	
	final_tank_up_rom final_tank_up_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_up),
	.q       (rom_q_up)
);

	final_tank_up_palette final_tank_up_palette (
	.index (rom_q_up),
	.red   (palette_red_up),
	.green (palette_green_up),
	.blue  (palette_blue_up)
);
//********************************************************************
//tank_down
logic [9:0] rom_address_down;
logic [3:0] rom_q_down;
logic [3:0] palette_red_down, palette_green_down, palette_blue_down;
assign rom_address_down = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_down_rom final_tank_down_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_down),
	.q       (rom_q_down)
);

final_tank_down_palette final_tank_down_palette (
	.index (rom_q_down),
	.red   (palette_red_down),
	.green (palette_green_down),
	.blue  (palette_blue_down)
);
//********************************************************************
//tank_left
logic [9:0] rom_address_left;
logic [3:0] rom_q_left;
logic [3:0] palette_red_left, palette_green_left, palette_blue_left;
assign rom_address_left = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_left_rom final_tank_left_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_left),
	.q       (rom_q_left)
);

final_tank_left_palette final_tank_left_palette (
	.index (rom_q_left),
	.red   (palette_red_left),
	.green (palette_green_left),
	.blue  (palette_blue_left)
);
//********************************************************************
//tank_right
logic [9:0] rom_address_right;
logic [3:0] rom_q_right;
logic [3:0] palette_red_right, palette_green_right, palette_blue_right;
assign rom_address_right = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_right_rom final_tank_right_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_right),
	.q       (rom_q_right)
);

final_tank_right_palette final_tank_right_palette (
	.index (rom_q_right),
	.red   (palette_red_right),
	.green (palette_green_right),
	.blue  (palette_blue_right)
);
/////////////////////////////////Alternating sprites//////////////////

logic [9:0] rom_address_alt_up;
logic [3:0] rom_q_alt_up;
logic [3:0] palette_red_alt_up, palette_green_alt_up, palette_blue_alt_up;
assign rom_address_alt_up = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_up2_1_rom final_tank_up2_1_rom (
	.clock   (~vga_clk),
	.address (rom_address_alt_up),
	.q       (rom_q_alt_up)
);

final_tank_up2_1_palette final_tank_up2_1_palette (
	.index (rom_q_alt_up),
	.red   (palette_red_alt_up),
	.green (palette_green_alt_up),
	.blue  (palette_blue_alt_up)
);

///////////////////////////////
logic [9:0] rom_address_alt_down;
logic [3:0] rom_q_alt_down;
logic [3:0] palette_red_alt_down, palette_green_alt_down, palette_blue_alt_down;
assign rom_address_alt_down = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_down2_1_rom final_tank_down2_1_rom (
	.clock   (~vga_clk),
	.address (rom_address_alt_down),
	.q       (rom_q_alt_down)
);

final_tank_down2_1_palette final_tank_down2_1_palette (
	.index (rom_q_alt_down),
	.red   (palette_red_alt_down),
	.green (palette_green_alt_down),
	.blue  (palette_blue_alt_down)
);

/////////////////////////////////
logic [9:0] rom_address_alt_left;
logic [3:0] rom_q_alt_left;
logic [3:0] palette_red_alt_left, palette_green_alt_left, palette_blue_alt_left;
assign rom_address_alt_left = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_left2_1_rom final_tank_left2_1_rom (
	.clock   (~vga_clk),
	.address (rom_address_alt_left),
	.q       (rom_q_alt_left)
);

final_tank_left2_1_palette final_tank_left2_1_palette (
	.index (rom_q_alt_left),
	.red   (palette_red_alt_left),
	.green (palette_green_alt_left),
	.blue  (palette_blue_alt_left)
);

///////////////////////////////////////
logic [9:0] rom_address_alt_right;
logic [3:0] rom_q_alt_right;
logic [3:0] palette_red_alt_right, palette_green_alt_right, palette_blue_alt_right;
assign rom_address_alt_right = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

final_tank_right2_1_rom final_tank_right2_1_rom (
	.clock   (~vga_clk),
	.address (rom_address_alt_right),
	.q       (rom_q_alt_right)
);

final_tank_right2_1_palette final_tank_right2_1_palette (
	.index (rom_q_alt_right),
	.red   (palette_red_alt_right),
	.green (palette_green_alt_right),
	.blue  (palette_blue_alt_right)
);



////////////////////// TANK 2/////////////////////////////////////////////////

	logic tank2_on_up;
	logic tank2_on_down;
	logic tank2_on_left;
	logic tank2_on_right;
	
	logic T2bullet1_on;
	logic T2bullet2_on;
	logic T2bullet3_on;

//********************************************************************
// tank2_up
	logic [9:0] rom_address_up2;
	logic [2:0] rom_q_up2;
	logic [3:0] palette_red_up2, palette_green_up2, palette_blue_up2;
	assign rom_address_up2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);
	
final_tank_up_rom final_tank2_up_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_up2),
	.q       (rom_q_up2)
);

	final_tank_up_palette final_tank2_up_palette (
	.index (rom_q_up2),
	.red   (palette_red_up2),
	.green (palette_green_up2),
	.blue  (palette_blue_up2)
);
//********************************************************************
//tank2_down
logic [9:0] rom_address_down2;
logic [3:0] rom_q_down2;
logic [3:0] palette_red_down2, palette_green_down2, palette_blue_down2;
assign rom_address_down2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_down_rom final_tank2_down_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_down2),
	.q       (rom_q_down2)
);

final_tank_down_palette final_tank2_down_palette (
	.index (rom_q_down2),
	.red   (palette_red_down2),
	.green (palette_green_down2),
	.blue  (palette_blue_down2)
);
//********************************************************************
//tank2_left
logic [9:0] rom_address_left2;
logic [3:0] rom_q_left2;
logic [3:0] palette_red_left2, palette_green_left2, palette_blue_left2;
assign rom_address_left2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_left_rom final_tank2_left_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_left2),
	.q       (rom_q_left2)
);

final_tank_left_palette final_tank2_left_palette (
	.index (rom_q_left2),
	.red   (palette_red_left2),
	.green (palette_green_left2),
	.blue  (palette_blue_left2)
);
//********************************************************************
//tank2_right
logic [9:0] rom_address_right2;
logic [3:0] rom_q_right2;
logic [3:0] palette_red_right2, palette_green_right2, palette_blue_right2;
assign rom_address_right2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_right_rom final_tank2_right_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_right2),
	.q       (rom_q_right2)
);

final_tank_right_palette final_tank2_right_palette (
	.index (rom_q_right2),
	.red   (palette_red_right2),
	.green (palette_green_right2),
	.blue  (palette_blue_right2)
);

//////////////////////////////////////////////////////////////////////APPLIED
/////////////////////////////////Alternating sprites//////////////////FOR TANK 2
//////////////////////////////////////////////////////////////////////AS OF NOW

logic [9:0] rom_address_alt_up2;
logic [3:0] rom_q_alt_up2;
logic [3:0] palette_red_alt_up2, palette_green_alt_up2, palette_blue_alt_up2;
assign rom_address_alt_up2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_up2_1_rom final_tank_up2_1_rom2 (
	.clock   (~vga_clk),
	.address (rom_address_alt_up2),
	.q       (rom_q_alt_up2)
);

final_tank_up2_1_palette final_tank_up2_1_palette2 (
	.index (rom_q_alt_up2),
	.red   (palette_red_alt_up2),
	.green (palette_green_alt_up2),
	.blue  (palette_blue_alt_up2)
);

///////////////////////////////
logic [9:0] rom_address_alt_down2;
logic [3:0] rom_q_alt_down2;
logic [3:0] palette_red_alt_down2, palette_green_alt_down2, palette_blue_alt_down2;
assign rom_address_alt_down2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_down2_1_rom final_tank_down2_1_rom2 (
	.clock   (~vga_clk),
	.address (rom_address_alt_down2),
	.q       (rom_q_alt_down2)
);

final_tank_down2_1_palette final_tank_down2_1_palette2 (
	.index (rom_q_alt_down2),
	.red   (palette_red_alt_down2),
	.green (palette_green_alt_down2),
	.blue  (palette_blue_alt_down2)
);

/////////////////////////////////
logic [9:0] rom_address_alt_left2;
logic [3:0] rom_q_alt_left2;
logic [3:0] palette_red_alt_left2, palette_green_alt_left2, palette_blue_alt_left2;
assign rom_address_alt_left2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_left2_1_rom final_tank_left2_1_rom2 (
	.clock   (~vga_clk),
	.address (rom_address_alt_left2),
	.q       (rom_q_alt_left2)
);

final_tank_left2_1_palette final_tank_left2_1_palette2 (
	.index (rom_q_alt_left2),
	.red   (palette_red_alt_left2),
	.green (palette_green_alt_left2),
	.blue  (palette_blue_alt_left2)
);

///////////////////////////////////////
logic [9:0] rom_address_alt_right2;
logic [3:0] rom_q_alt_right2;
logic [3:0] palette_red_alt_right2, palette_green_alt_right2, palette_blue_alt_right2;
assign rom_address_alt_right2 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);

final_tank_right2_1_rom final_tank_right2_1_rom2 (
	.clock   (~vga_clk),
	.address (rom_address_alt_right2),
	.q       (rom_q_alt_right2)
);

final_tank_right2_1_palette final_tank_right2_1_palette2 (
	.index (rom_q_alt_right2),
	.red   (palette_red_alt_right2),
	.green (palette_green_alt_right2),
	.blue  (palette_blue_alt_right2)
);


//*****************************************************



///////////////// OTHER SPRITES //////////////////////////////////////////


//logic [8:0] rom_address_brick;
//logic [8:0] rom_address_brick2;
//logic [2:0] rom_q_brick;
//logic [3:0] palette_red_brick, palette_green_brick, palette_blue_brick;
//assign rom_address_brick = ((DrawX) + (DrawY * 40));
//assign rom_address_brick2 = ((randx) + (randy * 40));
//
//brickwall1_rom brickwall1_rom (
//	.clock   (negedge_vga_clk),
//	.address (rom_address_brick),
//	.q       (rom_q_brick)
//);
//
//brickwall1_palette brickwall1_palette (
//	.index (rom_q_brick),
//	.red   (palette_red_brick),
//	.green (palette_green_brick),
//	.blue  (palette_blue_brick)
//);

//////////////////////////////////
//logic [8:0] rom_address_grass;
//logic [2:0] rom_q_grass;
//logic [3:0] palette_red_grass, palette_green_grass, palette_blue_grass;
//assign rom_address_grass = ((DrawX) + ((DrawY * 40)));
//grass_sprite_rom grass_sprite_rom (
//	.clock   (negedge_vga_clk),
//	.address (rom_address_grass),
//	.q       (rom_q_grass)
//);
//
//grass_sprite_palette grass_sprite_palette (
//	.index (rom_q_grass),
//	.red   (palette_red_grass),
//	.green (palette_green_grass),
//	.blue  (palette_blue_grass)
//);
////////////////////////////////////////////
//logic [14:0] rom_address_bk;
//logic [1:0] rom_q_bk;
//logic [3:0] palette_red_bk, palette_green_bk, palette_blue_bk;
//assign rom_address_bk = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);
//
//basebackground_rom basebackground_rom (
//	.clock   (~vga_clk),
//	.address (rom_address_bk),
//	.q       (rom_q_bk)
//);
//
//basebackground_palette basebackground_palette (
//	.index (rom_q_bk),
//	.red   (palette_red_bk),
//	.green (palette_green_bk),
//	.blue  (palette_blue_bk)
//);
//////////////////////////////////////
// obstacle

//logic [18:0] rom_address_obstacle;
//logic [1:0] rom_q_obstacle;
//logic [3:0] palette_red_obstacle, palette_green_obstacle, palette_blue_obstacle;
//assign rom_address_obstacle = ((DrawX * 340) / 640) + (((DrawY * 240) / 480) * 340);
//bk_obstacle1_rom bk_obstacle1_rom (
//	.clock   (negedge_vga_clk),
//	.address (rom_address_obstacle),
//	.q       (rom_q_obstacle)
//);
//
//bk_obstacle1_palette bk_obstacle1_palette (
//	.index (rom_q_obstacle),
//	.red   (palette_red_obstacle),
//	.green (palette_green_obstacle),
//	.blue  (palette_blue_obstacle)
//);

//////////////////////////////////////////////////////////////////////////////////// FINALIZED MAP 1
logic [16:0] rom_address_obstacle;
logic [1:0] rom_q_obstacle;
logic [3:0] palette_red_obstacle, palette_green_obstacle, palette_blue_obstacle;

assign rom_address_obstacle = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
finalmap_rom finalmap_rom (
	.clock   (~vga_clk),
	.address (rom_address_obstacle),
	.q       (rom_q_obstacle)
);

finalmap_palette finalmap_palette (
	.index (rom_q_obstacle),
	.red   (palette_red_obstacle),
	.green (palette_green_obstacle),
	.blue  (palette_blue_obstacle)
);

///////////////////////////////////////////////////////////////////////////////////// RANDOM MENU 1

logic [16:0] rom_address_menu;
logic [2:0] rom_q_menu;
logic [3:0] palette_red_menu, palette_green_menu, palette_blue_menu;
assign rom_address_menu = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);

menu_rom menu_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_menu),
	.q       (rom_q_menu)
);

menu_palette menu_palette (
	.index (rom_q_menu),
	.red   (palette_red_menu),
	.green (palette_green_menu),
	.blue  (palette_blue_menu)
);




////////////////////////////////////////////
logic [9:0] rom_address_explosion1;
logic [2:0] rom_q_explosion1;
logic [3:0] palette_red_explosion1, palette_green_explosion1, palette_blue_explosion1;

assign rom_address_explosion1 = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);


explosion_2_rom explosion_2_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_explosion1),
	.q       (rom_q_explosion1)
);

explosion_2_palette explosion_2_palette (
	.index (rom_q_explosion1),
	.red   (palette_red_explosion1),
	.green (palette_green_explosion1),
	.blue  (palette_blue_explosion1)
);



/////////////////////////////////////////////////
logic [9:0] rom_address_explosion2;
logic [2:0] rom_q_explosion2;
logic [3:0] palette_red_explosion2, palette_green_explosion2, palette_blue_explosion2;

assign rom_address_explosion2 = ((DrawX - tankX)) + (((DrawY - tankY )) * 32);

explosion_3_rom explosion_3_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address_explosion2),
	.q       (rom_q_explosion2)
);

explosion_3_palette explosion_3_palette (
	.index (rom_q_explosion2),
	.red   (palette_red_explosion2),
	.green (palette_green_explosion2),
	.blue  (palette_blue_explosion2)
);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////

logic [9:0] rom_address_explosion21;
logic [2:0] rom_q_explosion21;
logic [3:0] palette_red_explosion21, palette_green_explosion21, palette_blue_explosion21;

assign rom_address_explosion21 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);


explosion_2_rom explosion_2_rom21 (
	.clock   (negedge_vga_clk),
	.address (rom_address_explosion21),
	.q       (rom_q_explosion21)
);

explosion_2_palette explosion_2_palette21 (
	.index (rom_q_explosion21),
	.red   (palette_red_explosion21),
	.green (palette_green_explosion21),
	.blue  (palette_blue_explosion21)
);


///////////////////////////////////////////////////////////////////////////////////////////////////////////////

logic [9:0] rom_address_explosion22;
logic [2:0] rom_q_explosion22;
logic [3:0] palette_red_explosion22, palette_green_explosion22, palette_blue_explosion22;

assign rom_address_explosion22 = ((DrawX - tank2X)) + (((DrawY - tank2Y )) * 32);


explosion_3_rom explosion_2_rom22 (
	.clock   (negedge_vga_clk),
	.address (rom_address_explosion22),
	.q       (rom_q_explosion22)
);

explosion_3_palette explosion_2_palette22 (
	.index (rom_q_explosion22),
	.red   (palette_red_explosion22),
	.green (palette_green_explosion22),
	.blue  (palette_blue_explosion22)
);



/////////////////////////////////////////////
// DISTANCE VARIABLES //
/////////////////////////////////////////////




	 ///////*********TANK1 BULLETS************/////
	 
	 logic [9:0] tankDistX, tankDistY, tankSize;
	 assign tankDistX = DrawX - tankX;
	 assign tankDistY = DrawY - tankY;
	 assign tankSize = tank_size;
	 
	 int DistBullet1T1X, DistBullet1T1Y, Bullet1T1Size;
	 assign DistBullet1T1X = DrawX - T1Bullet1X;
    assign DistBullet1T1Y = DrawY - T1Bullet1Y;
    assign Bullet1T1Size = T1Bullet1S;
	 
	 int DistBullet2T1X, DistBullet2T1Y, Bullet2T1Size;
	 assign DistBullet2T1X = DrawX - T1Bullet2X;
    assign DistBullet2T1Y = DrawY - T1Bullet2Y;
    assign Bullet2T1Size = T1Bullet2S;
	 
	 int DistBullet3T1X, DistBullet3T1Y, Bullet3T1Size;
	 assign DistBullet3T1X = DrawX - T1Bullet3X;
    assign DistBullet3T1Y = DrawY - T1Bullet3Y;
    assign Bullet3T1Size = T1Bullet3S;
	 
	 ///////*********TANK2 BULLETS************/////
	 
	 logic [9:0] tank2DistX, tank2DistY, tank2Size;
	 assign tank2DistX = DrawX - tank2X;
	 assign tank2DistY = DrawY - tank2Y;
	 assign tank2Size = tank2_size;
	 
	 int DistBullet1T2X, DistBullet1T2Y, Bullet1T2Size;
	 assign DistBullet1T2X = DrawX - T2Bullet1X;
    assign DistBullet1T2Y = DrawY - T2Bullet1Y;
    assign Bullet1T2Size = T2Bullet1S;
	 
	 int DistBullet2T2X, DistBullet2T2Y, Bullet2T2Size;
	 assign DistBullet2T2X = DrawX - T2Bullet2X;
    assign DistBullet2T2Y = DrawY - T2Bullet2Y;
    assign Bullet2T2Size = T2Bullet2S;
	 
	 int DistBullet3T2X, DistBullet3T2Y, Bullet3T2Size;
	 assign DistBullet3T2X = DrawX - T2Bullet3X;
    assign DistBullet3T2Y = DrawY - T2Bullet3Y;
    assign Bullet3T2Size = T2Bullet3S;
	 
	 
	 int DistshieldX, DistshieldY, DistshieldS;
	 assign DistshieldX = DrawX - randx;
	 assign DistshieldY = DrawY - randy;
	 assign DistshieldS = 20;
	 
	 
	 ////////////////MORE SPRITES////////////////////////
	 
	 
//	 int T1Explosion1X, T1Explosion1;
//	 assign T1Explosion1X = DrawX - tankX;
//    assign T1Explosion1Y = DrawY - tankY;
////    assign T1Explosion1S = tank_size; 
//	 
//	 int T1Explosion2X, T1Explosion2Y;
//	 assign T1Explosion2X = DrawX - tankX;
//    assign T1Explosion2Y = DrawY - tankY;
////    assign T1Explosion2S = tank_size;
	 
	 logic t1explosion1, t1explosion2, t2explosion1, t2explosion2;
	 
	 
	 always_comb
	 begin:explosion11
	 
	 if ( tankDistX < tankSize && tankDistY < tankSize ) t1explosion1 = 1'b1;
	 
	 else t1explosion1 = 1'b0;
	 
	 end
	 
	 
	 always_comb
	 begin:explosion12
	 
	 if ( tankDistX < tankSize && tankDistY < tankSize ) t1explosion2 = 1'b1;
	 
	 else t1explosion2 = 1'b0;
	 
	 end
	 
	 ///////
	 
	 always_comb
	 begin:explosion21
	 
	 if ( tank2DistX < tank2Size && tank2DistY < tank2Size ) t2explosion1 = 1'b1;
	 
	 else t2explosion1 = 1'b0;
	 
	 end
	 
	 
	 always_comb
	 begin:explosion22
	 
	 if ( tank2DistX < tank2Size && tank2DistY < tank2Size ) t2explosion2 = 1'b1;
	 
	 else t2explosion2 = 1'b0;
	 
	 end
	 

	
	 always_comb
	 begin:tank1_ON_HAI_LAUDA

      if ( tankDistX < tankSize && tankDistY < tankSize && !tank1gaya)
		  begin
			tank_on_down = 1'b0;
			tank_on_right = 1'b0;
			tank_on_left = 1'b0;
			tank_on_up = 1'b0;

				if(tank1_Direction == 2'b00)
				tank_on_up = 1'b1;
				else if(tank1_Direction == 2'b10)
				tank_on_down = 1'b1;
				else if(tank1_Direction == 2'b01)
				tank_on_left = 1'b1;
				else
				tank_on_right = 1'b1;
		  end
		
		
		else
			begin
				tank_on_down = 1'b0;
				tank_on_right = 1'b0;
				tank_on_left = 1'b0;
				tank_on_up = 1'b0;
			end
				
	end
		  
	///////////////////////////////////////////////////////////////////////////////////
	  
    always_comb
    begin: t1b1		
		  if ( DistBullet1T1X*DistBullet1T1X + DistBullet1T1Y*DistBullet1T1Y <= (Bullet1T1Size*Bullet1T1Size) && T1bullet1flag) // this condition will only change to one with keycode is pressed 
            T1bullet1_on = 1'b1; 
        else 
            T1bullet1_on = 1'b0;
     end
	  
	      always_comb
    begin: t1b2	
		  if ( DistBullet2T1X*DistBullet2T1X + DistBullet2T1Y*DistBullet2T1Y <= (Bullet2T1Size*Bullet2T1Size) && T1bullet2flag) // this condition will only change to one with keycode is pressed 
            T1bullet2_on = 1'b1; 
        else 
            T1bullet2_on = 1'b0;
     end
	  
	      always_comb
    begin: t1b3		
		  if ( DistBullet3T1X*DistBullet3T1X + DistBullet3T1Y*DistBullet3T1Y <= (Bullet3T1Size*Bullet3T1Size) && T1bullet3flag) // this condition will only change to one with keycode is pressed 
            T1bullet3_on = 1'b1; 
        else 
            T1bullet3_on = 1'b0;
     end
	  
	  ////////////////////////////////////////////////////////////////////////////////////////////
	  //*********************************************TANK 2*************************************//
	  ////////////////////////////////////////////////////////////////////////////////////////////
	  
	  
	 always_comb
	 begin:tank2_ON_HAI_LAUDA

      if ( tank2DistX < tank2Size && tank2DistY < tank2Size && !tank2gaya)
		  begin
			tank2_on_down = 1'b0;
			tank2_on_right = 1'b0;
			tank2_on_left = 1'b0;
			tank2_on_up = 1'b0;

				if(tank2_Direction == 2'b10) // swapped up and down
				tank2_on_down = 1'b1;
				else if(tank2_Direction == 2'b00)
				tank2_on_up = 1'b1;
				else if(tank2_Direction == 2'b01)
				tank2_on_left = 1'b1;
				else
				tank2_on_right = 1'b1;
		  end
		
		
		else
			begin
				tank2_on_down = 1'b0;
				tank2_on_right = 1'b0;
				tank2_on_left = 1'b0;
				tank2_on_up = 1'b0;
			end
				
		end
		
	 ////////////////////////////////////////////////////////////////////////////////////////////////////	
	 
	 always_comb
    begin: t2b1		
		  if ( DistBullet1T2X*DistBullet1T2X + DistBullet1T2Y*DistBullet1T2Y <= (Bullet1T2Size*Bullet1T2Size) && T2bullet1flag) // this condition will only change to one with keycode is pressed 
            T2bullet1_on = 1'b1; 
        else 
            T2bullet1_on = 1'b0;
     end
	  
	      always_comb
    begin: t2b2	
		  if ( DistBullet2T2X*DistBullet2T2X + DistBullet2T2Y*DistBullet2T2Y <= (Bullet2T2Size*Bullet2T2Size) && T2bullet2flag) // this condition will only change to one with keycode is pressed 
            T2bullet2_on = 1'b1; 
        else 
            T2bullet2_on = 1'b0;
     end
	  
	      always_comb
    begin: t2b3		
		  if ( DistBullet3T2X*DistBullet3T2X + DistBullet3T2Y*DistBullet3T2Y <= (Bullet3T2Size*Bullet3T2Size) && T2bullet3flag) // this condition will only change to one with keycode is pressed 
            T2bullet3_on = 1'b1; 
        else 
            T2bullet3_on = 1'b0;
     end
	  
	  
	  
	  /////////////////////////////////////////////////////////////////////////////////////////
	  //////////////////////////////ACTUAL DRAWING LOGIC///////////////////////////////////////
	  /////////////////////////////////////////////////////////////////////////////////////////
	  /////////////////////////////////////////////////////////////////////////////////////////
	  /////////////////////////////////RED GREEN BLUE//////////////////////////////////////////
	  /////////////////////////////////////////////////////////////////////////////////////////
	  
	  logic [9:0] randx, randy;
	  logic drawshield;
//	  logic tank1shieldacquired, tank2shieldacquired;
	  
	  assign randx = 300;
	  //randcoordwire[19:10];
	  assign randy = 400;
	  //randcoordwire[9:0];
	  
	  always_comb begin
	  
	   if (DistshieldX*DistshieldX + DistshieldY*DistshieldY <= DistshieldS*DistshieldS) drawshield = 1'b1;
		else drawshield = 1'b0;
			
	  end
	  


//	assign randx = 456;
//	assign randy = 172;  

always_ff @ (posedge vga_clk)

begin
			
		  Red <= 8'h00;
		  Blue <= 8'h00;
		  Green <= 8'h00;
		  
		  if (blank) begin
				
				
		  if (game_on == 1'b1) begin
		  
		  Red <= 8'h00;
		  Blue <= 8'h00;
		  Green <= 8'h00;
		 
			
		  if (palette_red_obstacle != 4'hD && palette_green_obstacle != 4'h1 && palette_blue_obstacle != 4'h7) begin // obstacle
				
					Red <= palette_red_obstacle;
					Green <= palette_green_obstacle;
					Blue <= palette_blue_obstacle;
					
				   end
					
			//////////////////////////////////////////////////////////////////////////////////		
		  
		  if (drawshield) begin
		  
					Red <= 8'h00;
					Green <= 8'h00;
					Blue <= 8'hff;	
		  
		  end
		  
		  if (drawshield && (tank_on_up || tank_on_down || tank_on_left || tank_on_right)) 
				tank1shieldacquired <= 1'b1;
				
		  else tank1shieldacquired <= 1'b0;
		  
		  
				
		  if (drawshield && (tank2_on_up || tank2_on_down || tank2_on_left || tank2_on_right)) 
				tank2shieldacquired <= 1'b1;
				
		  else tank2shieldacquired <= 1'b0;
		  
		  
		  
		  
		  if ((tank_on_up == 1'b1) && palette_red_up != 4'hD) 
        begin
		  
				if (tank1spritedetector) begin
				
					Red <= palette_red_up;
					Green <= palette_green_up;
					Blue <= palette_blue_up;
					
				end
					
				else begin
					Red <= palette_red_alt_up;
					Green <= palette_green_alt_up;
					Blue <= palette_blue_alt_up;
					
				end
				
		  end
 		  
		  
		  if ((tank_on_down == 1'b1) && palette_red_down != 4'hD) 
        begin 
		  
			if (tank1spritedetector) begin
			
            Red <= palette_red_down;
            Green <= palette_green_down;
            Blue <= palette_blue_down;
			end
			
			
			else begin
				
					Red <= palette_red_alt_down;
					Green <= palette_green_alt_down;
					Blue <= palette_blue_alt_down;
			
			end
				
        end
		  
		  if ((tank_on_right == 1'b1) && palette_red_right != 4'hD) 
        begin 
		  
			if(tank1spritedetector)
				begin
					Red <= palette_red_right;
					Green <= palette_green_right;
					Blue <= palette_blue_right;
			  end
			  else begin
				
					Red <= palette_red_alt_right;
					Green <= palette_green_alt_right;
					Blue <= palette_blue_alt_right;
			
					end
			end
			
			
			  
	   if ((tank_on_left == 1'b1) && palette_red_left != 4'hD) 
		begin
		  
		  if(tank1spritedetector)
        begin 
            Red <= palette_red_left;
            Green <= palette_green_left;
            Blue <= palette_blue_left;
        end
		  
		  else begin
					Red <= palette_red_alt_left;
					Green <= palette_green_alt_left;
					Blue <= palette_blue_alt_left;
		  end
		  
		end
		
		 
		  /////////////////////////////////////////////////////////////////////////////////
		  
		  if ((tank2_on_up == 1'b1) && palette_red_up2 != 4'hD) 
        begin 
		  
			if(tank2spritedetector)
			begin
            Red <= palette_red_up2;
            Green <= palette_green_up2;
            Blue <= palette_blue_up2;
			end
	
			else begin
					Red <= palette_red_alt_up2;
					Green <= palette_green_alt_up2;
					Blue <= palette_blue_alt_up2;
					
				end
        end
		  
		  if ((tank2_on_down == 1'b1) && palette_red_down2 != 4'hD) 
        begin 
		  
		  if(tank2spritedetector)
		  begin
            Red <= palette_red_down2;
            Green <= palette_green_down2;
            Blue <= palette_blue_down2;
			end
				
				
			else begin
					Red <= palette_red_alt_down2;
					Green <= palette_green_alt_down2;
					Blue <= palette_blue_alt_down2;
					
				end
        end
		  
		  if ((tank2_on_right == 1'b1) && palette_red_right2 != 4'hD) 
        begin 
		  if(tank2spritedetector)
		  begin
            Red <= palette_red_right2;
            Green <= palette_green_right2;
            Blue <= palette_blue_right2;
			end
				
			else begin
					Red <= palette_red_alt_right2;
					Green <= palette_green_alt_right2;
					Blue <= palette_blue_alt_right2;
					
				end
        end
		  
		  if ((tank2_on_left == 1'b1) && palette_red_left2 != 4'hD) 
        begin 
		  if(tank2spritedetector)
		  begin
		  
            Red <= palette_red_left2;
            Green <= palette_green_left2;
            Blue <= palette_blue_left2;
			end
				
				
			else begin
					Red <= palette_red_alt_left2;
					Green <= palette_green_alt_left2;
					Blue <= palette_blue_alt_left2;
					
				end
        end
		  
		  
		  
		  
		  ////////////////////////////////////////////////////////////////////////////////////////////////////
		  
		  if (T1bullet1_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  
		  if (T1bullet2_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  
		  if (T1bullet3_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  /////////////////////////////////////////////////////////////////////////////////////////////////////
		  
		  if (T2bullet1_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  
		  if (T2bullet2_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  
		  if (T2bullet3_on)
		  begin
				Red <= 8'hff;
				Green <= 8'hff;
				Blue <= 8'hff;
		  end
		  
		  /////////////////////////////////////////////////////////////////////////////////////////////////////
		  
//		  if (palette_red_obstacle == 4'hD && palette_green_obstacle == 4'h1 && palette_blue_obstacle == 4'h7) begin // if zone is pink
//				
//				if ((DrawX > randx - 10) && (DrawX < randx + 10) && (DrawY > randy - 10) && (DrawY < randy + 10) ) begin
////				if( palette_red_obstacle != 4'hD && palette_green_obstacle != 4'h1 && palette_blue_obstacle != 4'h7) begin
//					Red <= 8'hff;
//					Blue <= 8'hff;
//					Green <= 8'hff;
////				end
//			end	
//		  end
		  
		  ///////////
		  
		  if (tank1gaya) begin
		  
			  if (t1explosion1 && explosion1_on) begin
			  
					if (palette_red_explosion1 != 4'hD) begin
			  
						LEDOut <= 1'b1;
			  
						Red <= palette_red_explosion1;
						Green <= palette_green_explosion1;
						Blue <= palette_blue_explosion1;
						
					end
			  
			  end
			  
			  //else LEDOut <= 1'b0;
			  
			  if (t1explosion2 && explosion2_on) begin			
			  
					if (palette_red_explosion2 != 4'hD) begin
				
						LEDOut8 <= 1'b1;
						
						Red <= palette_red_explosion2;
						Green <= palette_green_explosion2;
						Blue <= palette_blue_explosion2;
						
					end
			  
			  end
		  
		  end
		  
		  
		  
		  ////////////88888888888888888888888////////////
		  
		  
		  if (tank2gaya) begin
		  
			  if (t2explosion1 && explosion1_on) begin
			  
					if (palette_red_explosion21 != 4'hD) begin
			  
						LEDOut <= 1'b1;
			  
						Red <= palette_red_explosion21;
						Green <= palette_green_explosion21;
						Blue <= palette_blue_explosion21;
						
					end
			  
			  end
			  
			  //else LEDOut <= 1'b0;
			  
			  if (t2explosion2 && explosion2_on) begin			
			  
					if (palette_red_explosion22 != 4'hD) begin
				
						LEDOut8 <= 1'b1;
						
						Red <= palette_red_explosion22;
						Green <= palette_green_explosion22;
						Blue <= palette_blue_explosion22;
						
					end
			  
			  end
		  
		  end
		  
		  
		 
		  
		  
		  //////////////////
		  
		  if ((DrawX >= 40 && DrawX <=  40 + healthoftank1) && (DrawY >= 2 && DrawY <= 22)) begin
					Red <= 8'h7c;
					Green <= 8'hfc;
					Blue <= 8'h00;
		  end
		  
		  if ((DrawX >= 560 && DrawX <=  560 + healthoftank2) && (DrawY >= 2 && DrawY <= 22)) begin
					Red <= 8'h7c;
					Green <= 8'hfc;
					Blue <= 8'h00;
		  end
		  
		  
		  
//		  if ((DrawX >= 0 && DrawX <= 4) || (DrawX <= 670 && DrawX >= 666) || ((DrawY >= 0 && DrawY <= 4) && (DrawX >= 0 && DrawX <= 670)) || ((DrawY <= 670 && DrawY >= 666) && (DrawX >= 0 && DrawX <= 670))) begin
//				
//				Red <= palette_red_brick;
//				Green <= palette_green_brick;
//				Blue <= palette_blue_brick;
//		  		  
//		  end
		  
		  end
		  
		  ////////////////////////////////////// MENU SCREEN OPTIONS ////////////////////////////////////
		  
		  else if (game_on == 1'b0 && death_screenP1 == 1'b1) begin
		  
		  //if (palette_red_p1 != 4'hD) begin
		  
			  Red <= palette_red_p1;
			  Green <= palette_green_p1;
			  Blue <= palette_blue_p1;
		  
		  //end
		  
		  end
		  
		  else if (game_on == 1'b0 && death_screenP2 == 1'b1) begin
		  
		  //if (palette_red_p2 != 4'hD) begin
		  
			  Red <= palette_red_p2;
			  Green <= palette_green_p2;
			  Blue <= palette_blue_p2;
			  
		 // end
		  
		  end
		  
		  
		  else begin
		  
		  if (palette_red_menu1 != 4'hD) begin
		  
			  Red <= palette_red_menu1;
			  Green <= palette_green_menu1;
			  Blue <= palette_blue_menu1;
		  
		  end
		  
		  end
		  
		  
		  

		  /////////////////////////////////////// MENU SCREEN OPTIONS ////////////////////////////////////
			  
		 
end // END OF BLANK ENCAPSULATOR
	
		    
end // ending of always_ff block
    
endmodule
