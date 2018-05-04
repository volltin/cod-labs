`timescale 1ns / 1ps
module PCNext(
    PCAdd4, IR, Branch, ALUResult, pdaddr, SignedImm, nextPC
);
input [31:0] PCAdd4, IR, ALUResult;
input signed [31:0] SignedImm;

input Branch, pdaddr;
output [31:0] nextPC;

assign nextPC = pdaddr
    ? ({PCAdd4[31:28], IR[25:0], 2'b00})
    : (
        (Branch && ALUResult)
        ? ((SignedImm << 2) + PCAdd4)
        : (PCAdd4)
      )
;

endmodule