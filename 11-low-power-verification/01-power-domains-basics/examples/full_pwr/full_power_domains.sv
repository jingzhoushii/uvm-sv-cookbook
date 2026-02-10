// ============================================================================
// Full Power Domains Example
// ============================================================================
`timescale 1ns/1ps

typedef enum {ON, OFF, RET} pwr_state_e;

class pwr_controller extends uvm_component;
    `uvm_component_utils(pwr_controller)
    pwr_state_e state;
    function new(string n, uvm_component p); super.new(n,p); state=OFF; endfunction
    task run_phase(uvm_phase p); phase.raise_objection(this); forever begin #50; case(state) OFF: begin `uvm_info("PWR","OFF->ON",UVM_LOW) state=ON; end ON: begin `uvm_info("PWR","ON->RET",UVM_LOW) state=RET; end RET: begin `uvm_info("PWR","RET->OFF",UVM_LOW) state=OFF; end endcase end phase.drop_objection(this); endtask
endclass

module tb_pwr;
    initial begin pwr_controller pc; pc=new("pc",null); #500; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_pwr); end
endmodule
