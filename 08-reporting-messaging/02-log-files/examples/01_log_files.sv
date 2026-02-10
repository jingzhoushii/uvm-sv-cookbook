// ============================================================================
// @file    : 01_log_files.sv
// @brief   : 日志文件演示
// @note    : 展示文件记录配置
// ============================================================================

`timescale 1ns/1ps

class logging_demo extends uvm_component;
    `uvm_component_utils(logging_demo)
    
    int log_file;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 打开日志文件
        log_file = $fopen("simulation.log");
        
        // 配置报告 Verbosity
        set_report_verbosity_level(UVM_MEDIUM);
        
        // 配置文件记录
        set_report_file_object(log_file);
        
        // 启用所有消息
        set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_LOG);
        set_report_severity_action(UVM_WARNING, UVM_DISPLAY | UVM_LOG);
        set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG | UVM_COUNT);
        set_report_severity_action(UVM_FATAL, UVM_DISPLAY | UVM_LOG | UVM_EXIT);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        `uvm_info("LOG", "Starting simulation", UVM_LOW)
        `uvm_info("LOG", "Logging to file", UVM_MEDIUM)
        `uvm_warning("LOG", "This warning goes to file")
        
        #50;
        
        `uvm_info("LOG", "Simulation complete", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
    
    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        $fclose(log_file);
    endtask
endclass

module tb_log_files;
    initial begin
        $display("========================================");
        $display("  Log Files Demo");
        $display("========================================");
        
        logging_demo demo;
        demo = new("demo", null);
        
        #100;
        $display("========================================");
        $display("  Demo Complete! Check simulation.log");
        $display("========================================");
        $finish;
    end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_log_files); end
endmodule
