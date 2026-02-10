// ============================================================================
// @file    : 01_report_handler.sv
// @brief   : 报告处理演示
// @note    : 展示 UVM 消息机制
// ============================================================================

`timescale 1ns/1ps

class my_component extends uvm_component;
    `uvm_component_utils(my_component)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        // 各种消息
        `uvm_info("INFO", "This is an info message", UVM_LOW)
        `uvm_info("INFO", "Medium priority info", UVM_MEDIUM)
        `uvm_warning("WARN", "This is a warning")
        `uvm_error("ERR", "This is an error message")
        
        // 条件消息
        if ($urandom_range(100) > 50) begin
            `uvm_info("RANDOM", "Condition met", UVM_LOW)
        end
        
        phase.drop_objection(this);
    endtask
endclass

module tb_report_handler;
    initial begin
        $display("========================================");
        $display("  Report Handler Demo");
        $display("========================================");
        
        my_component comp;
        comp = new("comp", null);
        
        #100;
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_report_handler); end
endmodule
