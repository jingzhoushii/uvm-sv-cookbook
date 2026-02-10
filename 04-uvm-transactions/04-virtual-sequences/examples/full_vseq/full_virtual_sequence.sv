// ============================================================================
// Full Virtual Sequence Example
// ============================================================================
`timescale 1ns/1ps

class tx extends uvm_sequence_item;
    rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end
endclass

class child_seq extends uvm_sequence#(tx);
    `uvm_object_utils(child_seq) string name;
    task body(); repeat(3) begin tx t; t=tx::type_id::create("t"); start_item(t); void'(t.randomize()); finish_item(t); end endtask
endclass

class virt_seq extends uvm_sequence;
    `uvm_object_utils(virt_seq)
    uvm_sequencer#(tx) sqr1, sqr2;
    task body(); fork begin child_seq s1; s1.name="SEQ1"; s1.start(sqr1); end begin child_seq s2; s2.name="SEQ2"; s2.start(sqr2); end join endtask
endclass

module tb_vseq;
    initial begin uvm_sequencer#(tx) s1, s2; s1=new("s1",null); s2=new("s2",null); virt_seq v; v=new("v"); v.sqr1=s1; v.sqr2=s2; v.start(null); #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_vseq); end
endmodule
