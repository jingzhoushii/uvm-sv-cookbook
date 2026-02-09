// ============================================================
// File: 01_sequence.sv
// Description: UVM Sequence 示例
// ============================================================

`timescale 1ns/1ps

class bus_txn extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    `uvm_object_utils_begin(bus_txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// 1. 基础序列
class base_sequence extends uvm_sequence#(bus_txn);
    `uvm_object_utils(base_sequence)
    
    int count = 5;
    
    function new(string name = "base_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        `uvm_info(get_type_name(), "Starting sequence", UVM_LOW)
        
        repeat (count) begin
            bus_txn tr;
            tr = bus_txn::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize() with { addr inside {[0:100]}; }) begin
                `uvm_warning("RANDFAIL", "Randomization failed")
            end
            `uvm_info(get_type_name(), 
                $sformatf("Generate: addr=0x%0h", tr.addr), UVM_LOW)
            finish_item(tr);
        end
        
        `uvm_info(get_type_name(), "Sequence completed", UVM_LOW)
    endtask
endclass

// 2. 握手序列
class handshake_sequence extends uvm_sequence#(bus_txn);
    `uvm_object_utils(handshake_sequence)
    
    task body();
        // 写操作
        repeat (3) begin
            bus_txn tr;
            tr = bus_txn::type_id::create("tr");
            start_item(tr);
            tr.rw = 1'b1;
            tr.addr = 32'h1000;
            tr.data = 32'hABCD;
            finish_item(tr);
        end
        
        // 读操作
        repeat (3) begin
            bus_txn tr;
            tr = bus_txn::type_id::create("tr");
            start_item(tr);
            tr.rw = 1'b0;
            tr.addr = 32'h1000;
            finish_item(tr);
        end
    endtask
endclass

module tb_sequence;
    
    initial begin
        $display("========================================");
        $display("  UVM Sequence Demo");
        $display("========================================");
        $display("");
        
        // 运行基础序列
        $display("--- Base Sequence ---");
        base_sequence seq1;
        seq1 = new("seq1");
        fork
            seq1.start(null);
        join_none
        
        #100;
        
        // 运行握手序列
        $display("");
        $display("--- Handshake Sequence ---");
        handshake_sequence seq2;
        seq2 = new("seq2");
        fork
            seq2.start(null);
        join_none
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  Sequence Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sequence);
    end
    
endmodule
