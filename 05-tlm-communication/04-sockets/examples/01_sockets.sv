// ============================================================================
// @file    : 01_sockets.sv
// @brief   : TLM Socket 演示
// @note    : 展示双向通信
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] addr;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Initiator - 发起通信
class initiator extends uvm_component;
    `uvm_component_utils(initiator)
    uvm_tlm_b_initiator_socket#(initiator, txn) ini_socket;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ini_socket = new("ini_socket", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        repeat (3) begin
            txn tr; tr = txn::type_id::create("tr");
            void'(tr.randomize());
            $display("[%0t] [%s] Initiator: calling b_transport", 
                     $time, get_full_name());
            ini_socket.b_transport(tr, 10);
            $display("[%0t] [%s] Initiator: done", $time, get_full_name());
            #10;
        end
        
        phase.drop_objection(this);
    endtask
endclass

// Target - 响应通信
class target extends uvm_component;
    `uvm_component_utils(target)
    uvm_tlm_b_target_socket#(target, txn) tgt_socket;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        tgt_socket = new("tgt_socket", this);
    endfunction
    
    // 实现 b_transport
    virtual task b_transport(txn tr, output int delay);
        $display("[%0t] [%s] Target: received addr=0x%0h", 
                 $time, get_full_name(), tr.addr);
        #5;
        delay = 5;
    endtask
endclass

module tb_sockets;
    initial begin
        $display("========================================");
        $display("  TLM Socket Demo");
        $display("========================================");
        
        initiator ini;
        target tgt;
        
        ini = new("ini", null);
        tgt = new("tgt", null);
        
        // 连接
        ini.ini_socket.connect(tgt.tgt_socket);
        
        #200;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_sockets); end
endmodule
