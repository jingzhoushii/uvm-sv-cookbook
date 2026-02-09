// ============================================================
// File: 03_struct_enum.sv
// Description: 结构体与枚举类型示例
// ============================================================

`timescale 1ns/1ps

module struct_enum_demo;
    
    typedef struct packed {
        bit [7:0]  reg_addr;
        bit [31:0] reg_data;
    } reg_access_t;
    
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        READ  = 2'b01,
        WRITE = 2'b10,
        BUSY  = 2'b11
    } state_t;
    
    reg_access_t reg_access;
    state_t current_state;
    
    initial begin
        $display("========================================");
        $display("  Struct & Enum Demo");
        $display("========================================");
        $display("");
        
        $display("--- 结构体 ---");
        reg_access.reg_addr = 8'h10;
        reg_access.reg_data = 32'hABCD_EF01;
        $display("reg_access = {addr=0x%0h, data=0x%0h}",
                 reg_access.reg_addr, reg_access.reg_data);
        $display("总位数: %0d", $bits(reg_access_t));
        $display("");
        
        $display("--- 枚举 ---");
        current_state = IDLE;
        $display("current_state = %s (0x%0h)", 
                 current_state.name(), current_state);
        
        current_state = READ;
        $display("current_state = %s", current_state.name());
        $display("");
        
        $display("========================================");
        $display("  Struct & Enum Demo Complete!");
        $display("========================================");
        $finish;
    end
    
endmodule
