// ============================================================================
// @file    : 01_connect_phase.sv
// @brief   : connect_phase 完整示例
// ============================================================================
`timescale 1ns/1ps

class txn extends uvm_sequence_item; rand bit[7:0] d; `uvm_object_utils_begin(txn) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass

class prod extends uvm_component; `uvm_component_utils(prod) uvm_analysis_port#(txn) ap; function new(string n,uvm_component p);super.new(n,p);ap=new("ap",this);endfunction task run_phase(uvm_phase ph); ph.raise_objection(this); repeat(3) begin txn t; t=txn::type_id::create("t"); void'(t.randomize()); ap.write(t); #10; end ph.drop_objection(this); endtask endclass

class cons extends uvm_component; `uvm_component_utils(cons) uvm_analysis_imp#(txn,cons) imp; int c; function new(string n,uvm_component p);super.new(n,p);imp=new("imp",this);c=0;endfunction virtual function void write(txn t); c++; `uvm_info(get_name(),$sformatf("got#%0d d=%0d",c,t.d),UVM_LOW) endfunction task run_phase(uvm_phase ph); ph.raise_objection(this); #100; ph.drop_objection(this); endtask endclass

module tb_connect; initial begin $display("Connect Phase Demo"); prod p; cons c; p=new("p",null); c=new("c",null); p.ap.connect(c.imp); #200; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb_connect); endmodule
