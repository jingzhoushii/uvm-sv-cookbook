// ============================================================================
// Full Coverage Example
// ============================================================================
`timescale 1ns/1ps

class cov_example extends uvm_component;
    `uvm_component_utils(cov_example)
    
    covergroup cg;
        cp_addr: coverpoint addr { bins low = {[0:100]}; bins mid = {[101:200]}; bins high = {[201:255]}; }
        cp_data: coverpoint data { bins zero = {0}; bins nonzero[4] = {[1:255]}; }
        cross_cp: cross cp_addr, cp_data;
    endgroup
    
    bit [7:0] addr, data;
    
    function new(string n, uvm_component p);
        super.new(n,p); cg = new();
    endtask
    
    task run_phase(uvm_phase p);
        phase.raise_objection(this);
        repeat(100) begin
            addr = $urandom; data = $urandom;
            `uvm_info("COV",$sformatf("addr=%0d data=%0d",addr,data),UVM_LOW)
            cg.sample();
            #10;
        end
        phase.drop_objection(this);
    endtask
    
    virtual function void report_phase(uvm_phase p);
        super.report_phase(p);
        `uvm_info("COV_REPORT",$sformatf("Coverage: %.1f%%",cg.get_coverage()),UVM_LOW)
    endtask
endclass

module tb_cov;
    initial begin cov_example c; c=new("c",null); #1000; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_cov); end
endmodule
