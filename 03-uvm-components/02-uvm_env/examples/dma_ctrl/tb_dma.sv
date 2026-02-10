// ============================================================================
// @file    : tb_dma.sv
// @brief   : DMA 测试平台
// ============================================================================
`timescale 1ns/1ps

module tb_dma;
    bit clk;
    bit rst_n;
    
    dma_if ifc (clk);
    dma_dut dut (clk, rst_n, ifc);
    
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst_n = 0; #10 rst_n = 1; end
    initial begin #200; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_dma); end
endmodule : tb_dma
