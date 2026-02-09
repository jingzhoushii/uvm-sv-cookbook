// ============================================================
// File: 01_interrupt.sv
// Description: 中断验证基础示例
// ============================================================

`timescale 1ns/1ps

module interrupt_demo;
    
    reg clk;
    reg rst_n;
    
    // 中断信号
    reg irq;
    reg [3:0] irq_mask;
    reg [3:0] irq_status;
    reg [3:0] irq_pending;
    
    // 中断使能寄存器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            irq_mask <= 4'h0;
        end else begin
            if (irq) irq_pending <= irq_pending | 4'h1;
        end
    end
    
    // 中断状态机
    typedef enum logic [1:0] {IDLE, SERVICING, DONE} irq_state_t;
    irq_state_t state;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            irq_status <= 4'h0;
        end else begin
            case (state)
                IDLE: begin
                    if (|irq_pending) begin
                        state <= SERVICING;
                        irq_status <= irq_pending;
                        irq_pending <= 4'h0;
                    end
                end
                SERVICING: begin
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE;
                    irq_status <= 4'h0;
                end
            endcase
        end
    end
    
    // 时钟
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 复位
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // 测试
    initial begin
        $display("========================================");
        $display("  Interrupt Verification Demo");
        $display("========================================");
        $display("");
        
        // 等待复位
        @(posedge rst_n);
        $display("[@%0t] Reset complete", $time);
        
        // 测试 1: 触发中断
        $display("");
        $display("--- Test 1: Trigger Interrupt ---");
        #10 irq = 1'b1;
        #10 irq = 1'b0;
        #10;
        $display("[@%0t] IRQ triggered, pending=0x%0h", 
                 $time, irq_pending);
        
        // 测试 2: 多个中断
        $display("");
        $display("--- Test 2: Multiple Interrupts ---");
        repeat (3) begin
            #10 irq = 1'b1;
            #5 irq = 1'b0;
        end
        #20;
        $display("[@%0t] Pending=0x%0h", $time, irq_pending);
        
        #100;
        
        $display("");
        $display("========================================");
        $display("  Interrupt Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, interrupt_demo);
    end
    
endmodule
