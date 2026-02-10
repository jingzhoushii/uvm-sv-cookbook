// ============================================================================
// Full Interrupt Example
// ============================================================================
`timescale 1ns/1ps

class irq_txn extends uvm_sequence_item;
    rand bit [7:0] id; bit irq; `uvm_object_utils_begin(irq_txn) `uvm_field_int(id,UVM_ALL_ON) `uvm_field_int(irq,UVM_ALL_ON) `uvm_object_utils_end
endclass

class irq_driver extends uvm_driver#(irq_txn);
    `uvm_component_utils(irq_driver) virtual irq_if vif;
    task run_phase(uvm_phase p); forever begin seq_item_port.get(req); #10; end endtask
endclass

class irq_monitor extends uvm_monitor;
    `uvm_component_utils(irq_monitor) uvm_analysis_port#(irq_txn) ap; virtual irq_if vif;
    task run_phase(uvm_phase p); forever begin @(posedge vif.clk); if (vif.irq) begin irq_txn t; t=irq_txn::type_id::create("t"); t.irq=1; t.id=vif.id; ap.write(t); `uvm_info("IRQ",$sformatf("irq=%0d id=%0d",t.irq,t.id),UVM_LOW) end end endtask
endclass

class irq_agent extends uvm_agent;
    `uvm_component_utils(irq_agent) irq_driver drv; irq_monitor mon;
    virtual function void build_phase(uvm_phase p); drv=drv::type_id::create("drv",this); mon=mon::type_id::create("mon",this); endfunction
    virtual function void connect_phase(uvm_phase p); drv.seq_item_port.connect(mon.ap); endtask
endclass

module tb_irq;
    bit clk; bit [7:0] id; bit irq;
    interface irq_if (input clk); assign id = 8'h01; endinterface
    initial begin clk=0; forever #5 clk=~clk; end
    initial begin #20; irq=1; #10; irq=0; #20; irq=1; #10; irq=0; #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_irq); end
endmodule
