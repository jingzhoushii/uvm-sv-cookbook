// ============================================================================
// Hierarchical Coverage Model - 分层覆盖率模型
// ============================================================================
// Transaction Coverage → Scenario Coverage → System Cross Coverage
// ============================================================================

`include "uvm_macros.svh"

// Transaction Coverage Group
class trans_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(trans_coverage)
    
    covergroup cg;
        ADDR: coverpoint trans.addr {
            bins KB_0_4 = {[0:'h1000]};
            bins KB_4_16 = {['h1000:'h4000]};
            bins MB_16 = {['h4000:$]};
        }
        DATA: coverpoint trans.data {
            bins ZERO = {0};
            bins MAX = {'hFFFFFFFF};
            bins RAND = default;
        }
        RW: coverpoint trans.is_read {
            bins READ = {1};
            bins WRITE = {0};
        }
        ADDR_RW: cross ADDR, RW;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(cg.sample());
    endfunction
    
    virtual function real get_coverage();
        return cg.get_inst_coverage();
    endfunction
endclass

// Scenario Coverage Group
class scenario_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(scenario_coverage)
    
    covergroup cg;
        // 场景覆盖率
        SCENARIO: coverpoint trans.is_read {
            bins SEQUENTIAL = {1};
            bins RANDOM = {0};
        }
        TIMING: coverpoint trans.delay {
            bins FAST = {[0:5]};
            bins NORMAL = {[6:50]};
            bins SLOW = {[51:$]};
        }
        SCEN_TIMING: cross SCENARIO, TIMING;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(cg.sample());
    endfunction
endclass

// System Cross Coverage Group
class system_cross_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(system_cross_coverage)
    
    covergroup cg;
        // 系统级交叉覆盖
        ADDR_MODE: coverpoint trans.hsize {
            bins BYTE = {0};
            bins HALF = {1};
            bins WORD = {2};
        }
        ADDR_BURST: coverpoint trans.hburst {
            bins SINGLE = {0};
            bins INCR = {1};
            bins WRAP = {2};
        }
        CROSS_FULL: cross ADDR_MODE, ADDR_BURST;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(cg.sample());
    endfunction
endclass

// Main Coverage Collector
class soc_coverage分层 extends uvm_component;
    `uvm_component_utils(soc_coverage分层)
    
    // Coverage Groups
    trans_coverage       trans_cov;
    scenario_coverage    scen_cov;
    system_cross_coverage sys_cov;
    
    // Analysis Exports
    uvm_analysis_export#(bus_trans) trans_in;
    uvm_analysis_export#(bus_trans) scen_in;
    uvm_analysis_export#(bus_trans) sys_in;
    
    // Goals
    real trans_goal = 80.0;
    real scen_goal = 60.0;
    real sys_goal = 75.0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans_cov = trans_coverage::type_id::create("trans_cov", this);
        scen_cov = scenario_coverage::type_id::create("scen_cov", this);
        sys_cov = system_cross_coverage::type_id::create("sys_cov", this);
        
        trans_in = new("trans_in", this);
        scen_in = new("scen_in", this);
        sys_in = new("sys_in", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        trans_in.connect(trans_cov.analysis_export);
        scen_in.connect(scen_cov.analysis_export);
        sys_in.connect(sys_cov.analysis_export);
    endfunction
    
    virtual function void write(bus_trans t);
        trans_cov.write(t);
        scen_cov.write(t);
        sys_cov.write(t);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        real trans_cg = trans_cov.get_coverage();
        real scen_cg = scen_cov.get_coverage();
        real sys_cg = sys_cov.get_coverage();
        real overall = (trans_cg + scen_cg + sys_cg) / 3;
        
        `uvm_info("COV_REPORT", "========== Coverage Report ==========", UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("Transaction: %0.1f%% (Goal: %0.0f%%)", trans_cg, trans_goal), UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("Scenario: %0.1f%% (Goal: %0.0f%%)", scen_cg, scen_goal), UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("System: %0.1f%% (Goal: %0.0f%%)", sys_cg, sys_goal), UVM_LOW)
        `uvm_info("COV_REPORT", $sformatf("Overall: %0.1f%%", overall), UVM_LOW)
        
        if (overall >= (trans_goal + scen_goal + sys_goal) / 3) begin
            `uvm_info("COV_PASS", "Coverage goals met!", UVM_LOW)
        end else begin
            `uvm_warning("COV_FAIL", "Coverage goals NOT met")
        end
    endfunction
endclass

endmodule
