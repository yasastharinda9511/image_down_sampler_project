module registerR1(clk,en,c_in,a_out,b_out);
	input clk, en;
	input [15:0] c_in;
	output [15:0] a_out, b_out;
	reg [15:0] memory;
	//reg [15:0] a_out, b_out;
	always@(posedge clk)
		begin
			if (en)
				//a_out <= c_in;
				//b_out <= c_in;
				memory =c_in;
		end

	assign a_out = memory;
	assign b_out = memory;
endmodule 