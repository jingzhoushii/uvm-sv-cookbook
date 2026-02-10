// Testbench for data types
`timescale 1ns/1ps
module tb_data_types;
    reg clk, rst_n;
    reg [31:0] a, b;
    reg [3:0] opcode;
    wire [31:0] result;
    
    simple_alu dut (clk, rst_n, a, b, opcode, result);
    
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end
    initial begin
        rst_n = 0; #10 rst_n = 1;
        a = 10; b = 5; opcode = 0;
        #10 opcode = 1;
        #10 opcode = 2;
        #30 $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_data_types); end
endmodule
