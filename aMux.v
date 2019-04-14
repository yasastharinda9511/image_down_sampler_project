module aMux(a_flag, PC, DR, R1, R2, R3, R4, R5, A_bus);
	input [2:0] a_flag;
	input [15:0] PC, DR, R1, R2, R3, R4, R5;
	output [15:0] A_bus;
	reg [15:0] A_bus;
	always@(*)
		begin
			case(a_flag)
				3'd1 : A_bus = PC;
				3'd2 : A_bus = DR;
				3'd3 : A_bus = R1;
				3'd4 : A_bus = R2;
				3'd5 : A_bus = R3;
				3'd6 : A_bus = R4;
				3'd7 : A_bus = R5;
			default:
				A_bus=16'dz;
			endcase
		end
endmodule
	