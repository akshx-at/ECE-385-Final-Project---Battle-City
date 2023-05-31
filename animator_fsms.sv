module tank1_animator (input logic animator_clock, animator_reset,
							 input logic [7:0] keycode1, keycode2, keycode3, keycode4,
							 output logic tank1picksignal);
							 
							 
enum logic [1:0] {animation1, animation2} state, next_state;

always_ff @ (posedge animator_clock) begin

if (animator_reset) begin
	
	state <= animation1;

end

else state <= next_state;

end 



always_comb begin

next_state = state;
tank1picksignal = 1'b1;

unique case (state)

animation1: begin

	if (keycode1 == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A ||
		 keycode1 == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07 ||
		 keycode1 == 8'h16 || keycode2 == 8'h16 || keycode3 == 8'h16 || keycode4 == 8'h16 ||
		 keycode1 == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04) 
	
	next_state = animation2;
	
	else next_state = animation1;
	
end

animation2: begin

if 	(keycode1 == 8'h1A || keycode2 == 8'h1A || keycode3 == 8'h1A || keycode4 == 8'h1A ||
		 keycode1 == 8'h07 || keycode2 == 8'h07 || keycode3 == 8'h07 || keycode4 == 8'h07 ||
		 keycode1 == 8'h16 || keycode2 == 8'h16 || keycode3 == 8'h16 || keycode4 == 8'h16 ||
		 keycode1 == 8'h04 || keycode2 == 8'h04 || keycode3 == 8'h04 || keycode4 == 8'h04) 
	
	next_state = animation1;
	
	else next_state = animation2;
	
end


default: ;

endcase


case (state) 

	animation1: tank1picksignal = 1'b1;

	animation2: tank1picksignal = 1'b0;

	default: ;

endcase

end

endmodule

///////////////////////////////////////////////////////////////////////////////////

module tank2_animator (input logic animator_clock, animator_reset,
							 input logic [7:0] keycode1, keycode2, keycode3, keycode4,
							 output logic tank2picksignal);
							 
							 
enum logic [1:0] {animation1, animation2} state, next_state;

always_ff @ (posedge animator_clock) begin

if (animator_reset) begin
	
	state <= animation1;

end

else state <= next_state;

end 



always_comb begin

next_state = state;
tank2picksignal = 1'b1;

unique case (state)

animation1: begin

	if (keycode1 == 8'd82 || keycode2 == 8'd82 || keycode3 == 8'd82 || keycode4 == 8'd82 ||
		 keycode1 == 8'd79 || keycode2 == 8'd79 || keycode3 == 8'd79 || keycode4 == 8'd79 ||
		 keycode1 == 8'd81 || keycode2 == 8'd81 || keycode3 == 8'd81 || keycode4 == 8'd81 ||
		 keycode1 == 8'd80 || keycode2 == 8'd80 || keycode3 == 8'd80 || keycode4 == 8'd80) 
	
	next_state = animation2;
	
	else next_state = animation1;
	
end

animation2: begin

if 	(keycode1 == 8'd82 || keycode2 == 8'd82 || keycode3 == 8'd82 || keycode4 == 8'd82 ||
		 keycode1 == 8'd79 || keycode2 == 8'd79 || keycode3 == 8'd79 || keycode4 == 8'd79 ||
		 keycode1 == 8'd81 || keycode2 == 8'd81 || keycode3 == 8'd81 || keycode4 == 8'd81 ||
		 keycode1 == 8'd80 || keycode2 == 8'd80 || keycode3 == 8'd80 || keycode4 == 8'd80) 
	
	next_state = animation1;
	
	else next_state = animation2;
	
end


default: ;

endcase


case (state) 

	animation1: tank2picksignal = 1'b1;

	animation2: tank2picksignal = 1'b0;

	default: ;

endcase

end

endmodule