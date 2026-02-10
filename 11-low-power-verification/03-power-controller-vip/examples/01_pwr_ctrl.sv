`timescale 1ns/1ps
class pwr_ctrl_seq extends uvm_sequence;
    `uvm_object_utils(pwr_ctrl_seq) task body(); repeat(3) begin #20; `uvm_info("PWR","State transition",UVM_LOW) end endtask
endclass
module tb; initial begin pwr_ctrl_seq s; s=new("s"); s.start(null); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
