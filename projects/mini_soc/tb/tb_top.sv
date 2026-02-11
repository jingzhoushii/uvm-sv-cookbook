// ============================================================================
// Testbench Top - 顶层测试平台
// ============================================================================

`timescale 1ns/1ps

`include "uvm_macros.svh"

module tb_top;
    
    // 时钟和复位
    bit clk = 0;
    bit rst_n = 0;
    
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
    end
    
    always #5 clk = ~clk;
    
    // UART 引脚
    bit uart_rx = 1;
    wire uart_tx;
    
    // DUT 实例
    mini_soc dut (
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .timer_irq()
    );
    
    // Interface 实例
    bus_if bus_if (.clk(clk), .rst_n(rst_n));
    uart_if uart_if (.clk(clk));
    
    // 连接 Interface 到 DUT
    assign bus_if.haddr  = dut.haddr;
    assign bus_if.hwdata = dut.hwdata;
    assign bus_if.hwrite = dut.hwrite;
    assign bus_if.hsize  = dut.hsize;
    assign bus_if.hburst = dut.hburst;
    assign bus_if.hsel   = 1'b1;
    assign dut.hrdata   = bus_if.hrdata;
    assign dut.hready   = bus_if.hready;
    assign dut.hresp    = bus_if.hresp;
    
    initial begin
        // 运行测试
        run_test();
    end
    
    // 波形记录
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end
    
endmodule
