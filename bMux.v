module bMux(b_flag, PC, DR, R1, R2, R3, R4, R5, B_bus);
	input [2:0] b_flag;
	input [15:0] PC, DR, R1, R2, R3, R4, R5;
	output [15:0] B_bus;
	reg [15:0] B_bus;
	always@(*)
		begin
			case(b_flag)
				3'd1 : B_bus = PC;
				3'd2 : B_bus = DR;
				3'd3 : B_bus = R1;
				3'd4 : B_bus = R2;
				3'd5 : B_bus = R3;
				3'd6 : B_bus = R4;
				3'd7 : B_bus = R5;
			default:
				B_bus=16'dz;
			endcase
		end
endmodule
	