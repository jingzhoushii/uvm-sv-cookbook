// ============================================================================
// Industrial Scoreboard
// ============================================================================

`timescale 1ns/1ps

class trans extends uvm_sequence_item;
    rand bit [31:0] addr, data;
    int trans_id;
    `uvm_object_utils_begin(trans)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

class ref_model extends uvm_component;
    `uvm_component_utils(ref_model)
    uvm_analysis_export#(trans) in;
    uvm_analysis_port#(trans) out;
    virtual function void build_phase(uvm_phase phase);
        in = new("in", this);
        out = new("out", this);
    endfunction
    virtual function void write(trans t);
        trans o = trans::type_id::create("o");
        o.copy(t);
        if(t.is_read) o.data = t.addr + 'h100;
        out.write(o);
    endfunction
endclass

class sb extends uvm_scoreboard;
    `uvm_component_utils(sb)
    trans exp_q[$], act_q[$];
    bit passed = 1;
    uvm_analysis_export#(trans) exp, act;
    virtual function void build_phase(uvm_phase phase);
        exp = new("exp", this);
        act = new("act", this);
    endfunction
    virtual function void write_exp(trans t);
        exp_q.push_back(t);
    endfunction
    virtual function void write_act(trans t);
        act_q.push_back(t);
        if(exp_q.size()>0 && act_q.size()>0) begin
            trans e = exp_q.pop_front();
            trans a = act_q.pop_front();
            if(e.addr!=a.addr || e.data!=a.data) begin
                `uvm_error("MISM", "Data mismatch")
                passed=0;
            end
        end
    endfunction
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SB", passed?"PASS":"FAIL", UVM_LOW)
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)
    ref_model ref;
    sb score;
    virtual function void build_phase(uvm_phase phase);
        ref = ref_model::type_id::create("ref", this);
        sb = scoreboard::type_id::create("sb", this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        ref.out.connect(sb.exp);
    endfunction
endclass

module tb_ind_sb;
    initial begin
        $display("Industrial Scoreboard");
        run_test();
        #1000; $finish;
    end
endmodule
