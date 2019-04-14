module data_register(write_en,data_in,data_out,a_bus,b_bus,c_bus,least_sig,clk,mem_write_en);
	input write_en,clk,mem_write_en;
	reg [15:0] memory;
	output [15:0] a_bus, b_bus,least_sig, data_out;
	input [15:0] c_bus, data_in;
	//output [15:0]check_a;
	
	always@(posedge clk)
		begin 
			if(write_en) memory = c_bus;
			if(mem_write_en) memory = data_in;
		end
	
	assign a_bus=memory;
	assign b_bus=memory;
	assign data_out =memory;
	assign least_sig = memory;
	//assign check_a=memory;
			
endmodule 
