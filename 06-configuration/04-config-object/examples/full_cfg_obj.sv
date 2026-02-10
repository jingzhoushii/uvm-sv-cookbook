// ============================================================================
// Full Config Object Example
// ============================================================================
`timescale 1ns/1ps
class agt_cfg extends uvm_object; rand bit is_active; rand int num_tx; `uvm_object_utils_begin(agt_cfg) `uvm_field_int(is_active,UVM_ALL_ON) `uvm_field_int(num_tx,UVM_ALL_ON) `uvm_object_utils_end endclass
class comp extends uvm_component; `uvm_component_utils(comp) agt_cfg cfg; function new(string n, uvm_component p); super.new(n,p); endfunction virtual function void build_phase(uvm_phase p); super.build_phase(p); if(!uvm_config_db#(agt_cfg)::get(this,"","cfg",cfg)) `uvm_warning("CFG","Using default") `uvm_info("CFG",$sformatf("is_active=%0d num_tx=%0d",cfg.is_active,cfg.num_tx),UVM_LOW) endtask endclass
module tb_cfg; initial begin comp c; c=new("c",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_cfg); end endmodule
