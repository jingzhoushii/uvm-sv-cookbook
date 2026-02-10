// Testbench for config_db
`timescale 1ns/1ps
module tb_config_db;
    initial begin
        $display("Config DB testbench");
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_config_db); end
endmodule
