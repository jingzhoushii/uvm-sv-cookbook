// ============================================================================
// Full Interrupt Scoreboard Example
// ============================================================================
`timescale 1ns/1ps
class irq_txn extends uvm_sequence_item; rand bit [7:0] id; `uvm_object_utils_begin(irq_txn) `uvm_field_int(id,UVM_ALL_ON) `uvm_object_utils_end endclass
class irq_sb extends uvm_scoreboard; `uvm_component_utils(irq_sb) uvm_analysis_imp#(irq_txn,irq_sb) imp; int cnt;
    function new(string n, uvm_component p); super.new(n,p); imp=new("imp",this); endfunction
    virtual function void write(irq_txn t); cnt++; `uvm_info("SB",$sformatf("irq#%0d cnt=%0d",t.id,cnt),UVM_LOW) endfunction
endclass
module tb_irs; initial begin irq_sb s; s=new("s",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_irs); end endmodule
