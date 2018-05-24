`timescale 1ns / 1ps
module top(clk, rst_n);
    input clk, rst_n;

    parameter WIDTH = 32;

    wire IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, Zero;
    wire [WIDTH-1:0] MDR, RD1, RD2, SignImm, ALUResult, nextPC;

    wire ALUSrcA, Branch, PCWrite;
    wire [1:0] ALUSrcB;
    wire [2:0] ALUControl;
    wire [1:0] PCSrc;
    wire [1:0] ALUOp;

    // alias
    wire [WIDTH-1:0] PCJump = {PC[31:28], IR[25:0], 2'b00};

    wire [4:0] A1 = IR[25:21];
	wire [4:0] A2 = IR[20:16];
	wire [4:0] A3 = RegDst ? IR[15:11] : IR[20:16];
    wire [5:0] Funct = IR[5:0];

    wire [WIDTH-1:0] Adr = IorD ? ALUOut : PC;

    // regs
    reg [WIDTH-1:0] PC, IR, A, B, ALUOut;

    // memory
    MEM mem(Adr >> 2, B, clk, MemWrite, MDR);
    
    // regfile
    Regfile regfile(
        .clk(clk), 
        .rst_n(rst_n), 
        .r1Addr(A1), .r1Dout(RD1),
        .r2Addr(A2), .r2Dout(RD2),
        .wAddr(A3), .wDin(MemtoReg ? MDR : ALUOut), .wEna(RegWrite) //TODO
    );

    // ALU
    wire [WIDTH-1:0] SrcA = ALUSrcA ? A : PC;
    // Todo: Mux4_1 mux_4_1(SrcB, ALUSrcB, B, 4, SignImm, SignImm >> 2);
    wire [WIDTH-1:0] SrcB = ALUSrcB == 0 ? B : ALUSrcB == 1 ? 4 : ALUSrcB == 2 ? SignImm : (SignImm<<2);
    ALU alu(
        .alu_a(SrcA),
        .alu_b(SrcB),
        .alu_op(ALUControl),
        .alu_out(ALUResult),
        .zero(Zero)
    );

    // Gadgets
    SignedExt signed_ext(IR[15:0], SignImm);

    // Control
    Control control(clk, rst_n, IR[31:26], IorD, MemWrite, IRWrite, RegDst, 
        MemtoReg, RegWrite, ALUSrcA, Branch, PCWrite, ALUSrcB, ALUOp, PCSrc);

    ALUDecoder alu_decoder(ALUOp, Funct, ALUControl);

    // next PC
    wire PCEn = (Zero && Branch) || PCWrite;
    PCNext pc_next(
        .PCSrc(PCSrc),
        .ALUResult(ALUResult),
        .ALUOut(ALUOut),
        .PCJump(PCJump),
        .nextPC(nextPC)
    );

    // Reset
    always@(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			PC <= 0; IR <= 0; A <= 0; B <= 0; ALUOut <= 0;
		end else begin
			if(PCEn) PC <= nextPC;
			if(IRWrite) IR <= MDR;
			A <= RD1;
			B <= RD2;
			ALUOut <= ALUResult;
		end
	end

endmodule
