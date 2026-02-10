// Testbench for coverage
`timescale 1ns/1ps
module tb_coverage;
    initial begin
        $display("Coverage collection testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_coverage); end
endmodule
