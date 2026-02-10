// ============================================================================
// Full Pipelined Sequences Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class pipe_seq extends uvm_sequence#(tx); `uvm_object_utils(pipe_seq) int depth=4;
    task body(); tx q[$]; repeat(16) begin tx t; t=tx::type_id::create("t"); void'(t.randomize()); q.push_back(t); end
    fork begin foreach(q[i]) begin start_item(q[i]); finish_item(q[i]); end end join endtask
endclass
module tb_pipe; initial begin pipe_seq p; p=new("p"); p.start(null); #200; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_pipe); end endmodule
