module key_counter (
  input clk, reset,
  input [7:0] keycode0, keycode1, keycode2, keycode3,
  output [3:0] count);


logic keydown;
always_comb begin

if (keycode0 == 8'd44 || keycode1 == 8'd44 || keycode2 == 8'd44 || keycode3 == 8'd44)
keydown = 1'b1;

else 
keydown = 1'b0;

end


// define the states of the state machine
enum logic [20:0]{
  IDLE1,
  WAIT1,
  WAIT2,
  WAIT3,
  COUNT_ONE,
  IDLE2,
  WAIT4,
  WAIT5,
  WAIT6,
  COUNT_TWO,
  IDLE3,
  WAIT7,
  WAIT8,
  WAIT9,
  COUNT_THREE
}state, next_state;

 
always_ff @ (posedge clk) begin

if (reset) state <= COUNT_ONE;
	
else state <= next_state;


end



always_comb begin

next_state = state;
count = 4'd1;

unique case(state)
		
    COUNT_ONE:
      // wait for key release before transitioning to COUNTING state
      if (keydown) next_state = IDLE1;
		
		else next_state = COUNT_ONE;

    IDLE1:
      // increment the counter and transition back to IDLE state
		
		 if (!keydown) next_state = WAIT1;
		 
		 else next_state = IDLE1;
		 
	 WAIT1:
		 next_state = WAIT2;
		 
	 WAIT2:
		 next_state = WAIT3;
		 
	 WAIT3:
		 next_state = COUNT_TWO;
		 
	 COUNT_TWO:
	 
		 if (keydown) next_state = IDLE2;
		 
		 else next_state = COUNT_TWO;
		 
		 
	 IDLE2:
	 
		 if (!keydown) next_state = WAIT4;
		 
		 else next_state = IDLE2;
		 
	 WAIT4:
		 next_state = WAIT5;
		 
	 WAIT5:
		 next_state = WAIT6;
		 
	 WAIT6:
		 next_state = COUNT_THREE;
		 
		 
	 COUNT_THREE:
			 
		 if (keydown) next_state = IDLE3;
	 
		 else next_state = COUNT_THREE;
		 
		 
	 IDLE3:
		 
		 if (!keydown) next_state = WAIT7;
		 
		 else next_state = IDLE3;
		 
		 
	 WAIT7:
		 next_state = WAIT8;
		 
	 WAIT8:
		 next_state = WAIT9;
		 
	 WAIT9:
		 next_state = COUNT_ONE;
	
	
	 default: ;
		
		
endcase
  
  
case(state)
		 
    COUNT_ONE: count = 4'd1;
	 
	 COUNT_TWO: count = 4'd2;
	 
	 COUNT_THREE: count = 4'd3;
	 
	 default: count = 4'd0;
	 
endcase
  

end

endmodule



/////////////////////////////////////////////


module key_counter2 (
  input clk, reset,
  input [7:0] keycode0, keycode1, keycode2, keycode3,
  output [3:0] count);


logic keydown;
always_comb begin

if (keycode0 == 8'd40 || keycode1 == 8'd40 || keycode2 == 8'd40 || keycode3 == 8'd40)
keydown = 1'b1;

else 
keydown = 1'b0;

end


// define the states of the state machine
enum logic [20:0]{
  IDLE1,
  WAIT1,
  WAIT2,
  WAIT3,
  COUNT_ONE,
  IDLE2,
  WAIT4,
  WAIT5,
  WAIT6,
  COUNT_TWO,
  IDLE3,
  WAIT7,
  WAIT8,
  WAIT9,
  COUNT_THREE
}state, next_state;

 
always_ff @ (posedge clk) begin

if (reset) state <= COUNT_ONE;
	
else state <= next_state;


end



always_comb begin

next_state = state;
count = 4'd1;

unique case(state)
		
    COUNT_ONE:
      // wait for key release before transitioning to COUNTING state
      if (keydown) next_state = IDLE1;
		
		else next_state = COUNT_ONE;

    IDLE1:
      // increment the counter and transition back to IDLE state
		
		 if (!keydown) next_state = WAIT1;
		 
		 else next_state = IDLE1;
		 
	 WAIT1:
		 next_state = WAIT2;
		 
	 WAIT2:
		 next_state = WAIT3;
		 
	 WAIT3:
		 next_state = COUNT_TWO;
		 
	 COUNT_TWO:
	 
		 if (keydown) next_state = IDLE2;
		 
		 else next_state = COUNT_TWO;
		 
		 
	 IDLE2:
	 
		 if (!keydown) next_state = WAIT4;
		 
		 else next_state = IDLE2;
		 
	 WAIT4:
		 next_state = WAIT5;
		 
	 WAIT5:
		 next_state = WAIT6;
		 
	 WAIT6:
		 next_state = COUNT_THREE;
		 
		 
	 COUNT_THREE:
			 
		 if (keydown) next_state = IDLE3;
	 
		 else next_state = COUNT_THREE;
		 
		 
	 IDLE3:
		 
		 if (!keydown) next_state = WAIT7;
		 
		 else next_state = IDLE3;
		 
		 
	 WAIT7:
		 next_state = WAIT8;
		 
	 WAIT8:
		 next_state = WAIT9;
		 
	 WAIT9:
		 next_state = COUNT_ONE;
	
	
	 default: ;
		
		
endcase
  
  
case(state)
		 
    COUNT_ONE: count = 4'd1;
	 
	 COUNT_TWO: count = 4'd2;
	 
	 COUNT_THREE: count = 4'd3;
	 
	 default: count = 4'd0;
	 
endcase
  

end

endmodule