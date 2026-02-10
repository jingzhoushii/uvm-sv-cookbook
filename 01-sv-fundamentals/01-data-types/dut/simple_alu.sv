// Simple ALU for data types demo
`timescale 1ns/1ps
module simple_alu(
    input clk, rst_n,
    input [31:0] a, b,
    input [3:0] opcode,
    output reg [31:0] result
);
    always @(posedge clk or negedge rst_n)
        if (!rst_n) result <= 0;
        else case(opcode)
            0: result <= a + b;  // ADD
            1: result <= a - b;  // SUB
            2: result <= a & b;  // AND
            3: result <= a | b;  // OR
            default: result <= 0;
        endcase
endmodule
