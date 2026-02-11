// ============================================================================
// Enhanced Mini SoC Environment
// ============================================================================

`include "uvm_macros.svh"
`include "mini_soc_env_cfg_enh.sv"

class mini_soc_env_enh extends uvm_env;
    `uvm_component_utils(mini_soc_env_enh)
    
    mini_soc_env_cfg_enh cfg;
    
    // Agents
    bus_agent    bus_agt;
    uart_agent   uart_agt;
    dma_agent    dma_agt;
    
    // Components
    soc_scoreboard_enh sb;
    soc_coverage cov;
    soc_virtual_sequencer_enh vseqr;
    
    // Virtual Interface
    virtual bus_if  bus_vif;
    virtual uart_if uart_vif;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(mini_soc_env_cfg_enh)::get(this, "", "cfg", cfg))
            `uvm_fatal("CFG", "Cannot get config")
        
        // 设置虚拟接口
        uvm_config_db#(virtual bus_if)::set(this, "*bus*", "vif", bus_vif);
        uvm_config_db#(virtual uart_if)::set(this, "*uart*", "vif", uart_vif);
        
        // 创建 Agents
        if (cfg.has_bus_agent)
            bus_agt = bus_agent::type_id::create("bus_agt", this);
        if (cfg.has_uart_agent)
            uart_agt = uart_agent::type_id::create("uart_agt", this);
        if (cfg.has_dma_agent)
            dma_agt = dma_agent::type_id::create("dma_agt", this);
        
        // 创建组件
        if (cfg.enable_scoreboard)
            sb = soc_scoreboard_enh::type_id::create("sb", this);
        
        if (cfg.enable_coverage)
            cov = soc_coverage::type_id::create("cov", this);
        
        vseqr = soc_virtual_sequencer_enh::type_id::create("vseqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 连接 Virtual Sequencer
        if (cfg.has_bus_agent)
            vseqr.bus_seqr = bus_agt.seqr;
        if (cfg.has_uart_agent)
            vseqr.uart_seqr = uart_agt.seqr;
        if (cfg.has_dma_agent)
            vseqr.dma_seqr = dma_agt.seqr;
        
        // 连接 Monitor 到 Scoreboard 和 Coverage
        if (cfg.has_bus_agent) begin
            if (cfg.enable_scoreboard)
                bus_agt.mon.ap.connect(sb.bus_export);
            if (cfg.enable_coverage)
                bus_agt.mon.ap.connect(cov.bus_export);
        end
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        // 超时监控
        fork
            begin
                #(cfg.run_timeout * 1ns);
                `uvm_warning("TIMEOUT", "Simulation timeout!")
                phase.drop_objection(this);
            end
        join_none
        
        wait(phase.get_objection_count() == 0);
        
        phase.drop_objection(this);
    endtask
endclass

// Enhanced Scoreboard
class soc_scoreboard_enh extends uvm_scoreboard;
    `uvm_component_utils(soc_scoreboard_enh)
    
    uvm_analysis_export#(bus_trans) bus_export;
    uvm_analysis_export#(uart_trans) uart_export;
    
    bus_trans exp_q[$];
    bus_trans act_q[$];
    
    int passed_count;
    int failed_count;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        bus_export = new("bus_export", this);
        uart_export = new("uart_export", this);
    endfunction
    
    virtual function void write_bus(bus_trans t);
        if (t.is_read) begin
            exp_q.push_back(t);
        end else begin
            act_q.push_back(t);
        end
        compare();
    endfunction
    
    virtual function void compare();
        while (exp_q.size() > 0 && act_q.size() > 0) begin
            bus_trans exp = exp_q.pop_front();
            bus_trans act = act_q.pop_front();
            
            if (exp.addr == act.addr && exp.data == act.data) begin
                passed_count++;
                `uvm_info("SB_PASS", $sformatf("Match: addr=0x%0h", exp.addr), UVM_LOW)
            end else begin
                failed_count++;
                `uvm_error("SB_FAIL", $sformatf("Mismatch: exp=0x%0h act=0x%0h", exp.data, act.data))
            end
        end
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SB_REPORT", $sformatf("Passed: %0d, Failed: %0d", passed_count, failed_count), UVM_LOW)
    endfunction
endclass

// Coverage Model
class soc_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(soc_coverage)
    
    uvm_analysis_export#(bus_trans) bus_export;
    
    covergroup bus_cg;
        addr_cp: coverpoint trans.addr {
            bins low = {[0:'h1000]};
            bins high = {['h1000:$]};
        }
        data_cp: coverpoint trans.data {
            bins zeros = {0};
            bins pattern = {[1:$]};
        }
        rw_cp: coverpoint trans.is_read {
            bins read = {1};
            bins write = {0};
        }
        cross_rw_addr: cross rw_cp, addr_cp;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        bus_cg = new();
    endfunction
    
    virtual function void write(bus_trans t);
        void'(bus_cg.sample());
    endfunction
endclass

// Enhanced Virtual Sequencer
class soc_virtual_sequencer_enh extends uvm_sequencer;
    `uvm_sequencer_utils(soc_virtual_sequencer_enh)
    
    bus_sequencer    bus_seqr;
    uart_sequencer   uart_seqr;
    dma_sequencer    dma_seqr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

endmodule
