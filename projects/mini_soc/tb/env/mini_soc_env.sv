// ============================================================================
// Mini SoC Environment
// ============================================================================

`include "uvm_macros.svh"
`include "mini_soc_env_cfg.sv"

class mini_soc_env extends uvm_env;
    `uvm_component_utils(mini_soc_env)
    
    mini_soc_env_cfg cfg;
    
    bus_agent    bus_agt;
    uart_agent   uart_agt;
    dma_agent    dma_agt;
    
    soc_scoreboard sb;
    soc_virtual_sequencer vseqr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(mini_soc_env_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("CFG", "Cannot get config")
        
        // 创建 Agents
        if (cfg.has_bus_agent) begin
            bus_agt = bus_agent::type_id::create("bus_agt", this);
        end
        if (cfg.has_uart_agent) begin
            uart_agt = uart_agent::type_id::create("uart_agt", this);
        end
        if (cfg.has_dma_agent) begin
            dma_agt = dma_agent::type_id::create("dma_agt", this);
        end
        
        // 创建 Scoreboard
        sb = soc_scoreboard::type_id::create("sb", this);
        
        // 创建 Virtual Sequencer
        vseqr = soc_virtual_sequencer::type_id::create("vseqr", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 连接 Agents 到 Virtual Sequencer
        if (cfg.has_bus_agent)
            vseqr.bus_seqr = bus_agt.seqr;
        if (cfg.has_uart_agent)
            vseqr.uart_seqr = uart_agt.seqr;
        if (cfg.has_dma_agent)
            vseqr.dma_seqr = dma_agt.seqr;
        
        // 连接 Monitor 到 Scoreboard
        if (cfg.has_bus_agent)
            bus_agt.mon.ap.connect(sb.bus_export);
    endfunction
endclass

// Scoreboard
class soc_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(soc_scoreboard)
    
    uvm_analysis_export#(bus_trans) bus_export;
    
    bit test_passed = 1;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        bus_export = new("bus_export", this);
    endfunction
    
    virtual function void write(bus_trans t);
        // 简化的 Scoreboard 检查
        if (t.is_read && t.data === 32'bx) begin
            `uvm_error("SB", "Read data invalid")
            test_passed = 0;
        end
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        if (test_passed)
            `uvm_info("SB", "TEST PASSED", UVM_LOW)
        else
            `uvm_error("SB", "TEST FAILED")
    endfunction
endclass

// Virtual Sequencer
class soc_virtual_sequencer extends uvm_sequencer;
    `uvm_sequencer_utils(soc_virtual_sequencer)
    
    bus_sequencer    bus_seqr;
    uart_sequencer   uart_seqr;
    dma_sequencer    dma_seqr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

endmodule
