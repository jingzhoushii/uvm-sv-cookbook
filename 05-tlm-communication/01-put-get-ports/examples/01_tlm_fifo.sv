// ============================================================
// File: 01_tlm_fifo.sv
// Description: TLM FIFO 示例
// ============================================================

`timescale 1ns/1ps

class transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "transaction");
        super.new(name);
    endfunction
endclass

module tb_tlm_fifo;
    
    uvm_tlm_fifo#(transaction) fifo;
    transaction tr;
    int count;
    
    initial begin
        $display("========================================");
        $display("  TLM FIFO Demo");
        $display("========================================");
        $display("");
        
        fifo = new("fifo", null);
        fifo.set_size(8);
        count = 0;
        
        // Producer: 写入事务
        repeat (5) begin
            tr = new("tr");
            tr.addr = 32'h1000_0000 + (count * 32'h100);
            tr.data = count * 32'h1111_1111;
            
            if (fifo.can_put()) begin
                void'(fifo.put(tr));
                $display("[%0t] [PUT] addr=0x%0h data=0x%0h", 
                         $time, tr.addr, tr.data);
                count++;
            end
            #10;
        end
        
        $display("");
        $display("--- Consumer: 读取事务 ---");
        
        // Consumer: 读取事务
        repeat (5) begin
            if (fifo.can_get()) begin
                void'(fifo.get(tr));
                $display("[%0t] [GET] addr=0x%0h data=0x%0h", 
                         $time, tr.addr, tr.data);
            end
            #10;
        end
        
        $display("");
        $display("========================================");
        $display("  TLM FIFO Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_tlm_fifo);
    end
    
endmodule
