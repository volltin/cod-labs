`timescale 1ns / 1ps
module ALU (
    input   signed  [31:0]  alu_a,
    input   signed  [31:0]  alu_b,
    input           [2:0]   alu_op,
    output  reg     [31:0]  alu_out,
    output  zero
);

parameter	A_NOP = 3'h00;
parameter	A_ADD = 3'h01;
parameter	A_SUB = 3'h02;
parameter	A_AND = 3'h03;
parameter	A_OR  = 3'h04;
parameter	A_XOR = 3'h05;
parameter	A_NOR = 3'h06;
parameter	A_GTZ = 3'h07;

wire signed [31:0] alu_nop_out, alu_add_out, alu_sub_out, alu_and_out, alu_or_out, alu_xor_out, alu_nor_out, alu_gtz_out;

assign alu_nop_out = 0;
assign alu_add_out = alu_a + alu_b;
assign alu_sub_out = alu_a - alu_b;
assign alu_and_out = alu_a & alu_b;
assign alu_or_out  = alu_a | alu_b;
assign alu_xor_out = alu_a ^ alu_b;
assign alu_nor_out = ~(alu_a | alu_b);
assign alu_gtz_out = alu_a > 0 ? 1 : 0;
assign zero = alu_gtz_out;

always@(*) begin
  case (alu_op)
    A_NOP : alu_out <= alu_nop_out;
    A_ADD : alu_out <= alu_add_out;
    A_SUB : alu_out <= alu_sub_out;
    A_AND : alu_out <= alu_and_out;
    A_OR  : alu_out <= alu_or_out;
    A_XOR : alu_out <= alu_xor_out;
    A_NOR : alu_out <= alu_nor_out;
    A_GTZ : alu_out <= alu_gtz_out;
    default: alu_out <= alu_nop_out;
  endcase
end

endmodule // ALU