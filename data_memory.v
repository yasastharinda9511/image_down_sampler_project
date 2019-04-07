module data_memory(clk,address,data_in,data_out,write_en);
	input clk,write_en;
	input [0:15] address;
	input [0:7] data_in;
	output [0:7] data_out;
	reg [7:0] data_memory [1023:0];
	
	always @(posedge clk)
		begin
			if(write_en) data_memory[address]=data_in;
		end
	assign data_out=data_memory[address];
endmodule 
