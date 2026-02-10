// ============================================================================
// @file    : simple_register.sv
// @brief   : 简单寄存器文件
// @note    : 用于 RAL 验证
// ============================================================================

`timescale 1ns/1ps

module simple_register #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
) (
    input  wire                  clk,
    input  wire                  rst_n,
    
    // 写端口
    input  wire [ADDR_WIDTH-1:0] wr_addr,
    input  wire [DATA_WIDTH-1:0] wr_data,
    input  wire                  wr_en,
    
    // 读端口
    input  wire [ADDR_WIDTH-1:0] rd_addr,
    output reg  [DATA_WIDTH-1:0] rd_data,
    input  wire                  rd_en
);

    // 寄存器文件
    reg [DATA_WIDTH-1:0] regs [0:255];
    
    // 写操作
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            regs[0] <= 32'h0000_0000;
            regs[1] <= 32'h0000_0000;
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;
        end
    end
    
    // 读操作
    always @(posedge clk) begin
        if (rd_en) begin
            rd_data <= regs[rd_addr];
        end
    end
    
endmodule : simple_register
