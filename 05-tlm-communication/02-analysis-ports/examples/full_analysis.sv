// ============================================================================
// Full Analysis Ports Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class prod extends uvm_component; `uvm_component_utils(prod) uvm_analysis_port#(tx) ap; function new(string n, uvm_component p); super.new(n,p); ap=new("ap",this); endfunction task run_phase(uvm_phase p); forever begin tx t; t=tx::type_id::create("t"); void'(t.randomize()); ap.write(t); #10; end endtask endclass
class cons extends uvm_component; `uvm_component_utils(cons) uvm_analysis_imp#(tx,cons) imp; int c; function new(string n, uvm_component p); super.new(n,p); imp=new("imp",this); c=0; endfunction virtual function void write(tx t); c++; `uvm_info("CON",$sformatf("got#%0d d=%0d",c,t.d),UVM_LOW) endfunction endclass
module tb_an; initial begin prod p; cons c; p=new("p",null); c=new("c",null); p.ap.connect(c.imp); #200; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_an); end endmodule
