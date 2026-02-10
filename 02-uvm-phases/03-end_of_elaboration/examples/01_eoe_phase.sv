// ============================================================================
// @file    : 01_eoe_phase.sv
// @brief   : end_of_elaboration 完整示例
// ============================================================================
`timescale 1ns/1ps

class my_env extends uvm_env; `uvm_component_utils(my_env) function new(string n,uvm_component p);super.new(n,p);endfunction
    virtual function void build_phase(uvm_phase ph);super.build_phase(ph); endfunction
    virtual function void end_of_elaboration_phase(uvm_phase ph);
        super.end_of_elaboration_phase(ph);
        `uvm_info(get_name(),"end_of_elaboration_phase",UVM_LOW)
        printTopology();
    endfunction
    task run_phase(uvm_phase ph); ph.raise_objection(this); #100; ph.drop_objection(this); endtask
endclass

module tb_eoe; initial begin my_env e; e=new("e",null); #200; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb_eoe); endmodule
