// ============================================================
// File: 01_factory_override.sv
// Description: 工厂机制示例
// ============================================================

`timescale 1ns/1ps

// 1. 原始事务
class original_txn extends uvm_sequence_item;
    `uvm_object_utils(original_txn)
    
    bit [31:0] addr;
    
    function new(string name = "original_txn");
        super.new(name);
    endfunction
    
    virtual void do_print(uvm_printer printer);
        printer.print_field("addr", addr, 32, UVM_HEX);
    endfunction
endclass

// 2. 新事务类型
class new_txn extends original_txn;
    `uvm_object_utils(new_txn)
    
    bit [31:0] data;
    
    function new(string name = "new_txn");
        super.new(name);
    endfunction
    
    virtual void do_print(uvm_printer printer);
        printer.print_field("addr", addr, 32, UVM_HEX);
        printer.print_field("data", data, 32, UVM_HEX);
    endfunction
endclass

module tb_factory_override;
    
    original_txn txn;
    
    initial begin
        $display("========================================");
        $display("  Factory Override Demo");
        $display("========================================");
        $display("");
        
        // 设置类型覆盖
        set_type_override_by_type(original_txn::get_type(), new_txn::get_type());
        
        // 创建实例 - 实际创建的是 new_txn
        txn = original_txn::type_id::create("txn");
        
        if ($cast(new_txn, txn)) begin
            $display("Type cast successful - got new_txn!");
            new_txn nt;
            $cast(nt, txn);
            nt.addr = 32'h1000;
            nt.data = 32'hABCD;
            nt.print();
        end else begin
            $display("Type cast failed - got original_txn");
            txn.addr = 32'h2000;
            txn.print();
        end
        
        $display("");
        $display("========================================");
        $display("  Factory Override Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_factory_override);
    end
    
endmodule
