`timescale 1ns / 1ps
module CONTROL(
    input clk,
    input rst_n,
    input wire [31:0] ram_out,
    output reg [31:0] alu_a,
    output reg [31:0] alu_b,
    output wire [4:0] alu_op,
    input wire [31:0] alu_out,
    output reg [7:0] ram_raddr,
    output reg [7:0] ram_waddr,
    output reg [5:0] reg_raddr,
    output reg [5:0] reg_waddr,
    output reg reg_wen,
    output reg ram_wen,
    output reg [31:0] ram_wdata,
    output reg [31:0] reg_wdata
);
  assign alu_op = ram_out;
  reg [7:0] r1 = 0, r2 = 1, rop = 100, rw = 200;
  reg [2:0] curr_state, next_state;
  parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6, s7 = 7;

  always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      curr_state <= s0;
    end else begin
      curr_state <= next_state;
    end
  end

  always@(*) begin
    case(curr_state)
      s0: next_state <= s1;
      s1: next_state <= s2;
      s2: next_state <= s3;
      s3: next_state <= s4;
      s4: if (alu_op != -1) next_state <= s0; else next_state <= s5;
      s5: next_state <= s5;
    endcase
  end

  always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      r1 <= 0;
      r2 <= 1;
      rop <= 100;
      rw <= 200;
    end else begin
      if (curr_state == s0) begin
        ram_raddr <= r1;
        ram_wen <= 0;
      end else if (curr_state == s1) begin
        ram_raddr <= r2;
      end else if (curr_state == s2) begin
        ram_raddr <= rop;
        /* r0 arrived */
        // write to alu
        alu_a <= ram_out;
        // write to regfile
        reg_waddr <= 0;
        reg_wdata <= ram_out;
        reg_wen <= 1;
      end else if (curr_state == s3) begin
        /* r1 arrived */
        // write to alu
        alu_b <= ram_out;
        // write to regfile
        reg_waddr <= 1;
        reg_wdata <= ram_out;
        reg_wen <= 1;
      end else if (curr_state == s4) begin
        /* op arrived */
        // write to ram
        ram_waddr <= rw;
        ram_wdata <= alu_out;
        ram_wen <= 1;
        // write to regfile
        reg_waddr <= 2;
        reg_wdata <= ram_out;
        reg_wen <= 1;
        /* inrease addrs */
        r1 <= r1 + 2;
        r2 <= r2 + 2;
        rw <= rw + 1;
        rop <= rop + 1;
      end else begin
        ram_wen <= 0;
        reg_wen <= 0;
        // idle
      end
    end
  end
endmodule