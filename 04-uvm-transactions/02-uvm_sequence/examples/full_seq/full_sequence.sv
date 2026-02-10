// ============================================================================
// Full UVM Sequence Examples
// ============================================================================
`timescale 1ns/1ps

class seq_item extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    `uvm_object_utils_begin(seq_item) `uvm_field_int(addr,UVM_ALL_ON) `uvm_field_int(data,UVM_ALL_ON) `uvm_object_utils_end
endclass

class base_seq extends uvm_sequence#(seq_item);
    `uvm_object_utils(base_seq)
    int count=10;
    task body(); repeat(count) begin seq_item i; i=seq_item::type_id::create("i"); start_item(i); void'(i.randomize()); finish_item(i); end endtask
endclass

class extended_seq extends base_seq;
    `uvm_object_utils(extended_seq)
    task body(); `uvm_info("SEQ","Extended sequence start",UVM_LOW) super.body(); `uvm_info("SEQ","Extended sequence end",UVM_LOW) endtask
endclass

module tb_seq;
    initial begin base_seq b; extended_seq e; b=new("b"); e=new("e"); fork b.start(null); e.start(null); join #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_seq); end
endmodule
