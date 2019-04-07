module write_en_decoder(selection_en, PC, DR, R1, R2, R3, R4, R5);
	input [2:0] selection_en;
	output PC, DR, R1, R2, R3, R4, R5;
	
	assign PC=(selection_en ==3'd0) ? 1'b1: 1'b0;
	assign DR=(selection_en ==3'd1) ? 1'b1: 1'b0;
	assign R1=(selection_en ==3'd2) ? 1'b1: 1'b0;
	assign R2=(selection_en ==3'd3) ? 1'b1: 1'b0;
	assign R3=(selection_en ==3'd4) ? 1'b1: 1'b0;
	assign R4=(selection_en ==3'd5) ? 1'b1: 1'b0;
	assign R5=(selection_en ==3'd6) ? 1'b1: 1'b0;
endmodule
				