// ============================================================================
// Full Interrupt Sequences Example
// ============================================================================
`timescale 1ns/1ps
class irq_txn extends uvm_sequence_item; rand bit [7:0] id; `uvm_object_utils_begin(irq_txn) `uvm_field_int(id,UVM_ALL_ON) `uvm_object_utils_end endclass
class irq_seq extends uvm_sequence#(irq_txn); `uvm_object_utils(irq_seq) int cnt;
    task body(); repeat(5) begin irq_txn t; t=irq_txn::type_id::create("t"); start_item(t); t.randomize(); finish_item(t); end endtask
endclass
module tb_irsq; initial begin irq_seq s; s=irq_seq::type_id::create("s"); s.start(null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_irsq); end endmodule
