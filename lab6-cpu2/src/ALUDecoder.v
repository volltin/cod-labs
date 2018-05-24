`timescale 1ns / 1ps
module ALUDecoder (
    ALUOP, funct, ALUControl
);

input [1:0] ALUOP;
input [5:0] funct;
output reg [2:0] ALUControl;

always@(*) begin
  case(ALUOP)
    0: ALUControl <= 1;
    1: ALUControl <= 7;
    2: 
    begin 
        case (funct)
            6'h20: ALUControl <= 1;
            default: ALUControl <= 0;
        endcase
    end
    default: ALUControl <= 0;
  endcase
end

endmodule