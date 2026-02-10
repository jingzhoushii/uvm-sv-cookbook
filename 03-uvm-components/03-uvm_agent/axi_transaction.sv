// ============================================================================
// @file    : axi_transaction.sv
// @brief   : AXI 事务项
// @note    : 包含 AW/AR/W/R/B 通道
// ============================================================================

`timescale 1ns/1ps

// 事务类型
typedef enum bit [1:0] {READ = 0, WRITE = 1} rw_e;

// 事务类
class axi_transaction extends uvm_sequence_item;
    // 地址
    rand bit [31:0]         addr;
    rand bit [3:0]          len;        // Burst length
    rand bit [2:0]          size;       // Burst size
    rand bit [1:0]          burst;      // Burst type
    rand bit [3:0]          cache;      // Cache
    rand bit [5:0]          prot;       // Protection
    rand bit [3:0]          qos;        // QoS
    rand bit                resp;       // Response
    
    // 数据（WRITE）
    rand bit [31:0]         data[];
    rand bit [3:0]          strb[];     // Write strobes
    
    // 标识
    rand int                id;
    bit                      last;
    
    // 控制
    rw_e                    rw_type;
    int                     delay;
    
    `uvm_object_utils_begin(axi_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(len, UVM_ALL_ON)
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(burst, UVM_ALL_ON)
        `uvm_field_int(cache, UVM_ALL_ON)
        `uvm_field_int(prot, UVM_ALL_ON)
        `uvm_field_int(qos, UVM_ALL_ON)
        `uvm_field_array_int(data, UVM_ALL_ON)
        `uvm_field_array_int(strb, UVM_ALL_ON)
        `uvm_field_int(id, UVM_ALL_ON)
        `uvm_field_int(last, UVM_ALL_ON)
        `uvm_field_enum(rw_e, rw_type, UVM_ALL_ON)
        `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint defaults {
        addr inside {[0:32'hFFFF_FFFF]};
        len  inside {[0:15]};
        size inside {[0:2]};           // 1,2,4 bytes
        burst inside {[0:2]};           // FIXED, INCR, WRAP
        cache == 0;
        prot == 0;
        qos == 0;
        data.size() == len + 1;
        strb.size() == len + 1;
        delay inside {[0:10]};
    }
    
    function new(string name = "axi_transaction");
        super.new(name);
        id = $urandom_range(0, 100);
        last = 1'b1;
    endfunction
    
    // 打印
    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("addr", addr, 32, UVM_HEX);
        printer.print_field("len", len, 8, UVM_DEC);
        printer.print_field("size", size, 3, UVM_DEC);
        printer.print_enum("rw_type", rw_type, UVM_BIN);
    endfunction
    
    // 复制
    virtual function void do_copy(uvm_object rhs);
        axi_transaction tr;
        $cast(tr, rhs);
        addr = tr.addr;
        len = tr.len;
        size = tr.size;
        burst = tr.burst;
        data = tr.data;
        id = tr.id;
        rw_type = tr.rw_type;
    endfunction
    
    // 比较
    virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        axi_transaction tr;
        $cast(tr, rhs);
        return (addr == tr.addr) && (len == tr.len) && (id == tr.id);
    endfunction
endclass : axi_transaction
