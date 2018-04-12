module top(
	input	signed	[31:0]	a,
	input	signed	[31:0]	b,
	output	signed	[31:0]	c
	);

parameter	A_ADD	= 5'h01; // 符号加

wire signed [31:0] f1, f2, f3, f4, f5, f6;

assign f1 = a;
assign f2 = b;

ALU ALU_1(f1, f2, A_ADD, f3);
ALU ALU_2(f2, f3, A_ADD, f4);
ALU ALU_3(f3, f4, A_ADD, f5);
ALU ALU_4(f4, f5, A_ADD, f6);

assign c = f6;

endmodule