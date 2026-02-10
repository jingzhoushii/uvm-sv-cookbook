// ============================================================================
// @file    : dma_if.sv
// @brief   : DMA 接口
// ============================================================================
`timescale 1ns/1ps

interface dma_if (input bit clk);
    logic [31:0] src_addr;
    logic [31:0] dst_addr;
    logic [15:0] length;
    logic [2:0]  channel;
    logic        burst;
    logic        start;
    logic        done;
    logic [3:0]  status;
endinterface : dma_if
