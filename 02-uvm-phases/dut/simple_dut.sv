// Simple DUT for UVM phases
`timescale 1ns/1ps
module simple_dut(input clk, rst_n, input [7:0] d, output reg [7:0] q);
    always @(posedge clk) q <= d;
endmodule
