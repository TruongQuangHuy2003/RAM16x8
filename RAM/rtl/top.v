module ram16x8 (
	input wire clk,
	input wire rst_n,
	input wire ce,
	input wire rd_en,
	input wire wr_en,
	input wire [3:0] addr, // Access address (4 bits for the 16 adresses)
	input wire [7:0] data_in,
	output reg [7:0] data_out,
	output reg valid
);

reg [7:0] ram [15:0];
reg [7:0] read_data;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 8'h00;
		valid <= 1'b0;
	end else if (ce) begin
		if (wr_en) begin
			ram[addr] <= data_in;
			valid <= 1'b0;
		end else if (rd_en) begin
			read_data <= ram[addr];
			valid <= 1'b1;
		end else begin
			valid <= 1'b0;
		end
	end else begin
		valid <= 1'b0;
	end
end

always @(*) begin
	if (ce && rd_en) begin
		data_out <= read_data;
	end else begin
		data_out <= 8'h00;
	end
end
endmodule

