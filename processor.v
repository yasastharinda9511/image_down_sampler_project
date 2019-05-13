module processor(clk,bus,sram_address,output_enable,data_enable,chip_en,UB,LB,check_a,rx,tx,rx_check);
	input clk;
	inout [15:0] bus;
	output [19:0] sram_address;
	output output_enable,data_enable,chip_en,UB,LB;
	output [15:0]check_a;
	input rx;
	output tx;
	
	//data path intialization
	wire[3:0] sel_d;
	wire [3:0] ctrl;	
	wire [2:0] flagA,flagB;
	wire [15:0] constant;
	wire incr_en, merge_en, sel_c, ir_en;
	wire [1:0] d_RAM_en;
	wire zero, great,start_calculation;
	wire [15:0] out_statemachine;
	wire mem_write_en;
	wire finish;
	wire sample_clock;
	
	//reg [39:0] counter=40'd0;
	//reg sample_clock=1'd0;

	output [7:0] rx_check;
	//data_path(sel_d, ctrl, flagA, flagB,constant,clk, incr_en, merge_en, sel_c, d_RAM_en,ir_en,zero, great,out_statemachine,bus,sram_address,output_enable,data_enable,chip_en,UB,LB)
	
	
   data_path dp(.sel_d(sel_d), 
	.ctrl(ctrl), 
	.flagA(flagA),
	.flagB(flagB),
	.constant(constant),
	.clk(sample_clock),
	.incr_en(incr_en),
	.merge_en(merge_en),
	.sel_c(sel_c),
	.d_RAM_en(d_RAM_en),
	.ir_en(ir_en),
	.zero(zero),
	.great(great),
	.out_statemachine(out_statemachine),
	.bus(bus),
	.sram_address(sram_address),
	.output_enable(output_enable),
	.data_enable(data_enable),
	.chip_en(chip_en),
	.UB(UB),
	.LB(LB),
	.check_a(check_a),
	.mem_write_en(mem_write_en),
	.start_calculation(start_calculation),
	.finish(finish),
	.tx(tx),
	.rx(rx),
	.rx_check(rx_check));
//state_machine(clk,sel_d,ctrl,flagA,flagB,constant,incr_en, merge_en, sel_c, d_RAM_en,ir_en,zero,great,instruction);


	state_machine sm(.clk(sample_clock),
	.sel_d(sel_d),
	.ctrl(ctrl),
	.flagA(flagA),
	.flagB(flagB),
	.constant(constant),
	.incr_en(incr_en),
	.merge_en(merge_en),
	.sel_c(sel_c),
	.d_RAM_en(d_RAM_en),
	.ir_en(ir_en),
	.zero(zero),
	.great(great),
	.instruction(out_statemachine),
	.mem_write_en(mem_write_en),
	.finish(finish),
	.start_calculation(start_calculation));
	
	clock_devide(.clk(clk),
	.sample_clock(sample_clock));
	
	/*always@(posedge clk)
		begin
			if (counter==40'd9)
				begin
					counter=40'd0;
					sample_clock=1'b1;
				end
			else
				begin
					counter=counter +40'd1;
					sample_clock=1'b0;
				end
		end*/
endmodule  
