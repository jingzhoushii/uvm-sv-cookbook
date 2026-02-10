// ============================================================================
// Full Retention Registers Example
// ============================================================================
`timescale 1ns/1ps
class ret_reg extends uvm_component; `uvm_component_utils(ret_reg) reg [31:0] val, saved;
    task save(); saved=val; `uvm_info("RET",$sformatf("saved=0x%0h",saved),UVM_LOW) endtask
    task restore(); val=saved; `uvm_info("RET",$sformatf("restored=0x%0h",val),UVM_LOW) endtask
endclass
module tb_ret; initial begin ret_reg r; r=new("r",null); r.val=32'h1234; r.save(); #20; r.val=0; r.restore(); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_ret); end endmodule
