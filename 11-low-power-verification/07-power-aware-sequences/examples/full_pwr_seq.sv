// ============================================================================
// Full Power Aware Sequences Example
// ============================================================================
`timescale 1ns/1ps
class pwr_aware_seq extends uvm_sequence; `uvm_object_utils(pwr_aware_seq)
    task body(); `uvm_info("PWR","Active mode",UVM_LOW) #30; `uvm_info("PWR","Save state",UVM_LOW) #30; `uvm_info("PWR","OFF mode",UVM_LOW) #30; `uvm_info("PWR","Restore state",UVM_LOW) #30; endtask
endclass
module tb_pas; initial begin pwr_aware_seq s; s=pwr_aware_seq::type_id::create("s"); s.start(null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_pas); end endmodule
