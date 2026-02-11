// ============================================================================
// 常用断言示例 - 握手协议
// ============================================================================

`timescale 1ns/1ps

module tb_handshake;
    bit clk, rst_n;
    bit req, ack;
    
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        req = 0; ack = 0;
        #20; rst_n = 1;
        
        repeat(10) begin
            @(posedge clk);
            req = $random();
            #1;
            ack = $random();
        end
        #100; $finish;
    end
    
    // 握手断言
    assert property (@(posedge clk)
        rst_n |-> req |-> ##[1:3] ack)
        else $error("Handshake violation!");
    
    // req 和 ack 不能同时为高
    assert property (@(posedge clk)
        rst_n |-> !(req && ack))
        else $error("req and ack both high!");
    
    initial begin
        $dumpfile("handshake.vcd");
        $dumpvars(0, tb_handshake);
    end
endmodule
