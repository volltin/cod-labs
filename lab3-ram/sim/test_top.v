`timescale 1ns / 1ps
module test_top();
    reg clk, rst_n;
    wire [31:0] data1, data2;

    top uut(
        .clk(clk),
        .rst_n(rst_n),
        .data1(data1),
        .data2(data2)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        #1 rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;
    end

endmodule
