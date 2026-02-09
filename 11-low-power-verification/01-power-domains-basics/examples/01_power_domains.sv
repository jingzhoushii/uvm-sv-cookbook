// ============================================================
// File: 01_power_domains.sv
// Description: 电源域基础示例
// ============================================================

`timescale 1ns/1ps

module power_domains_demo;
    
    reg clk;
    reg rst_n;
    
    // 电源控制信号
    reg pwr_on_a;
    reg pwr_on_b;
    reg iso_a;
    reg iso_b;
    
    // 电源状态
    typedef enum logic [1:0] {OFF, ON, RET} pwr_state_t;
    pwr_state_t state_a, state_b;
    
    // 电源状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_a <= OFF;
            state_b <= OFF;
        end else begin
            // Domain A
            case (state_a)
                OFF: if (pwr_on_a) state_a <= ON;
                ON:  if (!pwr_on_a) state_a <= OFF;
            endcase
            
            // Domain B
            case (state_b)
                OFF: if (pwr_on_b) state_b <= ON;
                ON:  if (!pwr_on_b) state_b <= OFF;
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
        $display("  Power Domains Demo");
        $display("========================================");
        $display("");
        
        @(posedge rst_n);
        $display("[@%0t] Reset complete", $time);
        
        // 测试 1: 上电
        $display("");
        $display("--- Test 1: Power On ---");
        pwr_on_a = 1'b1;
        pwr_on_b = 1'b1;
        #20;
        $display("[@%0t] Domain A: %s, Domain B: %s", 
                 $time, state_a.name(), state_b.name());
        
        // 测试 2: 下电
        $display("");
        $display("--- Test 2: Power Off ---");
        pwr_on_a = 1'b0;
        pwr_on_b = 1'b0;
        #20;
        $display("[@%0t] Domain A: %s, Domain B: %s", 
                 $time, state_a.name(), state_b.name());
        
        #100;
        
        $display("");
        $display("========================================");
        $display("  Power Domains Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, power_domains_demo);
    end
    
endmodule
