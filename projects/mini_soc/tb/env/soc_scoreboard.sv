// ============================================================================
// Complete Scoreboard - 完整计分板
// ============================================================================

`include "uvm_macros.svh"

class soc_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(soc_scoreboard)
    
    // Analysis Exports
    uvm_analysis_export#(bus_trans) bus_in;
    uvm_analysis_export#(bus_trans) bus_out;
    uvm_analysis_export#(uart_trans) uart_in;
    uvm_analysis_export#(dma_trans) dma_in;
    
    // Queues
    bus_trans bus_exp_q[$];
    bus_trans bus_act_q[$];
    uart_trans uart_q[$];
    dma_trans dma_q[$];
    
    // Statistics
    int total_txs = 0;
    int passed = 0;
    int failed = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        bus_in = new("bus_in", this);
        bus_out = new("bus_out", this);
        uart_in = new("uart_in", this);
        dma_in = new("dma_in", this);
    endfunction
    
    virtual function void write_bus_in(bus_trans t);
        bus_exp_q.push_back(t);
        total_txs++;
        compare();
    endfunction
    
    virtual function void write_bus_out(bus_trans t);
        bus_act_q.push_back(t);
        compare();
    endfunction
    
    virtual function void write_uart_in(uart_trans t);
        uart_q.push_back(t);
    endfunction
    
    virtual function void write_dma_in(dma_trans t);
        dma_q.push_back(t);
    endfunction
    
    virtual function void compare();
        while (bus_exp_q.size() > 0 && bus_act_q.size() > 0) begin
            bus_trans exp = bus_exp_q.pop_front();
            bus_trans act = bus_act_q.pop_front();
            
            if (exp.addr == act.addr && exp.data == act.data) begin
                passed++;
                `uvm_info("SB_PASS", $sformatf("Match: addr=0x%0h", exp.addr), UVM_LOW)
            end else begin
                failed++;
                `uvm_error("SB_FAIL", 
                    $sformatf("Mismatch: exp=0x%0h act=0x%0h", exp.data, act.data))
            end
        end
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        real pass_rate = (total_txs > 0) ? (real'(passed) / total_txs * 100) : 0;
        
        `uvm_info("SB_REPORT", 
            $sformatf("Total: %0d, Passed: %0d, Failed: %0d, Rate: %0.1f%%",
                total_txs, passed, failed, pass_rate), UVM_LOW)
        
        if (failed > 0)
            `uvm_error("SB_FINAL", "Scoreboard FAILED!")
        else
            `uvm_info("SB_FINAL", "Scoreboard PASSED!", UVM_LOW)
    endfunction
endclass

endmodule
