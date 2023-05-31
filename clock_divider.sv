module clock_divider(
  input logic input_clock,
  input logic reset,
  output logic output_clock
);

logic [30:0] counter = 30'd0; // 4-bit counter for dividing clock by 16

always_ff @(posedge input_clock)
begin
  if (reset)
  begin
    counter <= 30'd0;
	 output_clock <= 1'b0;
	end
	 
  else if (counter == 30'd1) begin // is
    counter <= 30'd0;
	 output_clock <= ~output_clock;
	 end
	 
  else
    counter <= counter + 1;
end

//assign output_clock = counter == 4'd0 ? 1'b1 : 1'b0; // what does this line do?

endmodule