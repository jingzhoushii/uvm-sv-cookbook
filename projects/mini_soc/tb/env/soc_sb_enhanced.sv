// ============================================================================
// Enhanced Scoreboard - 工业级计分板
// ============================================================================
// 支持: queue-based, ID-based, out-of-order matching
// ============================================================================

`include "uvm_macros.svh"

class soc_sb_enhanced extends uvm_scoreboard;
    `uvm_component_utils(soc_sb_enhanced)
    
    // ==================== Analysis Exports ====================
    uvm_analysis_export#(bus_trans) bus_expected;
    uvm_analysis_export#(bus_trans) bus_actual;
    uvm_analysis_export#(bus_trans) bus_injected;
    
    // ==================== Matching Queues ====================
    // Queue-based matching
    bus_trans expected_q[$];
    bus_trans actual_q[$];
    
    // ID-based matching (for out-of-order)
    bus_trans id_map[integer];
    
    // ==================== Statistics ====================
    int total_txs = 0;
    int matched = 0;
    int mismatched = 0;
    int pending = 0;
    int out_of_order = 0;
    
    // ==================== Configuration ====================
    typedef enum {QUEUE_BASED, ID_BASED} match_mode_t;
    match_mode_t match_mode = QUEUE_BASED;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        bus_expected = new("bus_expected", this);
        bus_actual = new("bus_actual", this);
        bus_injected = new("bus_injected", this);
    endfunction
    
    // ==================== Write Functions ====================
    virtual function void write_expected(bus_trans t);
        expected_q.push_back(t);
        if (match_mode == ID_BASED)
            id_map[t.trans_id] = t;
        total_txs++;
        compare();
    endfunction
    
    virtual function void write_actual(bus_trans t);
        actual_q.push_back(t);
        if (match_mode == ID_BASED)
            id_map[t.trans_id] = t;
        compare();
    endfunction
    
    virtual function void write_injected(bus_trans t);
        bus_injected.write(t);
    endfunction
    
    // ==================== Matching Logic ====================
    virtual function void compare();
        if (match_mode == QUEUE_BASED) begin
            while (expected_q.size() > 0 && actual_q.size() > 0) begin
                bus_trans exp = expected_q.pop_front();
                bus_trans act = actual_q.pop_front();
                do_compare(exp, act);
            end
        end else begin
            foreach (id_map[id]) begin
                if (id_map.exists(id)) begin
                    bus_trans exp = id_map[id];
                    if (actual_q.size() > 0) begin
                        foreach (actual_q[i]) begin
                            if (actual_q[i].trans_id == id) begin
                                bus_trans act = actual_q[i];
                                actual_q.delete(i);
                                do_compare(exp, act);
                                break;
                            end
                        end
                    end
                end
            end
        end
    endfunction
    
    virtual function void do_compare(bus_trans exp, bus_trans act);
        if (exp.addr == act.addr && exp.data == act.data) begin
            matched++;
            `uvm_info("SB_PASS", $sformatf("Match: addr=0x%0h", exp.addr), UVM_LOW)
        end else begin
            mismatched++;
            `uvm_error("SB_FAIL", 
                $sformatf("Mismatch: exp_addr=0x%0h act_addr=0x%0h exp_data=0x%0h act_data=0x%0h",
                    exp.addr, act.addr, exp.data, act.data))
        end
    endfunction
    
    // ==================== Report ====================
    virtual function void report_phase(uvm_phase phase);
        real pass_rate = (total_txs > 0) ? (real'(matched) / total_txs * 100) : 0;
        
        `uvm_info("SB_REPORT", "========== Scoreboard Report ==========", UVM_LOW)
        `uvm_info("SB_REPORT", $sformatf("Total: %0d, Matched: %0d, Mismatched: %0d", 
            total_txs, matched, mismatched), UVM_LOW)
        `uvm_info("SB_REPORT", $sformatf("Pass Rate: %0.1f%%", pass_rate), UVM_LOW)
        
        if (mismatched > 0) begin
            `uvm_error("SB_FINAL", "Scoreboard FAILED!")
        end else begin
            `uvm_info("SB_FINAL", "Scoreboard PASSED!", UVM_LOW)
        end
    endfunction
endclass

endmodule
