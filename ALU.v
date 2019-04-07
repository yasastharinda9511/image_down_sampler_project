module ALU(a, b, control, result, z, g);
	input [15:0] a, b;
	input [2:0] control;
	output reg [15:0] result;
	output z, g;

	always @(*)
		begin 
		 case(control)
			 3'b000: result = a + b;
			 3'b001: result = a - b;
			 3'b010: result = ~a;
			 3'b011: result = a<<b;
			 3'b100: result = a>>b;
			 3'b101: result = a & b;
			 3'b110: result = a | b; 
		 
			default:result = a + b; 
		 endcase
		end
assign z = (result==16'd0) ? 1'b1 : 1'b0;
assign g = (a<b) ? 1'b1:1'b0;
 
endmodule
