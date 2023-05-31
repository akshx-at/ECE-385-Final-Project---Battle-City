//module shield (input reset, clock, shield_acquired,
//					output shield_status, LEDshield);
//
//
//enum logic [5:0] {no_shield, shield_ali} state, next_state; 
//
//
//always_ff @ (posedge clock) begin
//
//	if (reset) state <= no_shield
//
//	else state <= next_state;
//
//end
//
//
//always_comb begin
//	
//	next_state = state;
//
//	case (state) begin
//	
//		
//	
//	
//	
//	endcase
//
//
//end
//
//
//always_comb begin
//	if (shield_acquired) shield_status = 1'b1;
//	else shield_status = 1'b0;
//end
//
//										
////always_ff @(posedge clock) begin
//
////    if (reset) begin
////		 count <= 4'd0;
////		 shield_status = 1'b0;
////	 end
//	 
////	 if (shield_acquired) begin
////		 shield_status <= 1'b1;
////	 end
//	 
////      // The count increments when either the clock or trigger is high
//////      if ( (shield_acquired || count > 4'd0) && count != 4'd10 ) begin
////
////
//////		else if (count == 4'd10) begin
//////			count <= 4'd0;
//////			shield_status = 1'b0;
////		end
////		
////    end
//	 
////end
//
//
//endmodule
