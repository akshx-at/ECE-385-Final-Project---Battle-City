module lfsr (
			input logic Clk,
			input logic reset,
//			input logic stop,
			output logic [8:0] out,
			input logic Enable
);


logic linear_feedback;
logic [31:1] stage;

logic [8:0] meta1, meta2;

assign out = meta2;

always_ff @ (posedge Clk)
begin

if(reset)
  begin
    meta1 <= 1'b0;
    meta2 <= 1'b0;
  end
  
else if(Clk && Enable)
  begin
    meta1 <= stage[9:1];
    meta2 <= meta1;
  end
  
end

assign stage[1] = ~&(stage[2] ^ stage[1]);
assign stage[2] = !stage[3];
assign stage[3] = !stage[4] ^ stage[1];
assign stage[4] = !stage[5] ^ stage[1];
assign stage[5] = !stage[6] ^ stage[1];
assign stage[6] = !stage[7] ^ stage[1];
assign stage[7] = !stage[8];
assign stage[8] = !stage[9] ^ stage[1];
assign stage[9] = !stage[10] ^ stage[1];
assign stage[10] = !stage[11];
assign stage[11] = !stage[12];
assign stage[12] = !stage[13] ^ stage[1];
assign stage[13] = !stage[14];
assign stage[14] = !stage[15] ^ stage[1];
assign stage[15] = !stage[16] ^ stage[1];
assign stage[16] = !stage[17] ^ stage[1];
assign stage[17] = !stage[18];
assign stage[18] = !stage[19];
assign stage[19] = !stage[20] ^ stage[1];
assign stage[20] = !stage[21] ^ stage[1];
assign stage[21] = !stage[22];
assign stage[22] = !stage[23];
assign stage[23] = !stage[24];
assign stage[24] = !stage[25];
assign stage[25] = !stage[26];
assign stage[26] = !stage[27] ^ stage[1];
assign stage[27] = !stage[28];
assign stage[28] = !stage[29];
assign stage[29] = !stage[30];
assign stage[30] = !stage[31];
assign stage[31] = !stage[1];

endmodule
