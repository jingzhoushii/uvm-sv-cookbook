// ============================================================================
// Full TLM FIFO Example
// ============================================================================
`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [31:0] d; `uvm_object_utils_begin(txn) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end
endclass

module tb_tlm_fifo;
    initial begin
        uvm_tlm_fifo#(txn) fifo();
        fifo = new("fifo", null, 8);
        txn t;
        repeat(5) begin t=new("t"); void'(t.randomize()); fifo.put(t); `uvm_info("PUT",$sformatf("d=%0d",t.d),UVM_LOW) #10; end
        repeat(5) begin fifo.get(t); `uvm_info("GET",$sformatf("d=%0d",t.d),UVM_LOW) #10; end
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_tlm_fifo); end
endmodule
