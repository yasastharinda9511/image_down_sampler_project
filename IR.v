module IR(en,word,instruction,clk);
	input en;
	output reg [15:0] word;
	input [15:0] instruction;
	input clk;
	
	always@(clk) begin
		if(en) word=instruction;
	end
endmodule 