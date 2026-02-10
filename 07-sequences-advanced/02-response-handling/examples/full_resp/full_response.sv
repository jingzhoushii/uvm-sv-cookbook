// ============================================================================
// Full Response Handler Example
// ============================================================================
`timescale 1ns/1ps

class req extends uvm_sequence_item;
    rand bit [31:0] a; `uvm_object_utils_begin(req) `uvm_field_int(a,UVM_ALL_ON) `uvm_object_utils_end
endclass

class rsp extends uvm_sequence_item;
    bit [31:0] a; `uvm_object_utils_begin(rsp) `uvm_field_int(a,UVM_ALL_ON) `uvm_object_utils_end
endclass

class seq_with_rsp extends uvm_sequence#(req, rsp);
    `uvm_object_utils(seq_with_rsp)
    task body(); req rq; rsp rs; repeat(3) begin rq=req::type_id::create("rq"); start_item(rq); void'(rq.randomize()); finish_item(rq); get_response(rs); `uvm_info("RSP",$sformatf("got=%0d",rs.a),UVM_LOW) end endtask
endclass

class drv extends uvm_driver#(req, rsp);
    `uvm_component_utils(drv)
    task run_phase(uvm_phase p); forever begin req rq; seq_item_port.get(rq); #10; rsp rs; rs=rsp::type_id::create("rs"); rs.set_id_info(rq); rs.a = rq.a + 1; put_response(rs); end endtask
endclass

module tb_resp;
    initial begin uvm_sequencer#(req,rsp) sq; drv d; seq_with_rsp s; sq=new("sq",null); d=new("d",null); d.seq_item_port.connect(sq.seq_item_export); s=s::type_id::create("s"); fork s.start(sq); join #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_resp); end
endmodule
