// ============================================================================
// Full TLM Sockets Example
// ============================================================================
`timescale 1ns/1ps
class tx extends uvm_sequence_item; rand bit [31:0] d; `uvm_object_utils_begin(tx) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end endclass
class ini extends uvm_component; `uvm_component_utils(ini) uvm_tlm_b_initiator_socket#(ini,tx) ini_skt;
    task run_phase(uvm_phase p); tx t; forever begin t=new(); t.randomize(); ini_skt.b_transport(t,#(5)); #20; end endtask
endclass
class tgt extends uvm_component; `uvm_component_utils(tgt) uvm_tlm_b_target_socket#(tgt,tx) tgt_skt;
    task b_transport(tx t, output int delay); $display("got d=%0d",t.d); delay=5; endtask
endclass
module tb_skt; initial begin ini i; tgt t; i=new("i",null); t=new("t",null); i.ini_skt.connect(t.tgt_skt); #200; $finish; end initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_skt); end endmodule
