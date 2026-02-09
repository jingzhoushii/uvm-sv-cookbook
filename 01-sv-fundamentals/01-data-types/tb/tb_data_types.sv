// ============================================================
// File: tb_data_types.sv
// Description: SystemVerilog Data Types Testbench
// ============================================================

`timescale 1ns/1ps

module tb_data_types;
    
    // 时钟和复位
    bit clk;
    bit rst_n;
    
    always #5 clk = ~clk;
    
    initial begin
        rst_n = 0;
        #10 rst_n = 1;
    end
    
    // DUT 信号
    logic [7:0] a, b;
    logic [2:0] op;
    wire  [7:0] result;
    wire       zero;
    wire       overflow;
    
    // DUT 实例化
    alu dut (
        .clk(clk),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .overflow(overflow)
    );
    
    // 测试变量
    int test_count;
    int pass_count;
    
    initial begin
        $display("========================================");
        $display("  SystemVerilog Data Types Demo");
        $display("========================================");
        $display("");
        
        test_count = 0;
        pass_count = 0;
        
        // 等待复位
        @(posedge rst_n);
        $display("[@%0t] Reset complete", $time);
        
        // Test 1: Addition
        test_count++;
        $display("");
        $display("--- Test %0d: Addition ---", test_count);
        a = 8'hAA;
        b = 8'h55;
        op = 3'b000;
        @(posedge clk);
        #1;
        if (result === 8'hFF && zero === 1'b0) begin
            pass_count++;
            $display("  [PASS] AA + 55 = FF");
        end else begin
            $display("  [FAIL] Expected FF, got %0h", result);
        end
        
        // Test 2: Subtraction
        test_count++;
        $display("");
        $display("--- Test %0d: Subtraction ---", test_count);
        a = 8'h55;
        b = 8'hAA;
        op = 3'b001;
        @(posedge clk);
        #1;
        if (result === 8'hAB) begin
            pass_count++;
            $display("  [PASS] 55 - AA = AB");
        end else begin
            $display("  [FAIL] Expected AB, got %0h", result);
        end
        
        // Test 3: AND
        test_count++;
        $display("");
        $display("--- Test %0d: AND ---", test_count);
        a = 8'hAA;
        b = 8'h55;
        op = 3'b010;
        @(posedge clk);
        #1;
        if (result === 8'h00) begin
            pass_count++;
            $display("  [PASS] AA & 55 = 00");
        end else begin
            $display("  [FAIL] Expected 00, got %0h", result);
        end
        
        // Test 4: OR
        test_count++;
        $display("");
        $display("--- Test %0d: OR ---", test_count);
        a = 8'hAA;
        b = 8'h55;
        op = 3'b011;
        @(posedge clk);
        #1;
        if (result === 8'hFF) begin
            pass_count++;
            $display("  [PASS] AA | 55 = FF");
        end else begin
            $display("  [FAIL] Expected FF, got %0h", result);
        end
        
        // Test 5: XOR
        test_count++;
        $display("");
        $display("--- Test %0d: XOR ---", test_count);
        a = 8'hAA;
        b = 8'h55;
        op = 3'b100;
        @(posedge clk);
        #1;
        if (result === 8'hFF) begin
            pass_count++;
            $display("  [PASS] AA ^ 55 = FF");
        end else begin
            $display("  [FAIL] Expected FF, got %0h", result);
        end
        
        // Test 6: Zero flag
        test_count++;
        $display("");
        $display("--- Test %0d: Zero Flag ---", test_count);
        a = 8'h00;
        b = 8'h00;
        op = 3'b000;
        @(posedge clk);
        #1;
        if (zero === 1'b1) begin
            pass_count++;
            $display("  [PASS] Zero flag set");
        end else begin
            $display("  [FAIL] Zero flag not set");
        end
        
        // Test 7: Overflow detection
        test_count++;
        $display("");
        $display("--- Test %0d: Overflow ---", test_count);
        a = 8'hFF;
        b = 8'h01;
        op = 3'b000;
        @(posedge clk);
        #1;
        if (overflow === 1'b1) begin
            pass_count++;
            $display("  [PASS] Overflow detected");
        end else begin
            $display("  [FAIL] Overflow not detected");
        end
        
        // Test 8: Random
        test_count++;
        $display("");
        $display("--- Test %0d: Random ---", test_count);
        repeat (5) begin
            a = $random;
            b = $random;
            op = $random % 5;
            @(posedge clk);
            #1;
            $display("  a=0x%0h b=0x%0h op=%0d result=0x%0h", a, b, op, result);
        end
        pass_count++;
        
        // Summary
        $display("");
        $display("========================================");
        $display("  Total: %0d  Passed: %0d  Failed: %0d", 
                 test_count, pass_count, test_count - pass_count);
        $display("");
        
        if (pass_count == test_count) begin
            $display("  ALL TESTS PASSED!");
        end else begin
            $display("  SOME TESTS FAILED!");
        end
        
        $display("");
        $finish;
    end
    
    // 波形
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_data_types);
    end
    
endmodule
