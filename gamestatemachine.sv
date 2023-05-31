module game_states (input tank1gaya, tank2gaya, fsm_clock, reset,
						  input [7:0] keycode,
						  output game_on, explosion1_on, explosion2_on, death_screenP1, death_screenP2);
						  
						  

enum logic [5:0] {halted, game_state, explode1, explode2, explode3, explode4, explode5, explode6, death_screen_P1, death_screen_P2} state, next_state;
						  


always_ff @ (posedge fsm_clock) begin

	if (reset || keycode == 8'd16) state <= halted; // menu button or reset (M)
	
	else state <= next_state;

end



always_comb begin

	next_state = state; // power OF FSM WOW GREAT
	game_on = 1'b1;
	explosion1_on = 1'b0;
	explosion2_on = 1'b0;
	death_screenP1 = 1'b0;
	death_screenP2 = 1'b0;
//	LEDOUT4 = 1'b0;
	
	unique case (state) 

		halted: if (keycode == 8'd88) next_state = game_state; // enter key
						else next_state = halted;
		
		game_state: if (tank1gaya || tank2gaya) next_state = explode1;
						else next_state = game_state;
						
						
		explode1: next_state = explode2;
						
		explode2: next_state = explode3;
		
		explode3: next_state = explode4;
		
		explode4: next_state = explode5;
		
		explode5: next_state = explode6;
		
		explode6: begin
		
			if (tank1gaya) next_state = death_screen_P1;
			
			else if (tank2gaya) next_state = death_screen_P2;
			
			else next_state = death_screen_P1; // make player 1 win in weird ass cases
		
		
		end

						
		death_screen_P1: begin
		
		// d28 is Y
		// d16 is M
		
			if (keycode == 8'd28) next_state = game_state;
			
			else if (keycode == 8'd16) next_state = halted;
								
			else next_state = death_screen_P1;
		
		end
		
		death_screen_P2: begin
		
			if (keycode == 8'd28) next_state = game_state;
			
			else if (keycode == 8'd16) next_state = halted;
								
			else next_state = death_screen_P2;
		
		end
		
	
		default: ;
		
		
	endcase
	
	
	case (state)
	
		halted: begin 
			game_on = 1'b0;
			death_screenP1 = 1'b0;
			death_screenP2 = 1'b0;
		
		end
		
		explode1: explosion1_on = 1'b1;
		
		explode2: explosion2_on = 1'b1;
		
		explode3: explosion1_on = 1'b1;
		
		explode4: explosion2_on = 1'b1;
		
		explode5: explosion1_on = 1'b1;
		
		explode6: explosion2_on = 1'b1;
		
		death_screen_P1: begin
		
			death_screenP1 = 1'b1;
			game_on = 1'b0;
			
		end
		
		death_screen_P2: begin
		
			death_screenP2 = 1'b1;
			game_on = 1'b0;
			
		end
		
		default: begin
		game_on = 1'b1;
		explosion1_on = 1'b0;
		explosion2_on = 1'b0;
		death_screenP1 = 1'b0;
		death_screenP2 = 1'b0;
		end
		
	endcase
	
end


//1st state: start screen, default: some backg, map selection/tank color
//
//if enter then
//
//2nd state: game state (keep background loaded, encapsulate all background generation logic in a game state variable)
//
//
//move to this state if you hit a bomb or bullet hits you
//
//// randomly generate a mine somewhere on the map using bounding logic, hardcoded, using random generation module
//
//3rd state: game over (3 substates for explosion animation, 3.1 -> first explosion sprite, 3.2 -> second explosion sprite, 3.3 -> third explosion state)
//


//
//animate tank fsm, keep moving between 2 states, use counter, move between 0 and 1 for a sprite depending on whether you are at an even or odd count
//bullet hits wall fsm to show explosion -> so when draw bullet flag drops to 0, this fsm will have a temp signal go up to show explosion and then switch back to regular state (no explosion)...
//create a flag that goes and draws an explosion in color mapper
endmodule 