// ============================================================================
// @file    : tb_mem.sv
// @brief   : 内存测试平台
// ============================================================================
`timescale 1ns/1ps

module tb_mem;
    bit clk;
    bit rst_n;
    
    mem_if ifc (clk);
    mem_dut dut (clk, rst_n, ifc.wr_addr, ifc.wr_data, ifc.wr_en, ifc.wr_ready,
                 ifc.rd_addr, ifc.rd_en, ifc.rd_data, ifc.rd_valid);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    initial begin
        uvm_config_db#(virtual mem_if)::set(null, "*", "vif", ifc);
    end
    
    initial begin
        #1000;
        $display("Simulation completed");
        $finish;
    end
    
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_mem); end
endmodule : tb_mem
