// ============================================================================
// @file    : simple_alu.sv
// @brief   : 简单 ALU DUT
// @note    : 用于验证示例的基础算术逻辑单元
// ============================================================================

`timescale 1ns/1ps

module simple_alu #(
    parameter DATA_WIDTH = 32
) (
    input  wire                  clk,
    input  wire                  rst_n,
    
    // 操作数
    input  wire [DATA_WIDTH-1:0] a,
    input  wire [DATA_WIDTH-1:0] b,
    
    // 操作码
    input  wire [3:0]            opcode,
    
    // 使能
    input  wire                  enable,
    
    // 输出
    output reg  [DATA_WIDTH-1:0] result,
    output reg                   zero,
    output reg                   overflow
);

    // 操作码定义
    typedef enum logic [3:0] {
        ADD  = 4'h0,
        SUB  = 4'h1,
        AND  = 4'h2,
        OR   = 4'h3,
        XOR  = 4'h4,
        SLL  = 4'h5,
        SRL  = 4'h6,
        SRA  = 4'h7
    } opcode_e;
    
    // 计算逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result   <= 32'h0;
            zero     <= 1'b1;
            overflow <= 1'b0;
        end else if (enable) begin
            case (opcode)
                ADD: begin
                    result   <= a + b;
                    overflow <= (a[31] & b[31] & ~result[31]) ||
                               (~a[31] & ~b[31] & result[31]);
                end
                SUB: begin
                    result   <= a - b;
                    overflow <= (a[31] & ~b[31] & ~result[31]) ||
                               (~a[31] & b[31] & result[31]);
                end
                AND: result <= a & b;
                OR:  result <= a | b;
                XOR: result <= a ^ b;
                SLL: result <= a << b[4:0];
                SRL: result <= a >> b[4:0];
                SRA: result <= $signed(a) >>> b[4:0];
                default: result <= 32'h0;
            endcase
            
            zero <= (result == 32'h0);
        end
    end
    
endmodule : simple_alu
