module ALU(a, b, control, result, z, g);
	input [15:0] a, b;
	input [3:0] control;
	output reg [15:0] result;
	output z, g;

	always @(*)
		begin 
		 case(control)
			 4'd1: result = a + b;
			 4'd2: result = a - b;
			 4'd3: result = a*b;
			 4'd4: result =a/b;
			 4'd5: result = ~a;
			 4'd6: result = a<<b;
			 4'd7: result = a>>b;
			 4'd8: result = a & b;
			 4'd9: result = a | b; 
			 
			default:result = a + b; 
		 endcase
		end
assign z = (result==16'd0) ? 1'b1 : 1'b0;
assign g = (a<b) ? 1'b1:1'b0;
 
endmodule
