`timescale 1ns/1ps
class pwr_aware_seq extends uvm_sequence;
    `uvm_object_utils(pwr_aware_seq) task body();
        `uvm_info("PWR","Active mode",UVM_LOW) #30;
        `uvm_info("PWR","Enter retention",UVM_LOW) #30;
        `uvm_info("PWR","Enter OFF",UVM_LOW) #30;
        `uvm_info("PWR","Wake up",UVM_LOW) #30;
    endtask
endclass
module tb; initial begin pwr_aware_seq s; s=new("s"); s.start(null); #150; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
