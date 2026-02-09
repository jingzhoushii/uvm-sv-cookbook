// ============================================================
// File: 01_procedural_blocks.sv
// Description: SystemVerilog 过程块示例
// ============================================================

`timescale 1ns/1ps

module procedural_blocks_demo;
    
    reg clk;
    reg rst_n;
    reg [7:0] counter;
    reg [7:0] comb_reg;
    reg [7:0] ff_reg;
    
    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 复位
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // 1. always_ff - 同步时序逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff_reg <= 8'h00;
        end else begin
            ff_reg <= ff_reg + 1;
        end
    end
    
    // 2. always_comb - 组合逻辑 (自动敏感列表)
    always_comb begin
        comb_reg = ff_reg + 8'h01;
    end
    
    // 3. always_latch - 锁存器 (谨慎使用)
    reg [7:0] latch_reg;
    reg latch_enable;
    
    always_latch begin
        if (latch_enable) begin
            latch_reg = comb_reg;
        end
    end
    
    // 4. always - 通用过程块 (不推荐)
    reg [7:0] old_reg;
    always @(posedge clk) begin
        old_reg <= ff_reg;
    end
    
    // 5. initial - 一次性执行
    integer i;
    initial begin
        $display("========================================");
        $display("  Procedural Blocks Demo");
        $display("========================================");
        $display("");
        
        // 测试 latch
        latch_enable = 0;
        #10 latch_enable = 1;
        #10 latch_enable = 0;
        
        #100;
        
        $display("");
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    // 波形
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, procedural_blocks_demo);
    end
    
endmodule
