// ============================================================================
// @file    : tb_base.sv
// @brief   : 基础测试平台框架
// ============================================================================

`timescale 1ns/1ps

module tb_base;
    parameter CLK_PERIOD = 10;
    bit clk;
    bit rst_n;
    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        #(CLK_PERIOD * 2);
        rst_n = 1;
    end
    
    initial begin
        #1000;
        $display("Simulation completed");
        $finish;
    end
    
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_base); end
endmodule
