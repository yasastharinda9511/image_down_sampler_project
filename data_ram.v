module data_ram(clk,write_en_reg,bus,data_in_reg,data_out_reg,output_enable,data_enable,chip_en,UB,LB,address_reg,sram_address,data_in_uart,data_out_uart,address_uart,uart_en,write_en_uart);
	input clk; // this code is for the sram controoler
	input [1:0] write_en_reg;
	input [1:0] write_en_uart;
	
	output output_enable;
	output data_enable;
	output chip_en;
	output UB;
	output LB;
	inout [15:0] bus;
	//inout [15:0] bus;
	input [15:0] data_in_reg;
	output [15:0]data_out_reg;
	input [19:0] address_reg;
	
	input [15:0] data_in_uart;
	output [15:0]data_out_uart;
	input [19:0] address_uart;
	input uart_en;
	
	output [19:0] sram_address;
	
	reg [15:0] data_in;
	
	//output [7:0] rx_check;
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
		always @(*)
			begin
				if(uart_en)
					data_in= data_in_uart;
				else
					data_in= data_in_reg;
			end
			
			
		assign data_enable=(write_en_reg==2'b11 || write_en_uart== 2'b11) ? 1'b0 :1'b1 ;
		assign chip_en=(write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
		assign output_enable=(write_en_reg==2'b00 || write_en_uart== 2'b00) ? 1'b0 :1'b1 ;
		assign LB= (write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
		assign UB= (write_en_reg==2'b11 || write_en_reg==2'b00 || write_en_uart==2'b11 || write_en_uart==2'b00) ? 1'b0 :1'b1 ;
	
		assign data_out_reg=(write_en_reg ==2'b00 ) ? bus : 16'dz;
		assign data_out_uart=(write_en_uart ==2'b00 ) ? bus : 16'dz;
		
		//assign data_in = (uart_en) ? data_in_uart : data_in_reg;
		assign bus= (write_en_reg ==2'b11 || write_en_uart ==2'b11) ? data_in: 16'dz;
		
		assign sram_address= (uart_en) ? address_uart:address_reg;
	
		
	
endmodule

