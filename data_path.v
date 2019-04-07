module data_path(sel_d, ctrl, flagA, flagB,constant,clk, incr_en, merge_en, sel_c, d_RAM_en,ir_en,zero, great,out_statemachine);
	input [2:0] sel_d, ctrl, flagA, flagB;
	input [15:0] constant;
	input clk, incr_en, merge_en, sel_c, d_RAM_en,ir_en;
	output zero, great;
	output [15:0] out_statemachine;
	
	wire en_r1,en_r2,en_r3,en_r4,en_r5,en_pc,en_dr,en_tr;
	wire [15:0] im_out;
	wire [15:0] busA, busB, rslt;
	
	wire [15:0] pc_a,dr_a,R1_a,R2_a,R3_a,R4_a,R5_a,least_sig_bits,in_data,out_data;
	wire [15:0] pc_b,dr_b,R1_b,R2_b,R3_b,R4_b,R5_b;
	wire [15:0] c_in;
	wire [19:0] address_d_RAM;
	wire [3:0] most_sig_bits;
	wire [15:0] instruction;
	
	//output [19:0] address_d_RAM;
	//tri [15:0] d_RAM_bus;
	
	programCounter pc(.clk(clk),.en(en_pc),.incr_en(incr_en),.c_in(c_in),.a_out(pc_a),.b_out(pc_b),.im_out(im_out));//programCounter(clk,en,incr_en,c_in,a_out,b_out,im_out);
	
	IRAM intruction_ram (.address(im_out),.word_out(instruction),.clk(clk));//IRAM(address,word_out,clk);
	
	IR instruction_reg(.en(ir_en),.word(out_statemachine),.instruction(instruction),.clk(clk));									//IR(en,word,instruction);
	
	data_register DR(.write_en(en_dr),.data_in(in_data),.data_out(out_data),.a_bus(dr_a),.b_bus(dr_b),.c_bus(c_in),.least_sig(least_sig_bits),.clk(clk));//data_register(write_en,data,a_bus,b_bus,c_bus,least_sig,clk);
	
	data_ram DRAM (.data_in(out_data),.data_out(in_data),.clk(clk),.write_en(d_RAM_en),.address(address_d_RAM));//data_ram(data_in,data_out,clk,write_en,address);
	
	TR_reg TR(.most_sig(most_sig_bits),.write_en(en_tr),.c_bus(c_in),.clk(clk));//most_sig,write_en,c_bus,clk
	
	AR AR1(.address(address_d_RAM),.TR(most_sig_bits),.DR(least_sig_bits),.merge_en(merge_en),.clk(clk));//AR(address,TR,DR,merge_en,clk);
	
	registerR1 R1(.clk(clk),.en(en_r1),.c_in(c_in),.a_out(R1_a),.b_out(R1_b));	// registerR5(clk,en,c_in,a_out,b_out);
	registerR2 R2(.clk(clk),.en(en_r2),.c_in(c_in),.a_out(R2_a),.b_out(R2_b)); 
	registerR3 R3(.clk(clk),.en(en_r3),.c_in(c_in),.a_out(R3_a),.b_out(R3_b)); 
	registerR4 R4(.clk(clk),.en(en_r4),.c_in(c_in),.a_out(R4_a),.b_out(R4_b)); 
	registerR5 R5(.clk(clk),.en(en_r5),.c_in(c_in),.a_out(R5_a),.b_out(R5_b)); 
	
	ALU AL_unit(.a(busA), .b(busB), .control(ctrl), .result(rslt), .z(zero), .g(great));
	
	write_en_decoder decoder(.selection_en(sel_d),.PC(pc_en),.DR(),.R1(en_r1),.R2(en_r2),.R3(en_r3),.R4(en_r4),.R5(en_r5));//write_en_decoder(selection_en, PC, DR, R1, R2, R3, R4, R5);
	
	aMux A_mux(.a_flag(flagA), .PC(pc_a), .DR(dr_a), .R1(R1_a), .R2(R2_a), .R3(R3_a), .R4(R5_a), .R5(R5_a), .A_bus(busA));
	bMux B_mux(.b_flag(flagB), .PC(pc_b), .DR(dr_b), .R1(R1_b), .R2(R2_b), .R3(R3_b), .R4(R5_b), .R5(R5_b), .B_bus(busB));
	Mux_C C_mux(.constant(constant), .AC(rslt), .sel(sel_c), .out(c_in));
	
	//assign d_RAM_bus = 

endmodule 
