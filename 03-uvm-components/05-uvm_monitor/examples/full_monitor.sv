// ============================================================================
// Full UVM Monitor Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class mon extends uvm_monitor; `uvm_component_utils(mon) uvm_analysis_port#(tx) ap; virtual bus_if vif; int cnt;
    task run_phase(uvm_phase p); forever begin @(posedge vif.clk); if(vif.valid) begin tx t; t=tx::type_id::create("t"); t.d=vif.data; ap.write(t); cnt++; end end endtask
endclass
module tb_mon; initial begin mon m; m=new("m",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_mon); end endmodule
