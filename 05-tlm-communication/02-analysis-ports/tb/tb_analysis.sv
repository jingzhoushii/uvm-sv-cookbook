// Testbench for analysis ports
`timescale 1ns/1ps
module tb_analysis;
    initial begin
        $display("Analysis ports testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_analysis); end
endmodule
