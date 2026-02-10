// ============================================================================
// Full UVM Resource DB Example
// ============================================================================
`timescale 1ns/1ps
class cfg extends uvm_object; int v; `uvm_object_utils_begin(cfg) `uvm_field_int(v,UVM_ALL_ON) `uvm_object_utils_end endclass
class comp extends uvm_component; `uvm_component_utils(comp) cfg c;
    task run_phase(uvm_phase p); phase.raise_objection(this);
        if(uvm_resource_db#(cfg)::read_by_name("scope","cfg",c)) $display("got cfg v=%0d",c.v);
        else $display("cfg not found");
        #50; phase.drop_objection(this);
    endtask
endclass
module tb_res; initial begin comp c; c=new("c",null); uvm_resource_db#(cfg)::write("scope","cfg",cfg::type_id::create("cfg")); c.v=42; #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_res); end endmodule
