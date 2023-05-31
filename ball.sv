//----------------------------------------\-=l;p[l;------------------------------
//    tank.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
////    UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  tank ( input Reset, frame_clk, fast_clock, tank2gaya,
					input [7:0] keycode, keycode1, keycode2, keycode3,
					input [3:0] count,
					output bullet_flag, bullet2_flag, bullet3_flag,
					output [1:0] tank1_direction,
               output [9:0] tankX, tankY, tankS,
					output [9:0] BulletX, BulletY, BulletS, Bullet2X, Bullet2Y, Bullet2S, Bullet3X, Bullet3Y, Bullet3S,
					output BULLETFLAGCHECK);
					
					
    
    logic [9:0] tank_X_Pos, tank_X_Motion, tank_Y_Pos, tank_Y_Motion, tank_Size, Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion, Bullet_Size;
	 logic [9:0] Bullet2_X_Pos, Bullet2_X_Motion, Bullet2_Y_Pos, Bullet2_Y_Motion, Bullet2_Size;
	 logic [9:0] Bullet3_X_Pos, Bullet3_X_Motion, Bullet3_Y_Pos, Bullet3_Y_Motion, Bullet3_Size;
	 logic up_collision, down_collision, left_collision, right_collision;
	 
    parameter [9:0] tank_X_Center=100;  // Center position on the X axis
    parameter [9:0] tank_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] tank_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] tank_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] tank_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] tank_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] tank_X_Step=5;      // Step size on the X axis
    parameter [9:0] tank_Y_Step=5;      // Step size on the Y axis
	 


	 parameter [9:0] Bullet_X_Center = 320;
	 parameter [9:0] Bullet_Y_Center = 240;
    parameter [9:0] Bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet_X_Step=20;      // Step size on the X axis
    parameter [9:0] Bullet_Y_Step=20;      // Step size on the Y axis
	 
	 parameter [9:0] Bullet2_X_Center = 320;
	 parameter [9:0] Bullet2_Y_Center = 240;
    parameter [9:0] Bullet2_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet2_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet2_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet2_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet2_X_Step=20;      // Step size on the X axis
    parameter [9:0] Bullet2_Y_Step=20;      // Step size on the Y axis
	 
	 parameter [9:0] Bullet3_X_Center = 320;
	 parameter [9:0] Bullet3_Y_Center = 240;
    parameter [9:0] Bullet3_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bullet3_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bullet3_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bullet3_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bullet3_X_Step=20;      // Step size on the X axis
    parameter [9:0] Bullet3_Y_Step=20;      // Step size on the Y axis
	
	
	 
	 logic left_flag = 0;
	 logic right_flag = 0;
	 logic up_flag = 0;
	 logic down_flag = 0;
	 
	 // 00 W; 01 A; 10 S; 11 D
	 logic [1:0] direction;
	 logic [1:0] bullet_direction;
	 logic [1:0] bullet2_direction;
	 logic [1:0] bullet3_direction;
	 
	 logic drawbullet_flag = 0;
	 logic drawbullet_flag2 = 0;
	 logic drawbullet_flag3 = 0;

	 logic [7:0] lastkeypressed;

    assign tank_Size = 32;  // assigns the value  as a 10-digit binary number, ie "0000000100"
	 
	 assign Bullet_Size = 4; // assuming the same shit happens to this	
	 assign Bullet2_Size = 4;
	 assign Bullet3_Size = 4;
	



		always_comb begin
	 
				if ( direction == 2'b00 && tankcollisionsignal) begin
					  up_flag = 1;
					  down_flag = 0;
					  left_flag = 0;
					  right_flag = 0;
					  end
					  
				 else if ( direction == 2'b01 && tankcollisionsignal) begin
					  left_flag = 1;
					  down_flag = 0;
					  right_flag = 0;
					  up_flag = 0;
					  end
					  
				 else if ( direction == 2'b10 && tankcollisionsignal) begin 
					  down_flag = 1;		
					  up_flag = 0;
					  left_flag = 0;
					  right_flag = 0;
					  end
					  
				 else if ( direction == 2'b11 && tankcollisionsignal) begin
					  right_flag = 1;
					  left_flag = 0;
					  up_flag = 0;
					  down_flag = 0;
					  end
					  
				 else  begin
						left_flag = 0;
						right_flag = 0;
						down_flag = 0;
						up_flag = 0;
						end
	 
	 end
	 
   
    always_ff @ (posedge Reset or posedge frame_clk )
	 
    begin: Move_tank
		
        if (Reset)  // Asynchronous Reset
		  begin 
		
            tank_Y_Motion <= 10'd0; //tank_Y_Step;
				tank_X_Motion <= 10'd0; //tank_X_Step;
				tank_Y_Pos <= tank_Y_Center;
				tank_X_Pos <= tank_X_Center;
				
				// how to make our bullet disappear?
				Bullet_Y_Motion <= 10'd0;
				Bullet_X_Motion <= 10'd0;
				
				direction = 2'b00;
				drawbullet_flag = 0;
				drawbullet_flag2 = 0;
				drawbullet_flag3 = 0;
        end
		 
		  ////////////////////// REGULAR GAME STATE LOGIC /////////////////////////////////////
           
        else 
        begin 
				
				if (bullet1collisionsignal || tank2gaya)
						begin 
							drawbullet_flag = 0;
						end
				if (bullet2collisionsignal || tank2gaya)
						begin 
							//LED6 = 1'b1;
							drawbullet_flag2 = 0;
						end
				if (bullet3collisionsignal || tank2gaya)
						begin 
							//LED6 = 1'b1;
							drawbullet_flag3 = 0;
					   end
						
						
						
				///////////////////////// check //////////////////		
				if (bullet1collisionsignal) BULLETFLAGCHECK = 1'b1;
				
				else BULLETFLAGCHECK = 1'b0;
	
	
					
						
				///////////////////////////////////////////////// END OF COLLISION CHECKS /////////////////////////////////////////////////
				//////////////////START OF KEYCODE PRESS LOGIC/////////////////////////////////////////////////////////////////////////////
					  
				 case (keycode)
					8'h04 : begin
					
							if (!left_flag) begin 

									tank_X_Motion <= -1;//A
									tank_Y_Motion<= 0;
									tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
									tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
								
									direction <= 2'b01;
							end
								
								
							 else begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							 end
			
					end
					        
					8'h07 : begin
								
							if (!right_flag) begin
								//if(!right_collision) begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b11;
							  end
							  
						   else begin
					        tank_X_Motion <= -1;//D
							  tank_Y_Motion <= 0;
							end

					end

							  
					8'h16 : begin
					
							if (!down_flag) begin

					        tank_Y_Motion <= 1;//S
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b10;
							  
							end
							  
							else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= -1;
							end
		
				    end
					 
							  
					8'h1A : begin
					
							if (!up_flag) begin
					        tank_Y_Motion <= -1;//W
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b00;
							end
							  
						   else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= 1;
							end
							  
							 
					 end
							 
							 
							 
					//////////////// A new case to throw the bullet which will be correspondent to another alphabet on the keyboard 
					8'd44 : begin  // changed this to X to check if there is a problem with the ascii value of the spacebar
					
					if (count == 4'd1) 
						
					begin
						drawbullet_flag = 1'b1;
						
						if(bullet_direction == 2'b10) // s (down)
							begin 
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= 6;
							end
							
							
						if(bullet_direction == 2'b11) // d (right)
							begin 
							Bullet_X_Motion <= 6;
							Bullet_Y_Motion<= 0;
							end
						if(bullet_direction == 2'b00) // w (up)
							begin                                            
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= -6;
							end
								
						if(bullet_direction == 2'b01) // a (left)
							begin
							Bullet_X_Motion <= -6;
							Bullet_Y_Motion<= 0;
							end
					end
					
					else if (count == 4'd2) 
					begin
						
						drawbullet_flag2 = 1'b1;
										
						if(bullet2_direction == 2'b10) // s (down)
							begin 
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= 6;
							end
							
							
						if(bullet2_direction == 2'b11) // d (right)
							begin 
							Bullet2_X_Motion <= 6;
							Bullet2_Y_Motion<= 0;
							end
						if(bullet2_direction == 2'b00) // w (up)
							begin                                            
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= -6;
							end
								
						if(bullet2_direction == 2'b01) // a (left)
							begin
							Bullet2_X_Motion <= -6;
							Bullet2_Y_Motion<= 0;
							end
					end
						
						
						
					else if (count == 4'd3) 
						
					begin
						drawbullet_flag3 = 1'b1;
									
						if(bullet3_direction == 2'b10) // s (down)
							begin 
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= 6;
							end
							
							
						if(bullet3_direction == 2'b11) // d (right)
							begin 
							Bullet3_X_Motion <= 6;
							Bullet3_Y_Motion<= 0;
							end
						if(bullet3_direction == 2'b00) // w (up)
							begin                                            
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= -6;
							end
								
						if(bullet3_direction == 2'b01) // a (left)
							begin
							Bullet3_X_Motion <= -6;
							Bullet3_Y_Motion<= 0;
							end
					end
						
							
						
				end
		
					default: ;
					
			   endcase
				
				
				
				
//////////////////////////////////////////////////// ACCOUNTING FOR KEYCODE 1 /////////////////////////////////////////////////////////////////////


				 case (keycode1)
				  8'h04 : begin
					
							if (!left_flag) begin 

									tank_X_Motion <= -1;//A
									tank_Y_Motion<= 0;
									tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
									tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
								
									direction <= 2'b01;
							end
								
								
							 else begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							 end
			
					end
					        
					8'h07 : begin
								
							if (!right_flag) begin
								//if(!right_collision) begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b11;
							  end
							  
						   else begin
					        tank_X_Motion <= -1;//D
							  tank_Y_Motion <= 0;
							end

					end

							  
					8'h16 : begin
					
							if (!down_flag) begin

					        tank_Y_Motion <= 1;//S
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b10;
							  
							end
							  
							else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= -1;
							end
		
				    end
					 
							  
					8'h1A : begin
					
							if (!up_flag) begin
					        tank_Y_Motion <= -1;//W
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b00;
							end
							  
						   else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= 1;
							end
							  
							 
					 end
							 
							 
							 
							 
					//////////////// A new case to throw the bullet which will be correspondent to another alphabet on the keyboard 
					8'd44 : begin  // changed this to X to check if there is a problem with the ascii value of the spacebar
					
					if (count == 4'd1) 
						
					begin
						drawbullet_flag = 1'b1;
						
						if(bullet_direction == 2'b10) // s (down)
							begin 
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= 6;
							end
							
							
						if(bullet_direction == 2'b11) // d (right)
							begin 
							Bullet_X_Motion <= 6;
							Bullet_Y_Motion<= 0;
							end
						if(bullet_direction == 2'b00) // w (up)
							begin                                            
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= -6;
							end
								
						if(bullet_direction == 2'b01) // a (left)
							begin
							Bullet_X_Motion <= -6;
							Bullet_Y_Motion<= 0;
							end
					end
					
					else if (count == 4'd2) 
					begin
							drawbullet_flag2 = 1'b1;
										
						if(bullet2_direction == 2'b10) // s (down)
							begin 
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= 6;
							end
							
							
						if(bullet2_direction == 2'b11) // d (right)
							begin 
							Bullet2_X_Motion <= 6;
							Bullet2_Y_Motion<= 0;
							end
						if(bullet2_direction == 2'b00) // w (up)
							begin                                            
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= -6;
							end
								
						if(bullet2_direction == 2'b01) // a (left)
							begin
							Bullet2_X_Motion <= -6;
							Bullet2_Y_Motion<= 0;
							end
					end
						
						
						
					else if (count == 4'd3) 
						
					begin
						drawbullet_flag3 = 1'b1;
									
						if(bullet3_direction == 2'b10) // s (down)
							begin 
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= 6;
							end
							
							
						if(bullet3_direction == 2'b11) // d (right)
							begin 
							Bullet3_X_Motion <= 6;
							Bullet3_Y_Motion<= 0;
							end
						if(bullet3_direction == 2'b00) // w (up)
							begin                                            
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= -6;
							end
								
						if(bullet3_direction == 2'b01) // a (left)
							begin
							Bullet3_X_Motion <= -6;
							Bullet3_Y_Motion<= 0;
							end
					end
						
							
						
				end
		
					default: ;
					
			   endcase
				
				
				

///////////////////////////////////////////////////ACCOUNTING FOR KEYCODE 2////////////////////////////////////////////////////////////////////////////////////
				
				
				
				 case (keycode2)
					8'h04 : begin
					
							if (!left_flag) begin 

									tank_X_Motion <= -1;//A
									tank_Y_Motion<= 0;
									tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
									tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
								
									direction <= 2'b01;
							end
								
								
							 else begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							 end
			
					end
					        
					8'h07 : begin
								
							if (!right_flag) begin
								//if(!right_collision) begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b11;
							  end
							  
						   else begin
					        tank_X_Motion <= -1;//D
							  tank_Y_Motion <= 0;
							end

					end

							  
					8'h16 : begin
					
							if (!down_flag) begin

					        tank_Y_Motion <= 1;//S
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b10;
							  
							end
							  
							else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= -1;
							end
		
				    end
					 
							  
					8'h1A : begin
					
							if (!up_flag) begin
					        tank_Y_Motion <= -1;//W
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b00;
							end
							  
						   else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= 1;
							end
							  
							 
					 end
							 
							 
							 
							 
					//////////////// A new case to throw the bullet which will be correspondent to another alphabet on the keyboard 
					8'd44 : begin  // changed this to X to check if there is a problem with the ascii value of the spacebar
					
					if (count == 4'd1) 
						
					begin
						drawbullet_flag = 1'b1;
						
						if(bullet_direction == 2'b10) // s (down)
							begin 
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= 6;
							end
							
							
						if(bullet_direction == 2'b11) // d (right)
							begin 
							Bullet_X_Motion <= 6;
							Bullet_Y_Motion<= 0;
							end
						if(bullet_direction == 2'b00) // w (up)
							begin                                            
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= -6;
							end
								
						if(bullet_direction == 2'b01) // a (left)
							begin
							Bullet_X_Motion <= -6;
							Bullet_Y_Motion<= 0;
							end
					end
					
					else if (count == 4'd2) 
					begin
							drawbullet_flag2 = 1'b1;
										
						if(bullet2_direction == 2'b10) // s (down)
							begin 
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= 6;
							end
							
							
						if(bullet2_direction == 2'b11) // d (right)
							begin 
							Bullet2_X_Motion <= 6;
							Bullet2_Y_Motion<= 0;
							end
						if(bullet2_direction == 2'b00) // w (up)
							begin                                            
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= -6;
							end
								
						if(bullet2_direction == 2'b01) // a (left)
							begin
							Bullet2_X_Motion <= -6;
							Bullet2_Y_Motion<= 0;
							end
					end
						
						
						
					else if (count == 4'd3) 
						
					begin
						drawbullet_flag3 = 1'b1;
									
						if(bullet3_direction == 2'b10) // s (down)
							begin 
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= 6;
							end
							
							
						if(bullet3_direction == 2'b11) // d (right)
							begin 
							Bullet3_X_Motion <= 6;
							Bullet3_Y_Motion<= 0;
							end
						if(bullet3_direction == 2'b00) // w (up)
							begin                                            
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= -6;
							end
								
						if(bullet3_direction == 2'b01) // a (left)
							begin
							Bullet3_X_Motion <= -6;
							Bullet3_Y_Motion<= 0;
							end
					end
						
							
						
				end
		
					default: ;
					
			   endcase
				
				
				
				
////////////////////////////////////////ACCOUNTING FOR KEYCODE 3////////////////////////////////////////////////////////////////////////////////


				 case (keycode3)
					8'h04 : begin
					
							if (!left_flag) begin 

									tank_X_Motion <= -1;//A
									tank_Y_Motion<= 0;
									tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
									tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
								
									direction <= 2'b01;
							end
								
								
							 else begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							 end
			
					end
					        
					8'h07 : begin
								
							if (!right_flag) begin
								//if(!right_collision) begin
					        tank_X_Motion <= 1;//D
							  tank_Y_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b11;
							  end
							  
						   else begin
					        tank_X_Motion <= -1;//D
							  tank_Y_Motion <= 0;
							end

					end

							  
					8'h16 : begin
					
							if (!down_flag) begin

					        tank_Y_Motion <= 1;//S
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b10;
							  
							end
							  
							else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= -1;
							end
		
				    end
					 
							  
					8'h1A : begin
					
							if (!up_flag) begin
					        tank_Y_Motion <= -1;//W
							  tank_X_Motion <= 0;
							  tank_Y_Pos <= (tank_Y_Pos + tank_Y_Motion);  // Update tank position
							  tank_X_Pos <= (tank_X_Pos + tank_X_Motion);
							  direction <= 2'b00;
							end
							  
						   else begin
					        tank_X_Motion <= 0;
							  tank_Y_Motion <= 1;
							end
							  
							 
					 end
							 
							
							 
							 	 
					//////////////// A new case to throw the bullet which will be correspondent to another alphabet on the keyboard 
					8'd44 : begin  // changed this to X to check if there is a problem with the ascii value of the spacebar
					
					if (count == 4'd1) 
						
					begin
						drawbullet_flag = 1'b1;
						
						if(bullet_direction == 2'b10) // s (down)
							begin 
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= 6;
							end
							
							
						if(bullet_direction == 2'b11) // d (right)
							begin 
							Bullet_X_Motion <= 6;
							Bullet_Y_Motion<= 0;
							end
						if(bullet_direction == 2'b00) // w (up)
							begin                                            
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= -6;
							end
								
						if(bullet_direction == 2'b01) // a (left)
							begin
							Bullet_X_Motion <= -6;
							Bullet_Y_Motion<= 0;
							end
					end
					
					else if (count == 4'd2) 
					begin
							drawbullet_flag2 = 1'b1;
										
						if(bullet2_direction == 2'b10) // s (down)
							begin 
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= 6;
							end
							
							
						if(bullet2_direction == 2'b11) // d (right)
							begin 
							Bullet2_X_Motion <= 6;
							Bullet2_Y_Motion<= 0;
							end
						if(bullet2_direction == 2'b00) // w (up)
							begin                                            
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= -6;
							end
								
						if(bullet2_direction == 2'b01) // a (left)
							begin
							Bullet2_X_Motion <= -6;
							Bullet2_Y_Motion<= 0;
							end
					end
						
						
						
					else if (count == 4'd3) 
						
					begin
						drawbullet_flag3 = 1'b1;
									
						if(bullet3_direction == 2'b10) // s (down)
							begin 
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= 6;
							end
							
							
						if(bullet3_direction == 2'b11) // d (right)
							begin 
							Bullet3_X_Motion <= 6;
							Bullet3_Y_Motion<= 0;
							end
						if(bullet3_direction == 2'b00) // w (up)
							begin                                            
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= -6;
							end
								
						if(bullet3_direction == 2'b01) // a (left)
							begin
							Bullet3_X_Motion <= -6;
							Bullet3_Y_Motion<= 0;
							end
					end
						
							
						
				end
		
					default: ;
					
			   endcase
				
				
				
				////// ALL KEYCODE CASES HAVE ENDED /////
				
				
				
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////	
			/////////////////////////////****************************************//////////////////////////////////////////	
			//////////////////////////////////second keycode was pressed so fire //////////////////////////////////////////
				
			if(keycode3 == 8'd44 || keycode == 8'd44 || keycode1 == 8'd44 || keycode2 == 8'd44)
			begin
					
					if (count == 4'd1) 
						
					begin
						drawbullet_flag = 1'b1;
						
						if(bullet_direction == 2'b10) // s (down)
							begin 
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= 6;
							end
							
							
						if(bullet_direction == 2'b11) // d (right)
							begin 
							Bullet_X_Motion <= 6;
							Bullet_Y_Motion<= 0;
							end
						if(bullet_direction == 2'b00) // w (up)
							begin                                            
							Bullet_X_Motion <= 0;
							Bullet_Y_Motion<= -6;
							end
								
						if(bullet_direction == 2'b01) // a (left)
							begin
							Bullet_X_Motion <= -6;
							Bullet_Y_Motion<= 0;
							end
					end
					
					else if (count == 4'd2) 
					begin
							drawbullet_flag2 = 1'b1;
										
						if(bullet2_direction == 2'b10) // s (down)
							begin 
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= 6;
							end
							
							
						if(bullet2_direction == 2'b11) // d (right)
							begin 
							Bullet2_X_Motion <= 6;
							Bullet2_Y_Motion<= 0;
							end
						if(bullet2_direction == 2'b00) // w (up)
							begin                                            
							Bullet2_X_Motion <= 0;
							Bullet2_Y_Motion<= -6;
							end
								
						if(bullet2_direction == 2'b01) // a (left)
							begin
							Bullet2_X_Motion <= -6;
							Bullet2_Y_Motion<= 0;
							end
					end
						
						
						
					else if (count == 4'd3) 
						
					begin
						drawbullet_flag3 = 1'b1;
									
						if(bullet3_direction == 2'b10) // s (down)
							begin 
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= 6;
							end
							
							
						if(bullet3_direction == 2'b11) // d (right)
							begin 
							Bullet3_X_Motion <= 6;
							Bullet3_Y_Motion<= 0;
							end
						if(bullet3_direction == 2'b00) // w (up)
							begin                                            
							Bullet3_X_Motion <= 0;
							Bullet3_Y_Motion<= -6;
							end
								
						if(bullet3_direction == 2'b01) // a (left)
							begin
							Bullet3_X_Motion <= -6;
							Bullet3_Y_Motion<= 0;
							end
					end
						
							
						
				end
				
				
				///////////////////////////////////bullet 1 position/////////////////////////////
				
				 if (drawbullet_flag == 1)
				 begin
					 Bullet_Y_Pos <= (Bullet_Y_Pos + Bullet_Y_Motion);  // update bullet position
					 Bullet_X_Pos <= (Bullet_X_Pos + Bullet_X_Motion);
				 end
				 
				 else 
				 begin
				 	 Bullet_Y_Pos <= tankY;  // Update bullet position with tank position WHILE bullet has NOT BEEN FIRED
					 Bullet_X_Pos <= tankX;	 // SEEING IF USING THE TANKX/TANKY ASSIGNED VARIABLES DIRECTLY MAKES THIS BETTER
				 end
				 
				 ////////////////////////////////////bullet 1 direction///////////////////////////

				 if (drawbullet_flag == 1)
				 begin
					 bullet_direction <= bullet_direction;  // Update tank position
				 end
				 
				 else 
				 begin
				 	 bullet_direction <= direction;
				 end
				 				///////////////////////////////////bullet 2 position/////////////////////////////
				
				 if (drawbullet_flag2 == 1)
				 begin
					 Bullet2_Y_Pos <= (Bullet2_Y_Pos + Bullet2_Y_Motion);  // update bullet position
					 Bullet2_X_Pos <= (Bullet2_X_Pos + Bullet2_X_Motion);
				 end
				 
				 else 
				 begin
				 	 Bullet2_Y_Pos <= tankY;  // Update bullet position with tank position WHILE bullet has NOT BEEN FIRED
					 Bullet2_X_Pos <= tankX;	 // SEEING IF USING THE TANKX/TANKY ASSIGNED VARIABLES DIRECTLY MAKES THIS BETTER
				 end
				 
				 ////////////////////////////////////bullet 2 direction///////////////////////////

				 if (drawbullet_flag2 == 1)
				 begin
					 bullet2_direction <= bullet2_direction;  // Update tank position
				 end
				 
				 else 
				 begin
				 	 bullet2_direction <= direction;
				 end
				 				///////////////////////////////////bullet 3 position/////////////////////////////
				
				 if (drawbullet_flag3 == 1)
				 begin
					 Bullet3_Y_Pos <= (Bullet3_Y_Pos + Bullet3_Y_Motion);  // update bullet position
					 Bullet3_X_Pos <= (Bullet3_X_Pos + Bullet3_X_Motion);
				 end
				 
				 else 
				 begin
				 	 Bullet3_Y_Pos <= tankY;  // Update bullet position with tank position WHILE bullet has NOT BEEN FIRED
					 Bullet3_X_Pos <= tankX;	 // SEEING IF USING THE TANKX/TANKY ASSIGNED VARIABLES DIRECTLY MAKES THIS BETTER
				 end
				 
				 ////////////////////////////////////bullet 3 direction///////////////////////////

				 if (drawbullet_flag3 == 1)
				 begin
					 bullet3_direction <= bullet3_direction;  // Update tank position
				 end
				 
				 else 
				 begin
				 	 bullet3_direction <= direction;
				 end
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that tank_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of tank_Y_pos.  Will the new value of tank_Y_Motion be used,
          or the old?  How will this impact behavior of the tank during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
		
    end
	 
	 // ACTUAL MODULE SIGNAL INITIALIZATIONS FROM INTERNAL VARIABLE
       
    assign tankX = tank_X_Pos; 
   
    assign tankY = tank_Y_Pos;
   
    assign tankS = tank_Size;
	 
	 assign tank1_direction = direction;
	 
	 
	 assign BulletX = Bullet_X_Pos + 16;
	 
	 assign BulletY = Bullet_Y_Pos + 16;
	 
	 assign BulletS = Bullet_Size;
	 
	 assign bullet_flag = drawbullet_flag ;
	 
	 
	 assign Bullet2X = Bullet2_X_Pos + 16;
	 
	 assign Bullet2Y = Bullet2_Y_Pos + 16;
	 
	 assign Bullet2S = Bullet2_Size;
	 
	 assign bullet2_flag = drawbullet_flag2 ;
	 
	 
	 assign Bullet3X = Bullet3_X_Pos + 16;
	 
	 assign Bullet3Y = Bullet3_Y_Pos + 16;
	 
	 assign Bullet3S = Bullet3_Size;
	 
	 assign bullet3_flag = drawbullet_flag3 ;
	 

	 
	 
	 
	 // COLLISION HANDLING FOR TANK 1:
	 
	logic [16:0] C1bitmapaddress, C2bitmapaddress, C3bitmapaddress, C4bitmapaddress, mapaddress1,mapaddress2;
	logic collisionsignal1, collisionsignal2;
	logic tankcollisionsignal;
//	
	// C1//////C2
	// //////////
	// //////////
	// //////////
	// C3//////C4
	
//
	assign C1bitmapaddress = (((tankX * 320) / 640) + ((tankY * 240) / 480) * 320);
	assign C2bitmapaddress = ((((tankX + 32) * 320) / 640) + ((tankY * 240) / 480) * 320);
	assign C3bitmapaddress = (((tankX * 320) / 640) + (((tankY + 32) * 240) / 480) * 320 );
	assign C4bitmapaddress = ((((tankX + 32)* 320) / 640) + (((tankY + 32)* 240) / 480) * 320);
	
	always_comb begin
	if(tank1_direction == 2'b00)
		begin 
		mapaddress1 = C1bitmapaddress;
		mapaddress2 = C2bitmapaddress;
		end
	else if(tank1_direction == 2'b01)
		begin 
		mapaddress1 = C3bitmapaddress;
		mapaddress2 = C1bitmapaddress;
		end
	else if(tank1_direction == 2'b10)
		begin 
		mapaddress1 = C3bitmapaddress;
		mapaddress2 = C4bitmapaddress;
		end
	else
		begin 
		mapaddress1 = C4bitmapaddress;
		mapaddress2 = C2bitmapaddress;
		end
	
	end
	
	bitmap_rom tank1_collision1(.clock(fast_clock),.address(mapaddress1),.q(collisionsignal1));
	bitmap_rom tank1_collision2(.clock(fast_clock),.address(mapaddress2),.q(collisionsignal2));
	
	
	always_comb begin
	
		if (collisionsignal1 || collisionsignal2) tankcollisionsignal = 1;
		
		else tankcollisionsignal = 0;
	
	end
	
	
//	logic [16:0] bulletbitmapaddress;
	logic [16:0] bullet1bitmapaddress, bullet2bitmapaddress, bullet3bitmapaddress;
	logic bullet1collisionsignal, bullet2collisionsignal, bullet3collisionsignal;

	assign bullet1bitmapaddress = (((BulletX + 1) * 320) / 640) + ((((BulletY + 1) * 240) / 480) * 320);
	assign bullet2bitmapaddress = (((Bullet2X + 1) * 320) / 640) + ((((Bullet2Y + 1) * 240) / 480) * 320);
	assign bullet3bitmapaddress = (((Bullet3X + 1) * 320) / 640) + ((((Bullet3Y + 1) * 240) / 480) * 320);
	
//	always_comb begin
//	
//		if (count == 4'd2) begin
//		bulletbitmapaddress = bullet1bitmapaddress;
//		//LED876_BULLETBITMAPADDRESS = 3'b001;
//		end
//		
//		else if (count == 4'd3) begin 
//		bulletbitmapaddress = bullet2bitmapaddress;
//		//LED876_BULLETBITMAPADDRESS = 3'b010;
//		end
//		
//		else begin
//		bulletbitmapaddress = bullet3bitmapaddress; // for bullet 3
//	   //LED876_BULLETBITMAPADDRESS = 3'b010;
//		end
//		
//
//	end
	 
	bulletmap_rom bullet1_collision(.clock(fast_clock),.address(bullet1bitmapaddress),.q(bullet1collisionsignal));
	bulletmap_rom bullet2_collision(.clock(fast_clock),.address(bullet2bitmapaddress),.q(bullet2collisionsignal));
	bulletmap_rom bullet3_collision(.clock(fast_clock),.address(bullet3bitmapaddress),.q(bullet3collisionsignal));
    

endmodule
