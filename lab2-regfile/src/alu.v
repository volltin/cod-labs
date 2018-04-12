module ALU (
    input   signed  [31:0]  alu_a,
    input   signed  [31:0]  alu_b,
    input           [4:0]   alu_op,
    output  reg     [31:0]  alu_out
);

parameter	A_NOP	= 5'h00; // 空运算
parameter	A_ADD	= 5'h01; // 符号加
parameter	A_SUB	= 5'h02; // 符号减
parameter	A_AND   = 5'h03; // 与
parameter	A_OR    = 5'h04; // 或
parameter	A_XOR   = 5'h05; // 异或
parameter	A_NOR   = 5'h06; // 或非

wire signed [31:0] alu_nop_out, alu_add_out, alu_sub_out, alu_and_out, alu_or_out, alu_xor_out, alu_nor_out;

assign alu_nop_out = 0;
assign alu_add_out = alu_a + alu_b;
assign alu_sub_out = alu_a - alu_b;
assign alu_and_out = alu_a & alu_b;
assign alu_or_out  = alu_a | alu_b;
assign alu_xor_out = alu_a ^ alu_b;
assign alu_nor_out = ~(alu_a | alu_b);

always@(*) begin
  case (alu_op)
    A_NOP : alu_out <= alu_nop_out;
    A_ADD : alu_out <= alu_add_out;
    A_SUB : alu_out <= alu_sub_out;
    A_AND : alu_out <= alu_and_out;
    A_OR  : alu_out <= alu_or_out;
    A_XOR : alu_out <= alu_xor_out;
    A_NOR : alu_out <= alu_nor_out;
    default: alu_out <= alu_nop_out;
  endcase
end

endmodule // alu 