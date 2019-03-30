module data_register(write_en,data,a_bus,b_bus,c_bus,least_sig,clk);
	input write_en,clk;
	output [15:0] data;
	reg [15:0] memory;
	output [15:0] a_bus, b_bus,least_sig;
	input [15:0] c_bus;
	
	always@(posedge clk)
		begin 
			if(write_en) memory = c_bus;
		end
	
	assign a_bus=memory;
	assign b_bus=memory;
	assign data =memory;
	assign least_sig = memory; 
			
endmodule 
