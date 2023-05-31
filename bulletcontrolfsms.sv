module bulletcontrolfsm (input logic bulletwallcollisionsignal, bulletankcollisionsignal, fsm_clock, 
								 input logic [7:0] keycode1, keycode2, keycode3, keycode4,
								 output logic drawbulletsignal);
								 
								 
								 
enum logic [2:0] {bullet_flying, bullet_gone} state, next_state;
						  

always_ff @ (posedge fsm_clock) begin

	if (reset) state <= bullet_gone;
	
	else state <= next_state;

end



always_comb begin

	next_state = state; // power OF FSM WOW GREAT
	drawbulletsignal = 1'b0;
	
	unique case (state) 

		bullet_gone: begin
		
		if (keycode1 == 8'd40 || keycode2 == 8'd40 || keycode3 == 8'd40 || keycode4 == 8'd40 ||
			 
			 next_state = bullet_flying;
			 
		else next_state = bullet_gone;
			 
			 
		end
			 
		
		bullet_flying: begin
		
		if (bulletwallcollisionsignal || bullettankcollisionsignal) next_state = bullet_gone;
		
		else next_state = bullet_flying;
		
		end
		
		
		
		default: ;
		
		
		
	endcase
	
	
	case (state)
	
		bullet_gone: drawbulletsignal = 1'b0;
		
		bullet_flying: drawbulletsignal = 1'b1;
		
		default: ;
		
	endcase
	
end