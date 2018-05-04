`timescale 1ns / 1ps
// dual read ports and one write port
module Regfile(
    input           clk,
    input           rst_n,
    input   [4:0]   r1Addr,
    output  [31:0]  r1Dout,
    input   [4:0]   r2Addr,
    output  [31:0]  r2Dout,
    input   [4:0]   wAddr,
    input   [31:0]  wDin,
    input           wEna
);

integer i;
parameter rst_value = 32'h0000_0000;

reg [31:0] regs [31:0];

assign r1Dout = regs[r1Addr];
assign r2Dout = regs[r2Addr];


always @(posedge clk) begin
    if (~rst_n) begin
        // reset
        for (i = 0; i < 64; i = i + 1) begin
			regs[i] <= rst_value;
		end
    end else begin
        if (wEna) begin
            regs[wAddr] <= wDin;
        end
    end
end

endmodule // Regfile