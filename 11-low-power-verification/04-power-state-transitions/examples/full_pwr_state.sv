// ============================================================================
// Full Power State Transitions Example
// ============================================================================
`timescale 1ns/1ps
typedef enum {ON, OFF, RET} pst_e;
class pst extends uvm_component; `uvm_component_utils(pst) pst_e state;
    task run_phase(uvm_phase p); phase.raise_objection(this);
        state=OFF; `uvm_info("PST",$sformatf("OFF->ON"),UVM_LOW) #20; state=ON;
        `uvm_info("PST",$sformatf("ON->RET"),UVM_LOW) #20; state=RET;
        `uvm_info("PST",$sformatf("RET->OFF"),UVM_LOW) #20; state=OFF;
        phase.drop_objection(this);
    endtask
endclass
module tb_pst; initial begin pst p; p=new("p",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_pst); end endmodule
