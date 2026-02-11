// ============================================================================
// Mini SoC UVM Environment - 贯穿式环境
// ============================================================================

`timescale 1ns/1ps

// 配置对象
class mini_env_cfg extends uvm_object;
    rand bit has_ahb;
    rand bit has_gpio;
    rand bit has_timer;
    int  ahb_agent_count = 1;
    
    `uvm_object_utils_begin(mini_env_cfg)
    `uvm_field_int(has_ahb, UVM_ALL_ON)
    `uvm_field_int(has_gpio, UVM_ALL_ON)
    `uvm_field_int(has_timer, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name="mini_env_cfg");
        super.new(name);
    endfunction
endclass

// Mini Environment
class mini_env extends uvm_env;
    `uvm_component_utils(mini_env)
    
    mini_env_cfg cfg;
    
    // Agents
    ahb_agent    ahb_agt;
    gpio_agent   gpio_agt;
    
    // Scoreboard
    scoreboard   sb;
    
    // Coverage
    coverage     cov;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 获取配置
        if (!uvm_config_db#(mini_env_cfg)::get(this, "", "cfg", cfg))
            `uvm_fatal("CFG", "Cannot get config")
        
        // 创建 Agents
        if (cfg.has_ahb) begin
            ahb_agt = ahb_agent::type_id::create("ahb_agt", this);
        end
        if (cfg.has_gpio) begin
            gpio_agt = gpio_agent::type_id::create("gpio_agt", this);
        end
        
        // 创建 Scoreboard
        sb = scoreboard::type_id::create("sb", this);
        
        // 创建 Coverage
        cov = coverage::type_id::create("cov", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // 连接 Monitor 到 Scoreboard
        if (cfg.has_ahb)
            ahb_agt.mon.ap.connect(sb.ahb_export);
        if (cfg.has_gpio)
            gpio_agt.mon.ap.connect(sb.gpio_export);
        
        // 连接 Coverage
        if (cfg.has_ahb)
            ahb_agt.mon.ap.connect(cov.ahb_export);
    endfunction
endclass

// Scoreboard
class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_analysis_export#(ahb_trans) ahb_export;
    uvm_analysis_export#(gpio_trans) gpio_export;
    
    bit test_passed = 1;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        ahb_export = new("ahb_export", this);
        gpio_export = new("gpio_export", this);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        if (test_passed)
            `uvm_info("SB", "TEST PASSED", UVM_LOW)
        else
            `uvm_error("SB", "TEST FAILED")
    endfunction
endclass

// Coverage
class coverage extends uvm_subscriber#(ahb_trans);
    `uvm_component_utils(coverage)
    
    uvm_analysis_export#(ahb_trans) ahb_export;
    
    covergroup cg;
        addr: coverpoint trans.haddr { bins low = {[0:'h100]}; bins high = {['h100:$]}; }
        write: coverpoint trans.hwrite { bins read = {0}; bins write = {1}; }
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    virtual function void write(ahb_trans t);
        // void'(cg.sample());
    endfunction
endclass

endmodule
