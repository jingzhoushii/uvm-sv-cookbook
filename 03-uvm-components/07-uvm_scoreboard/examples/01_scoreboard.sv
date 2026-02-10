// ============================================================================
// @file    : 01_scoreboard.sv
// @brief   : Scoreboard 演示
// @note    : 展示参考模型比较机制
// ============================================================================

`timescale 1ns/1ps

class txn extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;
    `uvm_object_utils_begin(txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

// Scoreboard
class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    
    // 接收实际结果 (DUT 输出)
    uvm_analysis_imp#(txn, my_scoreboard) act_imp;
    // 接收期望结果 (参考模型)
    uvm_analysis_imp#(txn, my_scoreboard) exp_imp;
    
    // 期望值队列
    txn expected_q[$];
    
    int pass_count;
    int fail_count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        act_imp = new("act_imp", this);
        exp_imp = new("exp_imp", this);
    endfunction
    
    // 接收 DUT 输出
    virtual function void write(txn tr);
        $display("[%0t] [SB] Received actual: addr=0x%0h data=0x%0h", 
                 $time, tr.addr, tr.data);
        
        if (expected_q.size() > 0) begin
            txn exp_tr;
            exp_tr = expected_q.pop_front();
            
            // 比较
            if (exp_tr.compare(tr)) begin
                pass_count++;
                `uvm_info("SB", "PASS: Match!", UVM_LOW)
            end else begin
                fail_count++;
                `uvm_error("SB", $sformatf(
                    "FAIL: exp addr=0x%0h data=0x%0h, got addr=0x%0h data=0x%0h",
                    exp_tr.addr, exp_tr.data, tr.addr, tr.data))
            end
        end else begin
            `uvm_warning("SB", "Unexpected transaction")
        end
    endfunction
    
    // 接收参考模型输出
    virtual function void write_exp(txn tr);
        $display("[%0t] [SB] Received expected: addr=0x%0h data=0x%0h", 
                 $time, tr.addr, tr.data);
        expected_q.push_back(tr);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SB_REPORT", 
            $sformatf("PASS=%0d FAIL=%0d", pass_count, fail_count), 
            UVM_LOW)
    endtask
endclass

// 参考模型
class ref_model extends uvm_component;
    `uvm_component_utils(ref_model)
    uvm_analysis_port#(txn) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        repeat (5) begin
            txn tr;
            tr = txn::type_id::create("tr");
            void'(tr.randomize() with { addr < 50; });
            #20;
            tr.data = tr.addr + 1;  // 简单模型
            $display("[%0t] [REF] Output: addr=0x%0h data=0x%0h", 
                     $time, tr.addr, tr.data);
            ap.write(tr);
        end
        
        phase.drop_objection(this);
    endtask
endclass

module tb_scoreboard;
    
    initial begin
        $display("========================================");
        $display("  Scoreboard Demo");
        $display("========================================");
        
        my_scoreboard sb;
        ref_model refm;
        
        sb = my_scoreboard::type_id::create("sb", null);
        refm = ref_model::type_id::create("refm", null);
        
        // 连接
        refm.ap.connect(sb.exp_imp);
        
        // 模拟 DUT 输出（连接到 act_imp）
        // 在实际环境中，monitor 会连接这里
        
        #200;
        
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin $dumpfile("dump.vcd"); $dumpvars(0, tb_scoreboard); end
endmodule
