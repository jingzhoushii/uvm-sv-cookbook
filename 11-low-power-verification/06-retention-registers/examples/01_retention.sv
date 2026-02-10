`timescale 1ns/1ps
class retention_reg extends uvm_component;
    `uvm_component_utils(retention_reg) reg[31:0] reg_val, saved_val;
    function new(string n,uvm_component p);super.new(n,p);endfunction
    task save(); saved_val = reg_val; `uvm_info("RET",$sformatf("Saved 0x%0h",saved_val),UVM_LOW) endtask
    task restore(); reg_val = saved_val; `uvm_info("RET",$sformatf("Restored 0x%0h",reg_val),UVM_LOW) endtask
endclass
module tb; initial begin retention_reg r; r=new("r",null); r.reg_val=32'h1234; r.save(); #20; r.reg_val=0; #20; r.restore(); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
