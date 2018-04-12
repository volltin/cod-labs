`timescale 1ns / 1ps

module CONTROL(
    input clk,
    input rst_n,
    input wire [31:0] ram_out,
    output reg [31:0] alu_a,
    output reg [31:0] alu_b,
    input wire [31:0] alu_out,
    output reg [9:0] ram_raddr,
    output reg [9:0] ram_waddr,
    output reg [5:0] reg_raddr,
    output reg [5:0] reg_waddr,
    output reg reg_wen,
    output reg ram_wen,
    output reg [31:0] ram_wdata,
    output reg [31:0] reg_wdata
);

    reg [3:0] period = 0;

    // wait init
    reg init_done = 0;
    integer init_cnt = 0;
    always@(posedge clk) begin
        if (init_cnt == 10) begin
            init_done <= 1;
        end else begin
            init_cnt <= init_cnt + 1;
        end
    end

    always@(negedge clk) begin
        if (init_done) begin
            if (period == 6) begin
                period <= 0;
            end else begin
                period <= period + 1;
            end
        end
    end
    
    reg [5:0] r1 = 0, r2 = 1, r3 = 2;

    always@(negedge clk) begin
        if (init_done) begin
            if (period == 0) begin
                ram_raddr <= r1;
            end else if (period == 1) begin
                // wait
            end else if (period == 2) begin
                reg_waddr <= r1;
                reg_wdata <= ram_out;
                reg_wen <= 1;

                alu_a <= ram_out;

                ram_raddr <= r2;
            end else if (period == 3) begin
                // wait
            end else if (period == 4) begin
                reg_waddr <= r2;
                reg_wdata <= ram_out;
                reg_wen <= 1;

                alu_b <= ram_out;
            end else if (period == 5) begin
                reg_waddr <= r3;
                reg_wdata <= alu_out;
                reg_wen <= 1;

                ram_waddr <= r3;
                ram_wdata <= alu_out;
                ram_wen <= 1;
            end else if (period == 6) begin
                reg_wen <= 0;
                ram_wen <= 0;
                r1 <= r1 + 1;
                r2 <= r2 + 1;
                r3 <= r3 + 1;
            end else begin
                //nothing
            end
        end
    end

endmodule
