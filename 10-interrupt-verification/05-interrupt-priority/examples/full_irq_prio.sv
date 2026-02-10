// ============================================================================
// Full Interrupt Priority Example
// ============================================================================
`timescale 1ns/1ps
class irq_arb extends uvm_component; `uvm_component_utils(irq_arb) bit [7:0] irqs[4];
    function bit [2:0] select(); bit [2:0] p=0; for(int i=0;i<4;i++) if(irqs[i]) p=i; return p; endfunction
    task run_phase(uvm_phase p); phase.raise_objection(this); forever begin #10; irqs[0]=1; irqs[1]=0; irqs[2]=1; irqs[3]=0; `uvm_info("ARB",$sformatf("select=%0d",select()),UVM_LOW) end phase.drop_objection(this); endtask
endclass
module tb_ip; initial begin irq_arb a; a=new("a",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ip); end endmodule
