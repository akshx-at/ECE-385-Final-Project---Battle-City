module map_generator (input [9:0] DrawX, DrawY,
							 output [2:0] sprite_signal);
							
							
always_comb begin
							
	if ((DrawX >= 100 && DrawX < 180 && DrawY >= 100 && DrawY <= 120) || (DrawX >= 180 && DrawX <= 220 && DrawY >= 100 && DrawY <= 120) || ((DrawX >= 300 && DrawX < 380 && DrawY >= 300 && DrawY <= 320) )|| (DrawX >= 400 && DrawX < 480 && DrawY >= 400 && DrawY <= 420) ) sprite_signal = 3'b001; // set to brick wall
	
	else if (DrawX >= 140 && DrawX < 180 && DrawY >= 100 && DrawY <= 120) sprite_signal = 3'b010; // set to grass
	
	else sprite_signal = 3'b000; // background
														
end

endmodule
