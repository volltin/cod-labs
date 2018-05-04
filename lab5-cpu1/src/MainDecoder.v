`timescale 1ns / 1ps
module MainDecoder(
    opcode,
    MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, ALUOP, pdaddr
);

input [5:0] opcode;
output MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, pdaddr;
output [1:0] ALUOP;

reg [8:0] code = 0;

assign {MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, ALUOP, pdaddr} = code;

parameter	OP_ADDI = 6'h8;
parameter	OP_LW   = 6'h23;
parameter	OP_SW   = 6'h2b;
parameter	OP_ADD  = 6'h0;
parameter	OP_BGTZ = 6'h7;
parameter	OP_J    = 6'h2;

always@(*) begin
  case(opcode)
    OP_ADDI:    code <= 9'b0_0_0_1_0_1_00_0;
    OP_LW:      code <= 9'b1_0_0_1_0_1_00_0;
    OP_SW:      code <= 9'b0_1_0_1_0_0_00_0;
    OP_ADD:     code <= 9'b0_0_0_0_1_1_10_0;
    OP_BGTZ:    code <= 9'b0_0_1_0_0_0_01_0;
    OP_J:       code <= 9'b0_0_1_0_0_0_01_1;
  endcase
end

endmodule