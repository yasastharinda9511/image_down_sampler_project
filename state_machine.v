module state_machine(clk,sel_d,ctrl,flagA,flagB,constant,incr_en, merge_en, sel_c, d_RAM_en,ir_en,zero,great,instruction,mem_write_en); //data_path(sel_d, ctrl, flagA, flagB,constant,clk, incr_en, merge_en, sel_c, d_RAM_en,ir_en,zero, great,out_statemachine);
	
	parameter fetch1=4'b0000, decode= 4'b0001, execute=4'b0010,collect_constant=4'b0011,idle_read= 4'b0100,check_z=4'b0101,not_check_z=4'b0110,fetch2=4'b0111,constant2reg_fetch=4'b1000;
	parameter idle_constant=4'b1001 ,idle_exe= 4'b1010,not_check_z_fetch=4'b1011,check_z_fetch=4'b1100;
	
	parameter add=6'd1,sub=6'd2,mul=6'd3,div=6'd4,negation=6'd5, left_shift=6'd6, right_shift =6'd7, bit_and =6'd8, bit_or =6'd9,constant2reg=6'd10,Merge=6'd11; 
	parameter mem_write= 6'd12, mem_read= 6'd13 ,jumpz= 6'd14,njumpz =6'd15, over= 6'd16;//related to the opcode in ISA
	
	input clk;
	output reg [2:0] flagA,flagB;
	output reg [3:0] ctrl;
	output reg [3:0] sel_d ;
	output reg [15:0] constant;
	output reg incr_en, merge_en, sel_c,ir_en;
	output reg [1:0] d_RAM_en ;
	output reg mem_write_en;
	
	input zero,great;
	input [15:0]instruction;
	reg [5:0] opcode;
	reg [3:0] state;
	reg [3:0] current_state;
	reg [15:0] word;
	reg [31:0]word2;
	

	
	always@(posedge clk)// this block is related to the what is the next state to be excuted according to the 
		begin
			case(state)
				fetch1:
					begin
						current_state=fetch1;
						state=fetch2;
						sel_d=4'd0 ;ctrl=4'd0;flagA=3'd0;flagB=3'd0;
						merge_en=1'd0;sel_c=1'd0;d_RAM_en=2'b10;
						mem_write_en=1'd0;
						ir_en=1'd1;
						incr_en=1'd1;
					end
				fetch2:
					begin
						current_state=fetch2;
						state=decode;
						incr_en=1'd0;
					end
						
				decode:
					begin
						opcode=instruction[15:10];
						word =instruction;
						current_state=decode;
						if(opcode == add || opcode == sub || opcode == div || opcode == mul || opcode == negation ||opcode == left_shift || opcode == right_shift || opcode == bit_or || opcode ==bit_and)
							begin
									ir_en=1'd0;incr_en=1'd0;
									flagA=word[9:7];flagB=word[6:4];
									sel_c=1'b1; //enable AC path in processor
									//sel_d=word[3:0];
									ctrl=opcode[3:0];
									state=execute;
							end
						else if(opcode==constant2reg)
							begin
								sel_c=1'd0;
								ir_en=1'd1;
								incr_en=1'd1;
								state=constant2reg_fetch;
							end 
						else if(opcode==Merge)
							begin
								ir_en=1'd0;incr_en=1'd0;
								merge_en=1'd1;
								state=fetch1;
							end
						else if(opcode== mem_write)
							begin
								ir_en=1'd0;incr_en=1'd0;
								d_RAM_en=2'b11;
								state=fetch1;
							end
						else if(opcode== mem_read)
							begin
								ir_en=1'd0;incr_en=1'd0;
								d_RAM_en=2'b00;
								mem_write_en=1'd1;
								state=idle_read;
							end
						else if(opcode==jumpz)
							begin
								state=check_z_fetch;
								ir_en=1'd1;
								incr_en=1'd1;
								flagA=word[9:7];flagB=word[6:4];
								ctrl=sub;
							end
						else if(opcode==njumpz)
							begin
								state=not_check_z_fetch;
								ir_en=1'd1;
								incr_en=1'd1;
								flagA=word[9:7];flagB=word[6:4];
								ctrl=sub;
							end
						else if(opcode == over)
							begin
								
							end
					end
				execute:
					begin
						current_state=execute;
						if(opcode == add || opcode == sub || opcode == div || opcode == mul || opcode == negation ||opcode == left_shift || opcode == right_shift || opcode == bit_or || opcode ==bit_and)
							begin
									//flagA=3'd0;flagB=3'd0; //enable AC path in processor
									sel_d=word[3:0];
									state=fetch1;
							end	
					end
				idle_exe:
					begin
						current_state=idle_exe;
						state= fetch1;
					end
				constant2reg_fetch:
					begin
						incr_en=1'd0;
						current_state=constant2reg_fetch;
						state=collect_constant;
					end
				collect_constant:
					begin
						current_state=collect_constant;
						ir_en=1'd0;incr_en=1'd0;
						constant=instruction;
						sel_d=word[9:6];
						state=idle_constant;
					end
				idle_constant:
					begin
						current_state=idle_constant;
						state=fetch1;
					end
				idle_read:// read_idle................................
					begin
						current_state=idle_read;
						state=fetch1;
					end
				not_check_z_fetch:
					begin
						current_state=not_check_z_fetch;
						ir_en=1'd1;incr_en=1'd0;
						state=not_check_z;
					end
				not_check_z:
					begin
						current_state=not_check_z;
						ir_en=1'd0;incr_en=1'd0;
						constant=instruction;
						if(zero==1'b0)
								begin
									sel_c=1'b0;
									sel_d=4'd1;
								end
						state=idle_exe;
					end
				check_z_fetch:
					begin
						current_state=check_z_fetch;
						ir_en=1'd1;incr_en=1'd0;
						state=check_z;
					end
				check_z:
					begin
						current_state=check_z;
						ir_en=1'd0;incr_en=1'd0;
						constant=instruction;
						if(zero==1'b1)
								begin
									sel_c=1'b0;
									sel_d=4'd1;
								end
						state=idle_exe;
					end
			default:
				state=fetch1;
					
			endcase
		end

endmodule

