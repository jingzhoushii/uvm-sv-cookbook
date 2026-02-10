// AXI-like slave for agent demo
`timescale 1ns/1ps
module axi_slave(input clk, rst_n, input [31:0] awaddr, input awvalid, output awready);
    assign awready = awvalid;
endmodule
