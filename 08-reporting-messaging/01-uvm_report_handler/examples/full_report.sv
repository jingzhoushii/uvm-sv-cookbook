// ============================================================================
// Full UVM Report Handler Example
// ============================================================================
`timescale 1ns/1ps
class demo extends uvm_component; `uvm_component_utils(demo)
    task run_phase(uvm_phase p); phase.raise_objection(this);
        `uvm_info("INFO","Info message",UVM_LOW)
        `uvm_info("INFO2","Info message 2",UVM_MEDIUM)
        `uvm_warning("WARN","Warning message")
        `uvm_error("ERR","Error message")
        #50; phase.drop_objection(this);
    endtask
endclass
module tb_rep; initial begin demo d; d=new("d",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_rep); end endmodule
