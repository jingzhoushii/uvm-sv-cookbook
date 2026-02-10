// ============================================================================
// Full UVM Driver Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class drv extends uvm_driver#(tx); `uvm_component_utils(drv) virtual bus_if vif; int cnt;
    task run_phase(uvm_phase p); forever begin seq_item_port.get(req); drive(req); seq_item_port.item_done(); cnt++; end endtask
    protected task drive(tx t); `uvm_info("DRV",$sformatf("drive d=%0d",t.d),UVM_LOW) #10; endtask
endclass
module tb_drv; initial begin drv d; d=new("d",null); #100; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_drv); end endmodule
