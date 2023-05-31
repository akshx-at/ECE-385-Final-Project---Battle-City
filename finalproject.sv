//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module finalproject (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;
logic [1:0] tank1direction;
logic [2:0] sprite_signal;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	
	logic [9:0] drawxsig, drawysig;
	
	logic [9:0] ballxsig, ballysig, ballsizesig, bullet1T1xsig, bullet1T1ysig, bullet1T1sizesig; // is there a more compact way to do this top level shit?
   logic [9:0] bullet2T1xsig, bullet2T1ysig, bullet2T1sizesig, bullet3T1xsig, bullet3T1ysig, bullet3T1sizesig;
	logic T1bullet1flag, T1bullet2flag, T1bullet3flag;
	
	logic [9:0] ball2xsig, ball2ysig, ball2sizesig, bullet1T2xsig, bullet1T2ysig, bullet1T2sizesig;
	logic [9:0] bullet2T2xsig, bullet2T2ysig, bullet2T2sizesig, bullet3T2xsig, bullet3T2ysig, bullet3T2sizesig;
	logic T2bullet1flag, T2bullet2flag, T2bullet3flag;


	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode, keycode1, keycode2, keycode3;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (tank1shieldacquired, HEX4[6:0]);
	assign HEX4[7] = ~tank1shieldacquired;
	
	HexDriver hex_driver3 (tank2shieldacquired, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[3:0];
	assign VGA_B = Blue[3:0];
	assign VGA_G = Green[3:0];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, /*LEDR*/}),
		.keycode_export(keycode),
		.keycode1_export(keycode1),
		.keycode2_export(keycode2),
		.keycode3_export(keycode3),
		.randcord_export(randcord)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
logic[19:0] randcord;
logic obstacle_enable;
logic game_reset;
logic bullet1tank2collision, bullet2tank1collision;
logic game_chaalu, explosion1_on, explosion2_on, death_screenP1, death_screenP2;
logic slow_clock;
logic [1:0] tank2direction;
logic tank1spritedetector, tank2spritedetector;
logic [3:0] bullet_count, bullet_count2;

logic shield1_status, shield2_status;

assign shield1_status = 1'b0;
assign shield2_status = 1'b0;

logic tank1shieldacquired, tank2shieldacquired; 
//assign shield1 = 1'b0;
//assign shield2 = 1'b0;

logic tank1dead, tank2dead;
logic [5:0] health1, health2;


always_comb begin

	if (tank1shieldacquired) begin
		LEDR[7] = 1'b1;
		
	end
	
	else begin
		LEDR[7] = 1'b0;
	end
	
end

always_comb begin

	if (shield1_status) begin
		LEDR[8] = 1'b1;
	end
	
	else begin
		LEDR[8] = 1'b0;
	end
	
end

//assign LEDR[3] = bullet_count[1];
//assign LEDR[2] = bullet_count[0];


always_comb begin

	// O, Y or M

	if (keycode == 8'd18 || keycode == 8'd28 || keycode == 8'd16) begin // O and M reset all modules except tanks
		game_reset = 1'b1;
		LEDR[3] = 1'b1;
	end
	
	else begin
		game_reset = 1'b0;
		LEDR[3] = 1'b0;
	end
	
end


// create one collision or statement here to directly send a signal to your game fsm


vga_controller vga_lab(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));

tank tank_lab(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .keycode1(keycode1),.keycode2(keycode2), .keycode3(keycode3),
				  .tankX(ballxsig), .tankY(ballysig), .tankS(ballsizesig), .tank1_direction(tank1direction),
				  
				  .BulletX(bullet1T1xsig), .BulletY(bullet1T1ysig), .BulletS(bullet1T1sizesig) , .bullet_flag(T1bullet1flag),
				  .Bullet2X(bullet2T1xsig), .Bullet2Y(bullet2T1ysig), .Bullet2S(bullet2T1sizesig) , .bullet2_flag(T1bullet2flag),
				  .Bullet3X(bullet3T1xsig), .Bullet3Y(bullet3T1ysig), .Bullet3S(bullet3T1sizesig) , .bullet3_flag(T1bullet3flag),
				  
				  .fast_clock(MAX10_CLK1_50), .LED5(), .LED6(), .tank2gaya(tank2dead || bullet1tank2collision), .count(bullet_count),
				  .BULLETFLAGCHECK(LEDR[1]));


tank2 tank2_lab(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .keycode1(keycode1),.keycode2(keycode2), .keycode3(keycode3), 
					 .tankX(ball2xsig), .tankY(ball2ysig), .tankS(ball2sizesig),.tank2_direction(tank2direction), .count(bullet_count2),
					 
				   .BulletX(bullet1T2xsig), .BulletY(bullet1T2ysig), .BulletS(bullet1T2sizesig) , .bullet_flag(T2bullet1flag),
					.Bullet2X(bullet2T2xsig), .Bullet2Y(bullet2T2ysig), .Bullet2S(bullet2T2sizesig) , .bullet2_flag(T2bullet2flag),
				   .Bullet3X(bullet3T2xsig), .Bullet3Y(bullet3T2ysig), .Bullet3S(bullet3T2sizesig) , .bullet3_flag(T2bullet3flag),
		
					.fast_clock(MAX10_CLK1_50), .BULLETFLAGCHECK(LEDR[0]), .tank1gaya(tank1dead || bullet2tank1collision));


color_mapper color_lab(.DrawX(drawxsig),.DrawY(drawysig), .Red(Red), .Green(Green), .Blue(Blue), .vga_clk(VGA_Clk), .blank(blank),

						     .tankX(ballxsig), .tankY(ballysig), .tank_size(ballsizesig), .tank1_Direction(tank1direction),
							  .T1Bullet1X(bullet1T1xsig), .T1Bullet1Y(bullet1T1ysig), .T1Bullet1S(bullet1T1sizesig), .T1bullet1flag(T1bullet1flag),
							  .T1Bullet2X(bullet2T1xsig), .T1Bullet2Y(bullet2T1ysig), .T1Bullet2S(bullet2T1sizesig), .T1bullet2flag(T1bullet2flag),
							  .T1Bullet3X(bullet3T1xsig), .T1Bullet3Y(bullet3T1ysig), .T1Bullet3S(bullet3T1sizesig), .T1bullet3flag(T1bullet3flag),
							  
							  .tank2X(ball2xsig), .tank2Y(ball2ysig), .tank2_size(ball2sizesig),.tank2_Direction(tank2direction),
							  .T2Bullet1X(bullet1T2xsig), .T2Bullet1Y(bullet1T2ysig), .T2Bullet1S(bullet1T2sizesig), .T2bullet1flag(T2bullet1flag),
							  .T2Bullet2X(bullet2T2xsig), .T2Bullet2Y(bullet2T2ysig), .T2Bullet2S(bullet2T2sizesig), .T2bullet2flag(T2bullet2flag), 
							  .T2Bullet3X(bullet3T2xsig), .T2Bullet3Y(bullet3T2ysig), .T2Bullet3S(bullet3T2sizesig), .T2bullet3flag(T2bullet3flag),
							  
							  .randcoordwire(randcord),
							  .LEDOut(), .obstacle_EN(obstacle_enable), .reset(game_reset), .LEDOut8(), 
							  .tank1gaya(tank1dead), .tank2gaya(tank2dead),
							  .game_on(game_chaalu), .explosion1_on(explosion1_on), .explosion2_on(explosion2_on) ,.death_screenP1(death_screenP1), .death_screenP2(death_screenP2),
							  .tank1spritedetector(tank1spritedetector), .tank2spritedetector(tank2spritedetector),
							  .healthoftank1(health1), .healthoftank2(health2),
							  .tank1shieldacquired(tank1shieldacquired), .tank2shieldacquired(tank2shieldacquired)); 
							   

game_states FSM (.tank1gaya(tank1dead), .tank2gaya(tank2dead),
					  .fsm_clock(VGA_VS), .reset(Reset_h), .keycode(keycode),
				     .game_on(game_chaalu), .explosion1_on(explosion1_on), .explosion2_on(explosion2_on), .death_screenP1(death_screenP1), .death_screenP2(death_screenP2));		

		
health tank1health(.collision(bullet2tank1collision), .clock(VGA_VS), .reset(game_reset), .shield_on(shield1_status), .health(health1), .tank_dead(tank1dead));
health tank2health(.collision(bullet1tank2collision), .clock(VGA_VS), .reset(game_reset), .shield_on(shield2_status), .health(health2), .tank_dead(tank2dead));

//shield shield1(.reset(game_reset), .clock(VGA_VS), .shield_acquired(tank1shieldacquired), .shield_status(), .LEDshield(LEDR[9]));
//shield shield2(.reset(game_reset), .clock(VGA_VS), .shield_acquired(tank2shieldacquired), .shield_status(), .LEDshield());
				  
//map_generator map1(.DrawX(drawxsig), .DrawY(drawysig), .sprite_signal(sprite_signal));






collision_handler c1(.bullet1T1xpos(bullet1T1xsig), .bullet1T1ypos(bullet1T1ysig), 
							.bullet2T1xpos(bullet2T1xsig), .bullet2T1ypos(bullet2T1ysig),
							.bullet3T1xpos(bullet3T1xsig), .bullet3T1ypos(bullet3T1ysig),
					
							.bullet1T2xpos(bullet1T2xsig), .bullet1T2ypos(bullet1T2ysig), 
							.bullet2T2xpos(bullet2T2xsig), .bullet2T2ypos(bullet2T2ysig),
							.bullet3T2xpos(bullet3T2xsig), .bullet3T2ypos(bullet3T2ysig),  
							
							.tank1xpos(ballxsig), .tank1ypos(ballysig), .tank2xpos(ball2xsig), .tank2ypos(ball2ysig),
							.clock(VGA_Clk), 
							
							.bullet1tank2collision(bullet1tank2collision), .bullet2tank1collision(bullet2tank1collision));
							
							
							

clock_divider cd1(.input_clock(VGA_VS), .reset(game_reset), .output_clock(slow_clock));

tank1_animator t1a(.animator_clock(slow_clock), .animator_reset(game_reset), 
						 .keycode1(keycode), .keycode2(keycode1), .keycode3(keycode2), .keycode4(keycode3),
						 .tank1picksignal(tank1spritedetector));
							 

tank2_animator t2a(.animator_clock(slow_clock), .animator_reset(game_reset), 
						 .keycode1(keycode), .keycode2(keycode1), .keycode3(keycode2), .keycode4(keycode3),
						 .tank2picksignal(tank2spritedetector));
						 
key_counter TANK1BULLETS(
  .clk(VGA_VS), .reset(game_reset),
  .keycode0(keycode), .keycode1(keycode1), .keycode2(keycode2), .keycode3(keycode3),
  .count(bullet_count));
  
key_counter2 TANK2BULLETS(
  .clk(VGA_VS), .reset(game_reset),
  .keycode0(keycode), .keycode1(keycode1), .keycode2(keycode2), .keycode3(keycode3),
  .count(bullet_count2));  
							 


endmodule
