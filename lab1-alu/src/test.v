module Test;
  reg signed [31:0] a, b;
  wire signed [31:0] c;

  reg signed [31:0] alu_a, alu_b;
  reg [4:0] alu_op;
  wire signed [31:0] alu_out;
  
  top test_top(a, b, c);
  ALU ALU_TEST(alu_a, alu_b, alu_op, alu_out);

  parameter	A_NOP	= 5'h00; // 空运算
  parameter	A_ADD	= 5'h01; // 符号加
  parameter	A_SUB	= 5'h02; // 符号减
  parameter	A_AND   = 5'h03; // 与
  parameter	A_OR    = 5'h04; // 或
  parameter	A_XOR   = 5'h05; // 异或
  parameter	A_NOR   = 5'h06; // 或非
  
  initial  begin
    $dumpfile("result.vcd");
    $dumpvars;

    // init
    a = 0; b = 0;
    alu_a = 0; alu_b = 0; alu_op = 0;

    // test alu NOP
    alu_a = 0; alu_b = 0; alu_op = A_NOP; #10

    // test alu ADD
    alu_a = 233; alu_b = 233; alu_op = A_ADD; #10
    alu_a = -233; alu_b = 233; alu_op = A_ADD; #10
    alu_a = 32'hffffffff; alu_b = 0; alu_op = A_ADD; #10
    alu_a = 32'hffffffff; alu_b = 1; alu_op = A_ADD; #10

    // test alu SUB
    alu_a = 233; alu_b = 123; alu_op = A_SUB; #10
    alu_a = -233; alu_b = 123; alu_op = A_SUB; #10
    alu_a = 123; alu_b = 233; alu_op = A_SUB; #10
    alu_a = 123; alu_b = -233; alu_op = A_SUB; #10

    // test alu AND
    alu_a = 32'hff00ff00; alu_b = 32'h12345678; alu_op = A_AND; #10

    // test alu OR
    alu_a = 32'hff00ff00; alu_b = 32'h12345678; alu_op = A_OR; #10

    // test alu XOR
    alu_a = 32'hff00ff00; alu_b = 32'h12345678; alu_op = A_XOR; #10

    // test alu NOR
    alu_a = 32'hff00ff00; alu_b = 32'h12345678; alu_op = A_NOR; #10

    // test alu end
    alu_a = 0; alu_b = 0; alu_op = A_NOP;

    // test fib seqs
    a=2; b=2;
    #10

    a=0; b=1;
    #10

    a=-1; b=0;
  end

  initial #1000 $finish;
endmodule