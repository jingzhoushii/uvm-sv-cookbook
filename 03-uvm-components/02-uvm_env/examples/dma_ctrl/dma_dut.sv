// ============================================================================
// @file    : dma_dut.sv
// @brief   : DMA DUT
// ============================================================================
`timescale 1ns/1ps

module dma_dut (
    input bit clk,
    input bit rst_n,
    dma_if.master ifc
);
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            ifc.done <= 0;
        end else if (ifc.start) begin
            #100 ifc.done <= 1;
        end else begin
            ifc.done <= 0;
        end
endmodule : dma_dut
