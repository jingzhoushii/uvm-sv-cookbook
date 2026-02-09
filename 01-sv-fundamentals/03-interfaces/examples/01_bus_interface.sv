// ============================================================
// File: 01_bus_interface.sv
// Description: 总线接口使用示例
// ============================================================

`timescale 1ns/1ps

module bus_interface_demo;
    
    bit clk;
    bit rst_n;
    
    // 实例化接口
    bus_if #(.ADDR_W(32), .DATA_W(32)) bus (clk, rst_n);
    
    // 时钟
    always #5 clk = ~clk;
    
    // 复位
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // 主设备任务
    task write_word;
        input [31:0] addr, data;
        begin
            $display("  [WRITE] addr=0x%0h data=0x%0h", addr, data);
            
            // Write Address
            bus.cb.awaddr <= addr;
            bus.cb.awvalid <= 1'b1;
            
            // Write Data
            bus.cb.wdata <= data;
            bus.cb.wstrb <= 4'hF;
            bus.cb.wvalid <= 1'b1;
            
            // 等待握手
            wait(bus.cb.awready && bus.cb.awvalid);
            @(posedge clk);
            bus.cb.awvalid <= 0;
            
            wait(bus.cb.wready && bus.cb.wvalid);
            @(posedge clk);
            bus.cb.wvalid <= 0;
            
            // 写响应
            bus.cb.bready <= 1'b1;
            wait(bus.cb.bvalid);
            @(posedge clk);
            bus.cb.bready <= 0;
            
            $display("  [WRITE] Complete, bresp=%0d", bus.cb.bresp);
        end
    endtask
    
    initial begin
        $display("========================================");
        $display("  Bus Interface Demo");
        $display("========================================");
        $display("");
        
        // 等待复位
        @(posedge rst_n);
        $display("[@%0t] Reset complete", $time);
        
        // 写操作
        $display("");
        $display("--- Write Operations ---");
        write_word(32'h0000_1000, 32'h1234_5678);
        write_word(32'h0000_1004, 32'hAAAA_BBBB);
        write_word(32'h0000_1008, 32'hCCCC_DDDD);
        
        $display("");
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, bus_interface_demo);
    end
    
endmodule
