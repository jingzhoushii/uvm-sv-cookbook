// ============================================================================
// Full SystemVerilog Data Types Example
// ============================================================================
`timescale 1ns/1ps
module tb_types;
    // 四值逻辑
    logic [7:0] l; reg [7:0] r; wire [7:0] w;
    // 二值逻辑
    bit [7:0] b; int i; longint lj;
    // 有符号/无符号
    int si; unsigned [7:0] ui;
    // 数组
    bit [7:0] arr1[4]; bit [7:0] arr2[0:7]; int dyn[]; int q[$];
    // 结构体
    struct {bit [7:0] a; bit [7:0] b;} s;
    // 枚举
    typedef enum {IDLE, READ, WRITE} state_e; state_e st;
    initial begin
        l=8'h55; r=8'hAA; b=8'h12; i=100; lj=1000;
        si=-50; ui=200;
        foreach(arr1[i]) arr1[i]=i;
        foreach(arr2[i]) arr2[i]=i*2;
        dyn=new[4]; foreach(dyn[i]) dyn[i]=i;
        q.push_back(1); q.push_back(2); q.push_back(3);
        s.a=8'h10; s.b=8'h20;
        st=IDLE;
        $display("Types test complete");
        #100; $finish;
    end
endmodule
