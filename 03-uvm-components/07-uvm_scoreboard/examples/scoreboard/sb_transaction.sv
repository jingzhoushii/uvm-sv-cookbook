// Scoreboard transaction
`timescale 1ns/1ps
class sb_txn extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    `uvm_object_utils_begin(sb_txn) `uvm_field_int(addr,UVM_ALL_ON) `uvm_field_int(data,UVM_ALL_ON) `uvm_object_utils_end
endclass
