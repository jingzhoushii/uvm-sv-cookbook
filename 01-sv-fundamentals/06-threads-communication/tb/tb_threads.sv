// Testbench for threads
`timescale 1ns/1ps
module tb_threads;
    initial begin
        $display("Threads testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_threads); end
endmodule
