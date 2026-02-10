// ============================================================================
// Full Interrupt Regression Example
// ============================================================================
`timescale 1ns/1ps
class base_test extends uvm_test; `uvm_component_utils(base_test) int pass=0,fail=0;
    task run_phase(uvm_phase p); phase.raise_objection(this); #50; `uvm_info("TEST","Complete",UVM_LOW) phase.drop_object); endtaskion(p
    virtual function void report_phase(uvm_phase p); super.report_phase(p); `uvm_info("REPORT",$sformatf("pass=%0d fail=%0d",pass,fail),UVM_LOW) endtask
endclass
class test_seq extends uvm_test; `uvm_component_utils(test_seq)
    task run_phase(uvm_phase p); phase.raise_objection(this); repeat(10) begin `uvm_info("SEQ","Run",UVM_LOW) #5; end phase.drop_objection(this); endtask
endclass
module tb_reg; initial begin base_test t; t=new("t",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_reg); end endmodule
