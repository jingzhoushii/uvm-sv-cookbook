// TB for UVM phases demo
`timescale 1ns/1ps
module tb_phases;
    reg clk, rst_n;
    reg [7:0] d;
    wire [7:0] q;
    
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst_n = 0; #10 rst_n = 1; d = 8'h55; #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_phases); end
    
    simple_dut dut (clk, rst_n, d, q);
endmodule
