`timescale 1ns/1ps
class base_seq extends uvm_sequence; `uvm_object_utils(base_seq) task body(); #10; endtask endclass
class test_seq extends base_seq; `uvm_object_utils(test_seq) task body(); `uvm_info("TEST","Running test",UVM_LOW) endtask endclass
module tb; initial begin test_seq s; s=new("s"); s.start(null); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
