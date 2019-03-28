module Mux_C(input[15:0] address, 
				input[15:0] AC,
				input sel,
				output[15:0] out);


	always @ (address or AC or sel) 
		begin
			case (sel)
				1'b0 :  out <= address;
				1'b1 :  out <= AC;
				
			endcase
	end

endmodule 



