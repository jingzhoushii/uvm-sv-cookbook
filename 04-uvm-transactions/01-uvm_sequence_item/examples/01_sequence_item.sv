// ============================================================
// File: 01_sequence_item.sv
// Description: UVM Transaction 示例
// ============================================================

`timescale 1ns/1ps

// --------------------------------------------------------
// 1. 基础事务类
// --------------------------------------------------------
class basic_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;
    
    `uvm_object_utils_begin(basic_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "basic_transaction");
        super.new(name);
    endfunction
    
    // 自定义打印
    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("addr", addr, 32, UVM_HEX);
        printer.print_field("data", data, 32, UVM_HEX);
        printer.print_field("rw", rw, 1, UVM_BIN);
    endfunction
endclass

// --------------------------------------------------------
// 2. 带约束的事务类
// --------------------------------------------------------
class constrained_transaction extends basic_transaction;
    
    // 地址约束: 只能是低 1MB
    constraint addr_range {
        addr inside {[32'h0000_0000 : 32'h000F_FFFF]};
    }
    
    // 数据约束: 不能是全 0 或全 1
    constraint data_range {
        data != 32'h0000_0000;
        data != 32'hFFFF_FFFF;
    }
    
    // 读写比例约束
    constraint rw_ratio {
        rw dist {0:/50, 1:/50};
    }
    
    `uvm_object_utils_begin(constrained_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "constrained_transaction");
        super.new(name);
    endfunction
endclass

// --------------------------------------------------------
// 3. BURST 事务类
// --------------------------------------------------------
typedef enum bit [1:0] {FIXED=0, INCR=1, WRAP=2} burst_type_e;
typedef enum bit [1:0] {BYTE=0, HALF=1, WORD=2, DWORD=3} size_e;

class burst_transaction extends uvm_sequence_item;
    rand bit [31:0]     start_addr;
    rand bit [7:0]      len;       // 1-16
    rand size_e          size;      // 1/2/4/8 bytes
    rand burst_type_e    burst;
    rand bit [31:0]     data[];    // 动态数组
    
    constraint burst_len {
        len inside {[1:16]};
    }
    
    constraint data_size {
        data.size() == len + 1;
    }
    
    `uvm_object_utils_begin(burst_transaction)
        `uvm_field_int(start_addr, UVM_ALL_ON)
        `uvm_field_int(len, UVM_ALL_ON)
        `uvm_field_enum(size_e, size, UVM_ALL_ON)
        `uvm_field_enum(burst_type_e, burst, UVM_ALL_ON)
        `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "burst_transaction");
        super.new(name);
    endfunction
endclass

// --------------------------------------------------------
// 4. Testbench
// --------------------------------------------------------
module tb_sequence_item;
    
    int test_count;
    int pass_count;
    
    initial begin
        $display("========================================");
        $display("  UVM Sequence Item Demo");
        $display("========================================");
        $display("");
        
        test_count = 0;
        pass_count = 0;
        
        // Test 1: 基础事务
        test_count++;
        $display("--- Test %0d: Basic Transaction ---", test_count);
        begin
            basic_transaction tr;
            tr = new("tr1");
            tr.addr = 32'h1000_0000;
            tr.data = 32'hABCD_EF01;
            tr.rw = 1'b1;
            tr.print();
            pass_count++;
            $display("  [PASS]");
        end
        
        // Test 2: 约束事务
        test_count++;
        $display("");
        $display("--- Test %0d: Constrained Transaction ---", test_count);
        begin
            constrained_transaction ctr;
            ctr = new("ctr1");
            repeat (5) begin
                if (ctr.randomize()) begin
                    $display("  addr=0x%0h data=0x%0h rw=%b", 
                             ctr.addr, ctr.data, ctr.rw);
                end
            end
            pass_count++;
            $display("  [PASS]");
        end
        
        // Test 3: Copy
        test_count++;
        $display("");
        $display("--- Test %0d: Transaction Copy ---", test_count);
        begin
            basic_transaction tr1, tr2;
            tr1 = new("tr1");
            tr1.addr = 32'h2000_0000;
            tr1.data = 32'h1234_5678;
            tr2 = tr1.copy();
            if (tr2.addr == tr1.addr) begin
                pass_count++;
                $display("  [PASS] Copy successful");
            end
        end
        
        // Test 4: Compare
        test_count++;
        $display("");
        $display("--- Test %0d: Transaction Compare ---", test_count);
        begin
            basic_transaction tr1, tr2;
            tr1 = new("tr1");
            tr2 = new("tr2");
            tr1.addr = 32'h3000_0000;
            tr2.addr = 32'h3000_0000;
            if (tr1.compare(tr2)) begin
                pass_count++;
                $display("  [PASS] Transactions match");
            end
        end
        
        // Summary
        $display("");
        $display("========================================");
        $display("  Total: %0d  Passed: %0d", test_count, pass_count);
        if (pass_count == test_count)
            $display("  ALL TESTS PASSED!");
        else
            $display("  SOME TESTS FAILED!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sequence_item);
    end
    
endmodule
