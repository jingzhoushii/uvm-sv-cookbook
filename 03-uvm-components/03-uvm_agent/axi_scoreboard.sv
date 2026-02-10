// ============================================================================
// @file    : axi_scoreboard.sv
// @brief   : AXI Scoreboard
// @note    : 事务比较
// ============================================================================

`timescale 1ns/1ps

class axi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_scoreboard)
    
    // 分析导入
    uvm_analysis_imp#(axi_transaction, axi_scoreboard) act_imp;
    uvm_analysis_imp#(axi_transaction, axi_scoreboard) exp_imp;
    
    // 期望队列
    axi_transaction  expected_q[$];
    
    // 统计
    int             pass_count;
    int             fail_count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        act_imp = new("act_imp", this);
        exp_imp = new("exp_imp", this);
    endfunction
    
    virtual function void write_exp(axi_transaction tr);
        expected_q.push_back(tr);
        `uvm_info(get_type_name(), 
            $sformatf("Expected: addr=0x%0h", tr.addr), UVM_LOW)
    endfunction
    
    virtual function void write_act(axi_transaction tr);
        if (expected_q.size() > 0) begin
            axi_transaction exp_tr;
            exp_tr = expected_q.pop_front();
            
            if (tr.compare(exp_tr)) begin
                pass_count++;
                `uvm_info("SB_PASS", 
                    $sformatf("Match: addr=0x%0h", tr.addr), UVM_LOW)
            end else begin
                fail_count++;
                `uvm_error("SB_FAIL",
                    $sformatf("Mismatch: exp addr=0x%0h got addr=0x%0h",
                             exp_tr.addr, tr.addr))
            end
        end else begin
            `uvm_warning("SB", "Unexpected transaction")
        end
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SB_REPORT",
            $sformatf("PASS=%0d FAIL=%0d", pass_count, fail_count), 
            UVM_LOW)
    endtask
endclass : axi_scoreboard
