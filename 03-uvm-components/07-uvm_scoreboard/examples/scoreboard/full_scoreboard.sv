// ============================================================================
// Full Scoreboard with TLM
// ============================================================================
`timescale 1ns/1ps

class full_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(full_scoreboard)
    uvm_analysis_imp#(sb_txn, full_scoreboard) exp_imp;
    uvm_analysis_imp#(sb_txn, full_scoreboard) act_imp;
    sb_txn exp_q[$], act_q[$];
    int pass, fail;
    
    function new(string n, uvm_component p);
        super.new(n,p);
        exp_imp = new("exp_imp", this);
        act_imp = new("act_imp", this);
        pass=fail=0;
    endfunction
    
    virtual function void write_exp(sb_txn tr);
        exp_q.push_back(tr);
    endfunction
    
    virtual function void write_act(sb_txn tr);
        act_q.push_back(tr);
        if (exp_q.size()>0) begin
            sb_txn e; e = exp_q.pop_front();
            if (e.compare(tr)) begin pass++; `uvm_info("SB","PASS",UVM_LOW) end
            else begin fail++; `uvm_error("SB","MISMATCH") end
        end
    endfunction
    
    virtual function void report_phase(uvm_phase p);
        super.report_phase(p);
        `uvm_info("SB_REPORT",$sformatf("PASS=%0d FAIL=%0d",pass,fail),UVM_LOW)
    endfunction
endclass

module tb_sb;
    initial begin full_scoreboard sb; sb=new("sb",null); #100; $finish; end
    initial begin $dumpfile("dump.vcd"); $dumpvars(0,tb_sb); end
endmodule
