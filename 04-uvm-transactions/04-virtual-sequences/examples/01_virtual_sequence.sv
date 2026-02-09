// ============================================================
// File: 01_virtual_sequence.sv
// Description: Virtual Sequence 示例
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

// 子序列
class child_sequence extends uvm_sequence#(bus_txn);
    `uvm_object_utils(child_sequence)
    
    string name;
    
    function new(string n = "child_sequence");
        super.new(n);
    endfunction
    
    task body();
        repeat (2) begin
            bus_txn tr;
            tr = bus_txn::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize());
            `uvm_info(get_type_name(), 
                $sformatf("[%s] addr=0x%0h", name, tr.addr), UVM_LOW)
            finish_item(tr);
        end
    endtask
endclass

// 虚拟序列
class virtual_sequence extends uvm_sequence;
    `uvm_object_utils(virtual_sequence)
    
    uvm_sequencer#(bus_txn) sq1;
    uvm_sequencer#(bus_txn) sq2;
    
    function new(string name = "virtual_sequence");
        super.new(name);
    endfunction
    
    task body();
        `uvm_info(get_type_name(), "Starting virtual sequence", UVM_LOW)
        
        // 并行执行多个子序列
        fork
            begin
                child_sequence seq1;
                seq1 = new("SEQ1");
                seq1.name = "SEQ1";
                seq1.start(sq1);
            end
            begin
                child_sequence seq2;
                seq2 = new("SEQ2");
                seq2.name = "SEQ2";
                seq2.start(sq2);
            end
        join
        
        `uvm_info(get_type_name(), "Virtual sequence completed", UVM_LOW)
    endtask
endclass

module tb_virtual_sequence;
    
    uvm_sequencer#(bus_txn) sq1, sq2;
    
    initial begin
        sq1 = new("sq1", null);
        sq2 = new("sq2", null);
        
        $display("========================================");
        $display("  Virtual Sequence Demo");
        $display("========================================");
        $display("");
        
        virtual_sequence vseq;
        vseq = new("vseq");
        vseq.sq1 = sq1;
        vseq.sq2 = sq2;
        
        fork
            vseq.start(null);
        join
        
        #200;
        
        $display("");
        $display("========================================");
        $display("  Virtual Sequence Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_virtual_sequence);
    end
    
endmodule
