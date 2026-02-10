// Testbench for RAL
`timescale 1ns/1ps
module tb_reg_block;
    initial begin
        $display("Register block testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_reg_block); end
endmodule
