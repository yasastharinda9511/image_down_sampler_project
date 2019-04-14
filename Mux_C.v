
module Mux_C(constant, AC, sel, out);
	input[15:0] constant, AC;
	input sel;
	output reg [15:0]  out;


	always @ (*) 
		begin
			case (sel)
				1'b0 :  out <= constant;
				1'b1 :  out <= AC;
				
			endcase
	end
endmodule 