// ============================================================================
// Full Power Controller VIP Example
// ============================================================================
`timescale 1ns/1ps
class pwr_seq extends uvm_sequence; `uvm_object_utils(pwr_seq)
    task body(); `uvm_info("PWR","ON",UVM_LOW) #30; `uvm_info("PWR","RET",UVM_LOW) #30; `uvm_info("PWR","OFF",UVM_LOW) #30; endtask
endclass
module tb_pwc; initial begin pwr_seq s; s=pwr_seq::type_id::create("s"); s.start(null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_pwc); end endmodule
