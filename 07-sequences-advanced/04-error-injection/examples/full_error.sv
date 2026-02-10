// ============================================================================
// Full Error Injection Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; bit err; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_field_int(err,UVM_ALL_ON) `uvm_object_utils_end endclass
class err_seq extends uvm_sequence#(tx); `uvm_object_utils(err_seq)
    task body(); repeat(5) begin tx t; t=tx::type_id::create("t"); start_item(t); t.randomize(); if ($urandom_range(10)>7) t.err=1; finish_item(t); end endtask
endclass
module tb_err; initial begin err_seq e; e=new("e"); e.start(null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_err); end endmodule
