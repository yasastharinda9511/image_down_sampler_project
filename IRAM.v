module IRAM(address,word_out,clk);
	input [15:0] address;
	input clk;
	output [15:0] word_out;
	reg [511:0] memory;
	
	initial
		begin
		end
	
	assign word_out=memory[address];
endmodule
