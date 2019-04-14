module data_ram(clk,write_en,bus,data_in,data_out,output_enable,data_enable,chip_en,UB,LB,address,sram_address);
	input clk; // this code is for the sram controoler
	input [1:0] write_en;
	output output_enable;
	output data_enable;
	output chip_en;
	output UB;
	output LB;
	inout [15:0] bus;
	//inout [15:0] bus;
	input [15:0] data_in;
	output [15:0]data_out;
	
	input [19:0] address;
	output [19:0] sram_address;
	
	//output [15:0]data_out;
	
	/*always@(posedge clk)
		begin
			if(write_en==2'b11)
				begin
					data_enable=1'b0;
					chip_en=1'b0;
					output_enable=1'b1;
					LB= 1'b0;
					UB= 1'b0;
					
				end
			else if(write_en==2'b00)
				begin
					data_enable=1'b1;
					chip_en=1'b0;
					output_enable=1'b0;
					LB= 1'b0;
					UB= 1'b0;
				end
			/*else 
				begin
					data_enable=1'b1;
					chip_en=1'b1;
					output_enable=1'b1;
					LB= 1'bz;
					UB= 1'bz;
					//bus=16'bzzzzzzzzzzzzzzzz;
				end*/
		//end
		
		assign data_enable=(write_en==2'b11) ? 1'b0 :1'b1 ;
		assign chip_en=(write_en==2'b11 || write_en==2'b00) ? 1'b0 :1'b1 ;
		assign output_enable=(write_en==2'b00) ? 1'b0 :1'b1 ;
		assign LB= (write_en==2'b11 || write_en==2'b00) ? 1'b0 :1'b1 ;
		assign UB= (write_en==2'b11 || write_en==2'b00) ? 1'b0 :1'b1 ;
	
		assign data_out=(write_en ==2'b00) ? bus : 16'dz;
		assign bus= (write_en ==2'b11) ? data_in: 16'dz;
		assign sram_address=address;
	
	
endmodule
