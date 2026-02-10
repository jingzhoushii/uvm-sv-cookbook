// Testbench for phases
`timescale 1ns/1ps
module tb_phases;
    initial begin
        $display("Phases testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_phases); end
endmodule
