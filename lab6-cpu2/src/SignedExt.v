`timescale 1ns / 1ps
module SignedExt (
  input signed [15:0] input_num,
  output signed [31:0] output_num
);

assign output_num = input_num;

endmodule // 