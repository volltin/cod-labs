`timescale 1ns / 1ps
module top(
    input           clk,
    input           rst_n,
    output [31:0]   data1
);
    // ram
    wire ena, enb;
    wire [0:0]   wea;
    wire [7:0]   addra, addrb;
    wire [31:0]  dina;
    wire [31:0] doutb;

    RAM ram1(
        .clka(clk),
        .ena(ena),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .clkb(clk),
        .enb(enb),
        .addrb(addrb),
        .doutb(doutb)
    );

    assign ena = 1;
    assign enb = 1;

    // regfile
	wire    [5:0]   	rAddr;
	wire	[31:0]		rDout;
	wire	[5:0]   	wAddr;
	wire	[31:0]  	wDin;
	wire 				wEna;

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

    ALU alu(
		.alu_a(alu_a),
		.alu_b(alu_b),
		.alu_op(alu_op),
		.alu_out(alu_out)
	);

    // control
    CONTROL control(
        .clk(clk),
        .rst_n(rst_n),
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_op(alu_op),
        .alu_out(alu_out),
        .reg_raddr(rAddr),
        .reg_waddr(wAddr),
        .reg_wdata(wDin),
        .reg_wen(wEna),
        .ram_raddr(addrb),
        .ram_out(doutb),
        .ram_waddr(addra),
        .ram_wdata(dina),
        .ram_wen(wea)
    );
    assign data1 = dina;
endmodule // top