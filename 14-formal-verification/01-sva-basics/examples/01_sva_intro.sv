// ============================================================================
// SVA 基础示例
// ============================================================================

`timescale 1ns/1ps

module tb_sva;
    bit clk, rst_n;
    bit [7:0] a, b;
    
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        a = 0; b = 0;
        #20; rst_n = 1;
        repeat(50) begin
            a = $random();
            b = $random();
            @(posedge clk);
        end
        #100; $finish;
    end
    
    // 并行断言：复位后 a < b
    assert property (@(posedge clk) rst_n |-> (a < b))
        else $error("Assertion failed: a >= b after reset");
    
    // 断言：a 变化后 b 应该在 3 个周期内响应
    assert property (@(posedge clk)
        $changed(a) |-> ##[1:3] $changed(b))
        else $error("b not响应!");
    
    initial begin
        $dumpfile("sva.vcd");
        $dumpvars(0, tb_sva);
    end
endmodule
