/*module tb();
	wire [15:0] bus;
	wire [19:0] sram_address;
	wire output_enable,data_enable,chip_en,UB,LB;
	wire [15:0] checK_a;
	
	reg clk=1'b0;
	
	processor proc(.clk(clk),.bus(bus),.sram_address(sram_address),.output_enable(output_enable),.data_enable(data_enable),.chip_en(chip_en),.UB(UB),.LB(LB),.check_a(check_a));
	
	initial
		begin
			clk=1'b0;
			forever #5 clk=~clk;
		end
endmodule*/
