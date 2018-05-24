`timescale 1ns / 1ps
module PCNext(
   PCSrc, ALUResult, ALUOut, PCJump, nextPC
);
parameter WIDTH = 32;

input [1:0] PCSrc;
input [WIDTH-1:0] ALUResult, ALUOut, PCJump;
output [WIDTH-1:0] nextPC;
assign nextPC = PCSrc == 0 ? ALUResult : PCSrc == 1 ? ALUOut : PCJump;

endmodule