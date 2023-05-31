module pos_edge_detector (
  input logic frame_clk,
  input logic reset,
  input logic signal_in,
  output logic posedge_detected
);

  logic signal_in_prev;

  always_ff @(posedge frame_clk) begin
    if (reset) begin
      posedge_detected <= 0;
    end 
	 
	 else begin
      posedge_detected <= signal_in && !signal_in_prev;
    end
    signal_in_prev <= signal_in;
  end

endmodule