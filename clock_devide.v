module clock_devide(clk,sample_clock);

	input clk;
	reg [39:0] counter=40'd0;
	output reg sample_clock=1'd0;

	always@(posedge clk)
		begin
			if (counter==40'd9) // generate 1mhz frequency from 50mhz internal oscillator
				begin
					counter=40'd0;
					sample_clock=1'b1;
				end
			else
				begin
					counter=counter +40'd1;
					sample_clock=1'b0;
				end
		end
endmodule
