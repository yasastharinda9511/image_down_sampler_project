
module IRAM(address,word_out,clk);
	input [15:0] address;
	input clk;
	output [15:0] word_out;
	reg [15:0] memory [511:0];
	
	parameter ADD=6'd1,SUB=6'd2,MUL=6'd3,DIV=6'd4,NEGATION=6'd5, LEFT_SHIFT=6'd6, RIGHT_SHIFT =6'd7, BIT_AND =6'd8, BIT_OR =6'd9, CONSTANT2REG=6'd10,MERGE=6'd11; 
	parameter MEM_WRITE= 6'd12, MEM_READ = 6'd13, JUMPZ =6'd14, NJUMPZ =6'd15,OVER= 6'd16;

	parameter PC =3'd1,DR =3'd2,R1 =3'd3,R2 =3'd4,R3 =3'd5,R4 =3'd6,R5 =3'd7;//RELATED TO THE A_BUS AND B_BUS
	
	parameter C_PC=4'd1,C_DR=4'd2,C_R1=4'd3,C_R2=4'd4,C_R3=4'd5,C_R4=4'd6,C_R5=4'd7,C_TR=4'd8,C_NO_DEST= 4'd0; //RELATED TO THE C_BUS
	
	parameter DCC= 6'bXXXXXX; //DONT_cARE_COSTANT
	
	parameter DCWR = 10'bXXXXXXXXXx; //DONT_cARE_WRITE_READ
	
	parameter DCTR=12'bxxxxxxxxxxxx;
	
	
	initial
		begin          //0123456789ABCDEF
			memory[0]={CONSTANT2REG,C_R1,DCC};
			memory[1]=16'd1235;
			memory[2]={CONSTANT2REG,C_R2,DCC};
			memory[3]=16'd25;
			memory[4]={CONSTANT2REG,C_R3,DCC};
			memory[5]=16'd0;
			memory[6]={CONSTANT2REG,C_DR,DCC};
			memory[7]=16'd25;
			memory[8]={CONSTANT2REG,C_TR,DCC};
			memory[9]=16'd0;
			memory[10]={MERGE,DCWR};
			memory[11]={ADD,R1,R3,C_DR};
		   memory[12]={MEM_WRITE,DCWR};
			memory[13]={CONSTANT2REG,C_DR,DCC};
			memory[14]=16'd0;
			memory[15]={CONSTANT2REG,C_R1,DCC};
			memory[16]=16'd0;
			memory[17]={MEM_READ,DCWR};
			memory[18]={ADD,R3,DR,C_R1};
			memory[19]={OVER,DCWR};
			
			
			
			
		end
	assign word_out=memory[address];
endmodule


/*				a_flag	/b_flag												  c_decorder
 				3'd1 : A_bus = PC;										     PC= 4'd1
				3'd2 : A_bus = DR;											  DR= 4'd2
				3'd3 : A_bus = R1;											  R1= 4'd3
				3'd4 : A_bus = R2;											  R2= 4'd4
				3'd5 : A_bus = R3;											  R3= 4'd5
				3'd6 : A_bus = R4;											  R4= 4'd6
				3'd7 : A_bus = R5;                        R5= 4'd7
																					        TR= 4'd8 */
