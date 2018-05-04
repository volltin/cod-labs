`timescale 1ns / 1ps
module top(clk, rst_n);
input clk, rst_n;

reg [31:0] PC;
wire [31:0] IR, MDR, ALUResult, Result;
wire MemToReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, pdaddr;
wire [2:0] ALUControl;

wire [31:0] Reg1, Reg2, SrcA, SrcB;
wire [4:0] WriteReg;


IMEM imem_inst(PC >> 2, 0, clk, 0, IR); // no write
DMEM dmem_inst(ALUResult >> 2, Reg2, clk, MemWrite, MDR);

assign WriteReg = RegDst ? IR[15:11] : IR[20:16];
assign Result = MemToReg ? MDR : ALUResult;

Regfile regifile_inst(
    .clk(clk),
    .rst_n(rst_n),
    .r1Addr(IR[25:21]),
    .r1Dout(Reg1),
    .r2Addr(IR[20:16]),
    .r2Dout(Reg2),
    .wAddr(WriteReg),
    .wDin(Result),
    .wEna(RegWrite)
);

wire [5:0] opcode, funct;
assign opcode = IR[31:26];
assign funct = IR[5:0];
Control control_inst(
    .opcode(opcode),
    .funct(funct),
    .MemToReg(MemToReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUControl(ALUControl),
    .pdaddr(pdaddr)
);

assign SrcA = Reg1;
assign SrcB = ALUSrc ? SignedImm : Reg2;

wire [31:0] SignedImm;
SignedExt signed_ext_inst(IR[15:0], SignedImm);

ALU ALU_inst(
    .alu_a(SrcA), .alu_b(SrcB), .alu_op(ALUControl), .alu_out(ALUResult)
);

wire [31:0] nextPC;
PCNext PC_next_inst(
    .PCAdd4(PC + 4),
    .IR(IR),
    .Branch(Branch),
    .ALUResult(ALUResult),
    .pdaddr(pdaddr),
    .SignedImm(SignedImm),
    .nextPC(nextPC)
);

always@(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    PC <= 0;
  end else begin
    PC <= nextPC;
  end
end

endmodule
