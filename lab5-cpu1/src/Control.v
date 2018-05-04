`timescale 1ns / 1ps
module Control(
    opcode, funct,
    MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, ALUControl, pdaddr
);

input [5:0] opcode, funct;
output MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, pdaddr;
output [2:0] ALUControl;

wire [1:0] ALUOP;

MainDecoder main_decoder_inst(
    .opcode(opcode),
    .MemToReg(MemToReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUOP(ALUOP),
    .pdaddr(pdaddr)
);

ALUDecoder ALU_decoder_inst(
    .ALUOP(ALUOP),
    .funct(funct),
    .ALUControl(ALUControl)
);

endmodule

