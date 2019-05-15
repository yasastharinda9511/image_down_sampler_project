module TR_reg(most_sig,write_en,c_bus,clk);
	output reg [3:0] most_sig; // TO AR[19:16]
	input clk,write_en;
	input [15:0] c_bus;
	always@(posedge clk)
		begin
			if(write_en) most_sig=c_bus[15:12];
		end
endmodule
