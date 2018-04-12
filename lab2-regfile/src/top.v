
module top(
	input			clk,
    input			rst_n
);

	// regfile
	reg		[5:0]   	rAddr = 0;
	wire	[31:0]		rDout;
	reg		[5:0]   	wAddr;
	reg		[31:0]  	wDin;
	reg 				wEna;

	REG_FILE reg_file(
		.clk(clk),
		.rst_n(rst_n),
		.rAddr(rAddr),
		.rDout(rDout),
		.wAddr(wAddr),
		.wDin(wDin),
		.wEna(wEna)
	);

	// alu
	wire		[31:0]  	alu_a;
	wire		[31:0]  	alu_b;
	wire		[4:0]   	alu_op;
	wire		[31:0]  	alu_out;

	parameter	A_ADD	= 5'h01; // 符号加

	ALU alu(
		.alu_a(alu_a),
		.alu_b(alu_b),
		.alu_op(alu_op),
		.alu_out(alu_out)
	);

	assign alu_op = A_ADD;
	assign alu_a = buffer;
	assign alu_b = rDout;

	// init

	integer init_step_cnt = 0;
	integer init_step_total = 4;
	reg init_done = 0;

	always @(negedge clk) begin
		if (init_step_cnt < init_step_total) begin
			// init_step_cnt == 0: wait reset
			if (init_step_cnt == 1) begin
				// prepare data for reg0
				wAddr <= 0;
				wDin <= 2;
				wEna <= 1;
			end else if (init_step_cnt == 2) begin
				// prepare data for reg1
				wAddr <= 1;
				wDin <= 2;
				wEna <= 1;
			end else if (init_step_cnt == 3) begin
				// disable wEna
				wEna <= 0;
			end
			init_step_cnt <= init_step_cnt + 1;
		end else begin
			init_done <= 1;
		end
	end

	// data buffer
	reg [31:0] buffer;
	always@(negedge clk) begin
		buffer <= rDout;
	end
	// loop add

	integer loop_cnt = 0;
	integer loop_total = 64; // 2, 3, ..., 63, [we = 0] 

	always @(negedge clk) begin
		if (init_done) begin
			if (loop_cnt == 0) begin
				rAddr <= rAddr + 1;
				loop_cnt <= loop_cnt + 1;
			end else if (loop_cnt < loop_total) begin
				if (loop_cnt != loop_total - 1) begin
					wEna <= 1;
					wAddr <= rAddr + 1;
					wDin <= alu_out;

					rAddr <= rAddr + 1;
				end else begin
					wEna <= 0;
				end
				loop_cnt <= loop_cnt + 1;
			end
		end
	end
endmodule