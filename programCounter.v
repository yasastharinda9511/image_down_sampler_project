module programCounter(clk,en,incr_en,c_in,a_out,b_out,im_out);
	input clk, en, incr_en;
	input [15:0] c_in;
	output [15:0] a_out, b_out, im_out;
	reg [15:0] memory_counter=16'd0; 
	always@(posedge clk)
		begin
			if (en) memory_counter=c_in;
			if (incr_en) memory_counter=memory_counter+1;
				
		end 
		
		assign a_out = memory_counter;
		assign b_out = memory_counter;
		assign im_out = memory_counter;
endmodule 