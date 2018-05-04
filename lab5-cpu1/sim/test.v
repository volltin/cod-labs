`timescale 1ns / 1ps

module test();
    reg clk, rst_n;
    top top_inst(clk, rst_n);

    initial begin
      clk <= 0;
      rst_n <= 0;
      #100
      rst_n <= 1;
    end

    always #10 clk = ~clk;
endmodule
