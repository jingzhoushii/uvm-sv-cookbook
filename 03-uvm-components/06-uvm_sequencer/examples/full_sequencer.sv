// ============================================================================
// Full UVM Sequencer Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class sqr extends uvm_sequencer#(tx); `uvm_component_utils(sqr) function new(string n, uvm_component p); super.new(n,p); endfunction endclass
class drv extends uvm_driver#(tx); `uvm_component_utils(drv) task run_phase(uvm_phase p); forever begin tx t; seq_item_port.get(t); $display("got d=%0d",t.d); #10; end endtask endclass
module tb_sqr; initial begin sqr s; drv d; s=new("s",null); d=new("d",null); d.seq_item_port.connect(s.seq_item_export); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_sqr); end endmodule
