// ============================================================================
// @file    : interfaces.sv
// @brief   : 公共接口定义
// @note    : 供所有章节使用的标准接口
// ============================================================================

`timescale 1ns/1ps

// ---------------------------------------------------------------------------
// 1. 时钟接口
// ---------------------------------------------------------------------------
interface clk_if (
    input bit clk
);
    logic rst_n = 1'b0;
    
    // 复位任务
    task reset(int cycles = 10);
        rst_n = 1'b0;
        repeat (cycles) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
    endtask
    
    // 等待周期
    task wait_cycles(int n = 1);
        repeat (n) @(posedge clk);
    endtask
endinterface : clk_if

// ---------------------------------------------------------------------------
// 2. 总线接口
// ---------------------------------------------------------------------------
interface bus_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input bit clk
);
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data;
    logic                  rw;      // 0=read, 1=write
    logic                  valid;
    logic                  ready;
    
    // 驱动任务
    task write(input [ADDR_WIDTH-1:0] waddr,
               input [DATA_WIDTH-1:0] wdata);
        addr  = waddr;
        data  = wdata;
        rw    = 1'b1;
        valid = 1'b1;
        @(posedge clk);
        while (!ready) @(posedge clk);
        valid = 1'b0;
    endtask
    
    task read(input [ADDR_WIDTH-1:0] raddr,
              output [DATA_WIDTH-1:0] rdata);
        addr  = raddr;
        rw    = 1'b0;
        valid = 1'b1;
        @(posedge clk);
        while (!ready) @(posedge clk);
        rdata = data;
        valid = 1'b0;
    endtask
    
endinterface : bus_if

// ---------------------------------------------------------------------------
// 3. 中断接口
// ---------------------------------------------------------------------------
interface irq_if (
    input bit clk
);
    logic [7:0] irq_id;
    logic       irq;
    logic       irq_ack;
    
    // 触发中断
    task fire(input [7:0] id);
        irq_id = id;
        irq    = 1'b1;
        @(posedge clk);
        while (!irq_ack) @(posedge clk);
        irq = 1'b0;
    endtask
    
endinterface : irq_if

// ---------------------------------------------------------------------------
// 4. 事务类（可在 TB 中使用）
// ---------------------------------------------------------------------------
class bus_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;      // 0=read, 1=write
    
    `uvm_object_utils_begin(bus_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name = "bus_transaction");
        super.new(name);
    endfunction
endclass

`endif // INTERFACES_SV
