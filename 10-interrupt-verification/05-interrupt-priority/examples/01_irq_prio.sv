`timescale 1ns/1ps
class irq_prio extends uvm_component;
    `uvm_component_utils(irq_prio) bit[2:0] current_irq;
    function new(string n,uvm_component p);super.new(n,p);endfunction
    function void set_prio(bit[3:0] irqs[]);
        // 简单优先级: 低索引优先
        $display("Selected IRQ#%0d", irqs[0]);
    endfunction
endclass
module tb; initial begin irq_prio p; p=new("p",null); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
