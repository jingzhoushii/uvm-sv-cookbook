// ============================================================================
// Mini SoC Platform Environment - 工业级可配置环境
// ============================================================================
// 核心：根据配置动态组装组件
// ============================================================================

`include "uvm_macros.svh"
`include "mini_soc_platform_cfg.sv"

class mini_soc_platform_env extends uvm_env;
    `uvm_component_utils(mini_soc_platform_env)
    
    // 配置句柄
    mini_soc_platform_cfg cfg;
    
    // ==================== Agents ====================
    // 这些成员根据配置动态创建
    bus_agent    bus_agt;
    uart_agent   uart_agt;
    dma_agent    dma_agt;
    gpio_agent   gpio_agt;
    
    // ==================== Virtual Sequencer ====================
    soc_virtual_sequencer vseqr;
    
    // ==================== 检查器 ====================
    soc_scoreboard sb;
    soc_coverage_model cov;
    soc_ref_model ref_model;
    reg_checker reg_chk;
    
    // ==================== Analysis ====================
    uvm_analysis_export#(bus_trans) bus_export;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    // ==================== Build Phase: 动态组装 ====================
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(mini_soc_platform_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("CFG", "Cannot get platform configuration")
        
        cfg.print_config();
        
        // ==================== 根据配置创建 Agents ====================
        // Bus Agent (始终存在)
        if (cfg.bus_agent_cfg.enable) begin
            `uvm_info("ENV", "Creating Bus Agent", UVM_LOW)
            bus_agt = bus_agent::type_id::create("bus_agt", this);
        end
        
        // UART Agent
        if (cfg.is_enabled("uart")) begin
            `uvm_info("ENV", "Creating UART Agent", UVM_LOW)
            uart_agt = uart_agent::type_id::create("uart_agt", this);
        end
        
        // DMA Agent
        if (cfg.is_enabled("dma")) begin
            `uvm_info("ENV", "Creating DMA Agent", UVM_LOW)
            dma_agt = dma_agent::type_id::create("dma_agt", this);
        end
        
        // GPIO Agent
        if (cfg.is_enabled("gpio")) begin
            `uvm_info("ENV", "Creating GPIO Agent", UVM_LOW)
            gpio_agt = gpio_agent::type_id::create("gpio_agt", this);
        end
        
        // ==================== Virtual Sequencer ====================
        vseqr = soc_virtual_sequencer::type_id::create("vseqr", this);
        
        // ==================== Scoreboard ====================
        if (cfg.enable_scoreboard) begin
            `uvm_info("ENV", "Creating Scoreboard", UVM_LOW)
            sb = soc_scoreboard::type_id::create("sb", this);
        end
        
        // ==================== Coverage ====================
        if (cfg.enable_coverage) begin
            `uvm_info("ENV", "Creating Coverage Model", UVM_LOW)
            cov = soc_coverage_model::type_id::create("cov", this);
        end
        
        // ==================== Reference Model ====================
        if (cfg.enable_ref_model) begin
            `uvm_info("ENV", "Creating Reference Model", UVM_LOW)
            ref_model = soc_ref_model::type_id::create("ref_model", this);
        end
        
        // ==================== Register Checker ====================
        if (cfg.enable_reg_checker) begin
            `uvm_info("ENV", "Creating Register Checker", UVM_LOW)
            reg_chk = reg_checker::type_id::create("reg_chk", this);
        end
    endfunction
    
    // ==================== Connect Phase: 动态连接 ====================
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // ==================== 连接 Virtual Sequencer ====================
        if (cfg.bus_agent_cfg.enable)
            vseqr.bus_seqr = bus_agt.seqr;
        
        if (cfg.is_enabled("uart"))
            vseqr.uart_seqr = uart_agt.seqr;
        
        if (cfg.is_enabled("dma"))
            vseqr.dma_seqr = dma_agt.seqr;
        
        if (cfg.is_enabled("gpio"))
            vseqr.gpio_seqr = gpio_agt.seqr;
        
        // ==================== 连接 Scoreboard ====================
        if (cfg.enable_scoreboard && cfg.bus_agent_cfg.enable) begin
            bus_agt.mon.ap.connect(sb.bus_in);
            if (cfg.enable_ref_model)
                ref_model.bus_ap.connect(sb.ref_export);
        end
        
        // ==================== 连接 Coverage ====================
        if (cfg.enable_coverage && cfg.bus_agent_cfg.enable) begin
            bus_agt.mon.ap.connect(cov.analysis_export);
        end
        
        // ==================== 连接 Reference Model ====================
        if (cfg.enable_ref_model && cfg.bus_agent_cfg.enable) begin
            bus_agt.mon.ap.connect(ref_model.bus_ap);
        end
    endfunction
    
    // ==================== Run Phase ====================
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        // 超时监控
        fork
            begin
                #(cfg.max_simulation_time * 1ns);
                `uvm_warning("TIMEOUT", "Maximum simulation time reached")
                phase.drop_objection(this);
            end
        join_none
        
        wait(phase.get_objection_count() == 0);
        phase.drop_objection(this);
    endtask
    
    // ==================== Report Phase ====================
    virtual function void report_phase(uvm_phase phase);
        `uvm_info("ENV_REPORT", "========== Platform Report ==========", UVM_LOW)
        
        if (cfg.enable_scoreboard) begin
            `uvm_info("ENV_REPORT", "Scoreboard: Enabled", UVM_LOW)
        end
        
        if (cfg.enable_coverage) begin
            `uvm_info("ENV_REPORT", "Coverage: Enabled", UVM_LOW)
        end
        
        if (cfg.enable_ref_model) begin
            `uvm_info("ENV_REPORT", "Reference Model: Enabled", UVM_LOW)
        end
        
        `uvm_info("ENV_REPORT", "========== Platform Complete ==========", UVM_LOW)
    endfunction
endclass

endmodule
