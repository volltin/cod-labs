module REG_FILE(
    input           clk,
    input           rst_n,
    input   [5:0]   rAddr,
    output  [31:0]  rDout,
    input   [5:0]   wAddr,
    input   [31:0]  wDin,
    input           wEna
);

integer i;
parameter rst_value = 32'h0000_0000;

reg [31:0] regs [63:0];

assign rDout = regs[rAddr];


always @(posedge clk) begin
    if (~rst_n) begin
        // reset
        for (i = 0; i < 63; i = i + 1) begin
			regs[i] <= rst_value;
		end
    end else begin
        if (wEna) begin
            regs[wAddr] <= wDin;
        end
    end
end

endmodule // REG_FILE