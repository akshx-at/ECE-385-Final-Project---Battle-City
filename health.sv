module health (input collision, clock, reset, shield_on,
					output logic [5:0] health,
					output tank_dead);
					

					
logic posedge_detected, signal_in_prev;

										
always_ff @(posedge clock) begin
    
	 if (reset) posedge_detected <= 0;
	 
	 else if (health != 6'd0) posedge_detected <= collision && !signal_in_prev; // press down, so collision goes high and signal in goes high too 
    
    signal_in_prev <= collision; // but then immediately, signal in prev goes high so posedge detected goes loww 

end

// and when collision goes back down, posedge remains 0


always_ff @ (posedge clock) begin

	if (reset) begin
		health <= 6'd50;
		tank_dead <= 1'b0;
		
	end

	else if (posedge_detected && !shield_on) begin
	health <= health - 10;
	tank_dead <= 1'b0;
	end
	
	else if (health == 6'd0) begin
	health <= 6'd0;
	tank_dead <= 1'b1;
	end

end


//always_comb	begin
//
//	if (health == 6'd0) tank_dead = 1'b1;
//		
//	else tank_dead = 1'b0;
//
//
//end

endmodule