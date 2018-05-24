`timescale 1ns / 1ps
module test();

    reg clk, rst_n;
    top top_utt(clk, rst_n); 

    initial begin
      rst_n = 0;
      clk = 0;

      #100
      rst_n = 1;
    end
    always #10 clk = ~clk;
endmodule
