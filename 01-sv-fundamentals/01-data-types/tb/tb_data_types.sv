// ============================================================
// File: tb_data_types.sv
// Description: SystemVerilog Data Types Testbench
// ============================================================

`timescale 1ns/1ps

module tb_data_types;
    
    // ========================================
    // 时钟和复位
    // ========================================
    bit clk;
    bit rst_n;
    
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // ========================================
    // DUT 信号
    // ========================================
    localparam DATA_W = 8;
    localparam OP_W   = 3;
    
    wire [DATA_W-1:0] result;
    wire              zero;
    wire              overflow;
    
    // ========================================
    // DUT 实例化
    // ========================================
    simple_alu #(
        .DATA_W(DATA_W),
        .OP_W(OP_W)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );
    
    // ========================================
    // 测试激励
    // ========================================
    reg [DATA_W-1:0] a, b;
    reg [OP_W-1:0]   op;
    
    int test_count;
    int pass_count;
    
    // 任务: 验证 ALU 操作
    task verify_op;
        input [OP_W-1:0]   op_code;
        input [DATA_W-1:0] input_a;
        input [DATA_W-1:0] input_b;
        input [DATA_W-1:0] expected;
        input string       name;
        
        reg [DATA_W-1:0] actual;
        begin
            a = input_a;
            b = input_b;
            op = op_code;
            
            @(posedge clk);
            #1;
            actual = result;
            
            test_count++;
            if (actual === expected) begin
                pass_count++;
                $display("  [PASS] %s: 0x%0h op 0x%0h = 0x%0h", 
                         name, input_a, input_b, actual);
            end else begin
                $display("  [FAIL] %s: expected=0x%0h, got=0x%0h",
                         name, expected, actual);
            end
        end
    endtask
    
    // ========================================
    // 测试程序
    // ========================================
    initial begin
        $display("");
        $display("╔═══════════════════════════════════════════════════════╗");
        $display("║     SystemVerilog Data Types - Testbench           ║");
        $display("╚═══════════════════════════════════════════════════════╝");
        $display("");
        
        test_count = 0;
        pass_count = 0;
        
        // 等待复位
        @(posedge rst_n);
        $display("[@%0t] System reset complete", $time);
        $display("");
        
        // 测试 1: 加法
        $display("--- Test 1: Addition ---");
        verify_op(3'b000, 8'hAA, 8'h55, 8'hFF, "ADD");
        
        // 测试 2: 减法
        $display("");
        $display("--- Test 2: Subtraction ---");
        verify_op(3'b001, 8'h55, 8'hAA, 8'hAB, "SUB");
        
        // 测试 3: AND
        $display("");
        $display("--- Test 3: AND ---");
        verify_op(3'b010, 8'hAA, 8'h55, 8'h00, "AND");
        
        // 测试 4: OR
        $display("");
        $display("--- Test 4: OR ---");
        verify_op(3'b011, 8'hAA, 8'h55, 8'hFF, "OR");
        
        // 测试 5: XOR
        $display("");
        $display("--- Test 5: XOR ---");
        verify_op(3'b100, 8'hAA, 8'h55, 8'hFF, "XOR");
        
        // 测试 6: NOT
        $display("");
        $display("--- Test 6: NOT ---");
        verify_op(3'b101, 8'hAA, 8'h00, 8'h55, "NOT");
        
        // 测试 7: 零标志
        $display("");
        $display("--- Test 7: Zero Flag ---");
        a = 8'h00;
        b = 8'h00;
        op = 3'b000;
        @(posedge clk);
        #1;
        test_count++;
        if (zero === 1'b1) begin
            pass_count++;
            $display("  [PASS] Zero flag is set");
        end else begin
            $display("  [FAIL] Zero flag should be set");
        end
        
        // 测试 8: 溢出检测
        $display("");
        $display("--- Test 8: Overflow Detection ---");
        a = 8'hFF;
        b = 8'h01;
        op = 3'b000;
        @(posedge clk);
        #1;
        test_count++;
        if (overflow === 1'b1) begin
            pass_count++;
            $display("  [PASS] Overflow detected");
        end else begin
            $display("  [FAIL] Overflow not detected");
        end
        
        // 测试 9: 随机测试
        $display("");
        $display("--- Test 9: Random Tests ---");
        repeat (5) begin
            a = $random;
            b = $random;
            op = $random % 8;
            @(posedge clk);
            #1;
            $display("  [RANDOM] a=0x%0h b=0x%0h op=%0d result=0x%0h",
                     a, b, op, result);
        end
        pass_count++;
        test_count++;
        $display("  [PASS] Random tests completed");
        
        // ========================================
        // 测试结果汇总
        // ========================================
        $display("");
        $display("╔═══════════════════════════════════════════════════════╗");
        $display("║                  Test Summary                         ║");
        $display("╚═══════════════════════════════════════════════════════╝");
        $display("");
        $display("  Total:  %0d", test_count);
        $display("  Passed: %0d", pass_count);
        $display("  Failed: %0d", test_count - pass_count);
        $display("");
        
        if (pass_count == test_count) begin
            $display("  ✅ ALL TESTS PASSED!");
        end else begin
            $display("  ❌ SOME TESTS FAILED!");
        end
        
        $display("");
        $finish;
    end
    
    // ========================================
    // 波形 dump
    // ========================================
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_data_types);
    end
    
endmodule
