`timescale 1ns/1ps
class irq_sb extends uvm_scoreboard;
    `uvm_component_utils(irq_sb) int irq_cnt;
    function new(string n,uvm_component p);super.new(n,p);irq_cnt=0;endfunction
    virtual function void write(bit[3:0] id); irq_cnt++; `uvm_info("SB",$sformatf("IRQ#%0d (total=%0d)",id,irq_cnt),UVM_LOW) endfunction
endclass
module tb; initial begin irq_sb sb; sb=new("sb",null); #50; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
