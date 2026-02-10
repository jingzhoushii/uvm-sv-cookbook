// Testbench for randomization
`timescale 1ns/1ps
module tb_randomization;
    initial begin
        $display("Randomization testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_randomization); end
endmodule
