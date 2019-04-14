module AR(address,TR,DR,merge_en,clk);
	output reg [19:0] address;
	input merge_en,clk;
	input [15:0] DR;
	input [3:0] TR;
	always@(posedge clk)
		begin
		if(merge_en) address={TR,DR};
		end
	
endmodule 
