module Test;
  reg     clk, rst_n;
    
  top test_top(clk, rst_n);
  
  initial  begin
    $dumpfile("result.vcd");
    $dumpvars;
    clk = 0;
    rst_n = 1;
    #4 rst_n = 0;
    #6 rst_n = 1;
  end

  always #5 clk = ~clk;

  initial #1000 $finish;
endmodule