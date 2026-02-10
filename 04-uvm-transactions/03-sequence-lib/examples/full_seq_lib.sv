// ============================================================================
// Full Sequence Library Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class rd_seq extends uvm_sequence#(tx); `uvm_object_utils(rd_seq) int cnt;
    task body(); repeat(cnt) begin tx t; t=tx::type_id::create("t"); t.randomize(); start_item(t); finish_item(t); end endtask
endclass
class wr_seq extends uvm_sequence#(tx); `uvm_object_utils(wr_seq) int cnt;
    task body(); repeat(cnt) begin tx t; t=tx::type_id::create("t"); t.randomize(); start_item(t); finish_item(t); end endtask
endclass
class burst_seq extends uvm_sequence#(tx); `uvm_object_utils(burst_seq) int len;
    task body(); for(int i=0;i<len;i++) begin tx t; t=tx::type_id::create("t"); t.randomize(); start_item(t); finish_item(t); end endtask
endclass
module tb_sl; initial begin rd_seq r; wr_seq w; burst_seq b; r=new("r"); r.cnt=5; w=new("w"); w.cnt=3; b=new("b"); b.len=8; fork r.start(null); w.start(null); b.start(null); join #200; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_sl); end endmodule
