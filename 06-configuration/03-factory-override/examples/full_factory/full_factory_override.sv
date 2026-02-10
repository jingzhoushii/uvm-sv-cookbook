// ============================================================================
// Full Factory Override Example
// ============================================================================
`timescale 1ns/1ps

class orig_txn extends uvm_sequence_item;
    bit [31:0] d; `uvm_object_utils_begin(orig_txn) `uvm_field_int(d,UVM_ALL_ON) `uvm_object_utils_end
endclass

class new_txn extends orig_txn;
    bit [31:0] e; `uvm_object_utils_begin(new_txn) `uvm_field_int(d,UVM_ALL_ON) `uvm_field_int(e,UVM_ALL_ON) `uvm_object_utils_end
endclass

module tb_factory;
    initial begin
        set_type_override_by_type(orig_txn::get_type(), new_txn::get_type());
        orig_txn t; t = orig_txn::type_id::create("t");
        if ($cast(new_txn, t)) begin `uvm_info("CAST","Success",UVM_LOW) end
        else begin `uvm_error("CAST","Failed") end
        #100; $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_factory); end
endmodule
