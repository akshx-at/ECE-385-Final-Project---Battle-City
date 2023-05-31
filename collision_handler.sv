module collision_handler(input logic [9:0] bullet1T1xpos, bullet1T1ypos, 
								bullet2T1xpos, bullet2T1ypos,
								bullet3T1xpos, bullet3T1ypos,
						
								bullet1T2xpos, bullet1T2ypos, 
								bullet2T2xpos, bullet2T2ypos,
								bullet3T2xpos, bullet3T2ypos,  
								
								tank1xpos, tank1ypos, tank2xpos, tank2ypos,
								
								input logic clock, 
								
								output bullet1tank2collision, bullet2tank1collision);
	
	
// C1   C2

// C3   C4

logic [9:0] tank2C1x, tank2C1y, tank2C2x, tank2C2y, tank2C3x, tank2C3y, tank2C4x, tank2C4y;
logic [9:0] tank1C1x, tank1C1y, tank1C2x, tank1C2y, tank1C3x, tank1C3y, tank1C4x, tank1C4y;

assign tank2C1x = tank2xpos;
assign tank2C1y = tank2ypos;

assign tank2C2x = tank2xpos + 32;
assign tank2C2y = tank2ypos;

assign tank2C3x = tank2xpos;
assign tank2C3y = tank2ypos + 32;

assign tank2C4x = tank2xpos + 32;
assign tank2C4y = tank2ypos + 32;


/////////////////////////////////////////////////////////////


assign tank1C1x = tank1xpos;
assign tank1C1y = tank1ypos;

assign tank1C2x = tank1xpos + 32;
assign tank1C2y = tank1ypos;

assign tank1C3x = tank1xpos;
assign tank1C3y = tank1ypos + 32;

assign tank1C4x = tank1xpos + 32;
assign tank1C4y = tank1ypos + 32;


								  
always_comb begin

 if ((bullet1T1xpos > tank2C1x && bullet1T1xpos < tank2C2x) && (bullet1T1ypos > tank2C1y && bullet1T1ypos < tank2C3y) ||
	  (bullet2T1xpos > tank2C1x && bullet2T1xpos < tank2C2x) && (bullet2T1ypos > tank2C1y && bullet2T1ypos < tank2C3y) ||
	  (bullet3T1xpos > tank2C1x && bullet3T1xpos < tank2C2x) && (bullet3T1ypos > tank2C1y && bullet3T1ypos < tank2C3y)) 
	  
	  bullet1tank2collision = 1;
 
 else bullet1tank2collision = 0;

end

always_comb begin

 if ((bullet1T2xpos > tank1C1x && bullet1T2xpos < tank1C2x) && (bullet1T2ypos > tank1C1y && bullet1T2ypos < tank1C3y) ||
     (bullet2T2xpos > tank1C1x && bullet2T2xpos < tank1C2x) && (bullet2T2ypos > tank1C1y && bullet2T2ypos < tank1C3y) ||
	  (bullet3T2xpos > tank1C1x && bullet3T2xpos < tank1C2x) && (bullet3T2ypos > tank1C1y && bullet3T2ypos < tank1C3y))
 
	  bullet2tank1collision = 1;
 
 else bullet2tank1collision = 0;

end


endmodule
								  
								  

								  
								