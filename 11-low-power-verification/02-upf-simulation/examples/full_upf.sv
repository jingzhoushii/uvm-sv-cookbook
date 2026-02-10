// ============================================================================
// Full UPF Simulation Example
// ============================================================================
`timescale 1ns/1ps
module upf_dut(input clk, input rst_n, input pwr_on, output reg [7:0] q);
    always @(posedge clk) if (rst_n && pwr_on) q <= q + 1; else q <= 0;
endmodule
module tb_upf; bit clk, rst_n, pwr_on; wire [7:0] q;
    initial begin clk=0; forever #5 clk=~clk; end
    initial begin rst_n=0; #10 rst_n=1; pwr_on=0; #20 pwr_on=1; #50 pwr_on=0; #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_upf); end
endmodule
