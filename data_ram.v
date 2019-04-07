module data_ram(data_in,data_out,clk,write_en,address);
	input [19:0] address;
	input [15:0] data_in;
	input write_en,clk;
	output [15:0] data_out;
	reg [15:0] memory [1048575:0]; //2MB memory(16 bit width and 2**20 memory locations)
	
	always@(posedge clk)
		begin
			if(write_en) memory[address]=data_in;
			
		end
			
		assign data_out =memory[address];
endmodule
