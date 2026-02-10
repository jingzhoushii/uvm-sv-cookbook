`timescale 1ns/1ps
class irq_seq extends uvm_sequence;
    `uvm_object_utils(irq_seq) int irq_id;
    task body(); repeat(5) begin #10; `uvm_info("IRQ",$sformatf("Fire IRQ#%0d",irq_id),UVM_LOW) end endtask
endclass
module tb; initial begin irq_seq s; s=new("s"); s.irq_id=3; s.start(null); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule
