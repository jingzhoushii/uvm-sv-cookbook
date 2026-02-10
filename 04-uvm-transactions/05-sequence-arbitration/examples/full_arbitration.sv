// ============================================================================
// Full Sequence Arbitration Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class prio_seq extends uvm_sequence#(tx); `uvm_object_utils(prio_seq) int id;
    task body(); set_arbitration(SEQ_ARB_WEIGHTED); repeat(3) begin tx t; t=tx::type_id::create("t"); start_item(t); void'(t.randomize()); finish_item(t); end endtask
endclass
module tb_arb; initial begin uvm_sequencer#(tx) s; prio_seq p1,p2; s=new("s",null); p1=new("p1"); p1.id=1; p2=new("p2"); p2.id=2; fork p1.start(s); p2.start(s); join #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_arb); end endmodule
