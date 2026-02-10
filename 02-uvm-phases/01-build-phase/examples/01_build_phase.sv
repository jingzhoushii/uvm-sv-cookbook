// ============================================================================
// @file    : 01_build_phase.sv
// @brief   : build_phase 完整示例
// ============================================================================
`timescale 1ns/1ps

class my_driver extends uvm_driver;
    `uvm_component_utils(my_driver)
    int count;
    function new(string n, uvm_component p); super.new(n,p); endfunction
    virtual function void build_phase(uvm_phase ph);
        super.build_phase(ph);
        if(!uvm_config_db#(int)::get(this,"","count",count))
            `uvm_warning("NO_CFG","Using default")
        `uvm_info(get_name(),$sformatf("count=%0d",count),UVM_LOW)
    endfunction
    task run_phase(uvm_phase ph); ph.raise_objection(this); #100; ph.drop_objection(this); endtask
endclass

class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    my_driver drv;
    function new(string n, uvm_component p); super.new(n,p); endfunction
    virtual function void build_phase(uvm_phase ph);
        super.build_phase(ph);
        drv = my_driver::type_id::create("drv",this);
        uvm_config_db#(int)::set(this,"drv","count",100);
    endfunction
    task run_phase(uvm_phase ph); ph.raise_objection(this); #100; ph.drop_objection(this); endtask
endclass

module tb_build; initial begin my_agent a; a=new("a",null); #200; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb_build); endmodule
