`timescale 1ns/1ps
module test_bench;
	reg clk, rst_n, ce, rd_en, wr_en;
	reg [3:0] addr;
	reg [7:0] data_in;
	wire [7:0] data_out;
	wire valid;

	integer i;

	ram16x8 dut(
		.clk(clk),
		.rst_n(rst_n),
		.ce(ce),
		.rd_en(rd_en),
		.wr_en(wr_en),
		.addr(addr),
		.data_in(data_in),
		.data_out(data_out),
		.valid(valid)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk; 
	end

	task verify;
		input [7:0] exp_data_out;
		input exp_valid;
		begin
			$display("At time: %t, rst_n = 1'b%b, ce = 1'b%b, rd_en = 1'b%b, wr_en = 1'b%b, addr = 4'b%b, data_in = 8'b%b",$time, rst_n, ce, rd_en, wr_en, addr, data_in);
			if (data_out == exp_data_out && valid == exp_valid) begin
				$display("-----------------------------------------------------------------------------------------------------------------");
				$display("PASSED: Expected data_out: 8'b%b, Got data_out: 8'b%b, Expectd valid: 1'b%b, Got valid: 1'b%b", exp_data_out, data_out, exp_valid, valid);
				$display("-----------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("-----------------------------------------------------------------------------------------------------------------");
				$display("FAILED: Expected data_out: 8'b%b, Got data_out: 8'b%b, Expectd valid: 1'b%b, Got valid: 1'b%b", exp_data_out, data_out, exp_valid, valid);
				$display("-----------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);

		$display("-----------------------------------------------------------------------------------------------------------------");
		$display("-------------------------------------TESTBENCH FOR RAM 16X8------------------------------------------------------");
		$display("-----------------------------------------------------------------------------------------------------------------");

		rst_n = 0;
		ce = 0;
		rd_en = 0;
		wr_en = 0;
		addr = 4'b0000;
		data_in = 8'hff;
		@(posedge clk);
		verify(0,0);

		rst_n = 1;
		ce = 0;
		rd_en = 1;
		wr_en = 0;
		addr = 4'h5;
		data_in = 8'haa;
		@(posedge clk);
		verify(0,0);

		ce = 1;
		@(posedge clk);

		for (i = 0; i < 16; i = i + 1) begin
			rd_en = 0;
			wr_en = 1;
			addr = i;
			data_in = $random % 256;
			@(posedge clk);
			verify(0,0);

			rd_en = 1;
			wr_en = 0;
			addr = i;
			@(posedge clk);
			verify(data_in, 1);
		end

		$display("------------------------------------COMPLETED TESTBENCH FOR RAM 16X8 --------------------------------------------");
		#100;
		$finish;
	end
endmodule

