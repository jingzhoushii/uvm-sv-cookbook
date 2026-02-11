// ============================================================================
// Mini SoC Platform Configuration - 平台结构驱动型配置
// ============================================================================

`include "uvm_macros.svh"

// 总线配置类型
typedef struct packed {
    int addr_width = 32;
    int data_width = 32;
    int num_masters = 1;
    int num_slaves = 4;
    bit supports_burst = 1;
    bit supports_split = 0;
} bus_cfg_t;

// Agent 配置类型
typedef struct packed {
    bit enable = 1;
    int id = 0;
    bit has_active_driver = 1;
    bit has_monitor = 1;
    int sequencer_depth = 32;
} agent_cfg_t;

// 主配置类
class mini_soc_platform_cfg extends uvm_object;
    `uvm_object_utils(mini_soc_platform_cfg)
    
    // SoC 结构控制
    bit has_uart = 1;
    bit has_dma = 1;
    bit has_timer = 1;
    bit has_gpio = 0;
    int num_dma_channels = 2;
    
    // 总线参数
    bus_cfg_t bus_cfg;
    
    // Agent 配置
    agent_cfg_t bus_agent_cfg;
    agent_cfg_t uart_agent_cfg;
    agent_cfg_t dma_agent_cfg;
    agent_cfg_t gpio_agent_cfg;
    
    // 验证控制
    bit enable_coverage = 1;
    bit enable_scoreboard = 1;
    bit enable_ref_model = 1;
    bit enable_reg_checker = 1;
    
    // 仿真行为
    int boot_timeout = 100000;
    int max_simulation_time = 1000000;
    int stress_level = 1;
    int seed = -1;
    int verbosity = UVM_LOW;
    
    // 子系统模式
    typedef enum {FULL_CHIP, SUBSYSTEM, IP_BLOCK} soc_mode_t;
    soc_mode_t soc_mode = FULL_CHIP;
    
    function new(string name="mini_soc_platform_cfg");
        super.new(name);
        
        // 初始化总线配置
        bus_cfg = '{
            addr_width: 32,
            data_width: 32,
            num_masters: 1,
            num_slaves: 4,
            supports_burst: 1,
            supports_split: 0
        };
        
        // 初始化 Agent 配置
        bus_agent_cfg = '{enable: 1, id: 0, has_active_driver: 1, has_monitor: 1, sequencer_depth: 32};
        uart_agent_cfg = '{enable: 1, id: 1, has_active_driver: 1, has_monitor: 1, sequencer_depth: 16};
        dma_agent_cfg = '{enable: 1, id: 2, has_active_driver: 1, has_monitor: 1, sequencer_depth: 32};
        gpio_agent_cfg = '{enable: 0, id: 3, has_active_driver: 1, has_monitor: 1, sequencer_depth: 16};
    endfunction
    
    function bit is_enabled(string component);
        case (component)
            "uart":  return has_uart;
            "dma":   return has_dma;
            "timer": return has_timer;
            "gpio":  return has_gpio;
            default: return 0;
        endcase
    endfunction
    
    virtual function void print_config();
        `uvm_info("PLATFORM_CFG", "========== Platform Configuration ==========", UVM_LOW)
        `uvm_info("PLATFORM_CFG", $sformatf("Has UART: %0d, DMA: %0d, Timer: %0d", has_uart, has_dma, has_timer), UVM_LOW)
        `uvm_info("PLATFORM_CFG", $sformatf("Coverage: %0d, Scoreboard: %0d, RefModel: %0d", enable_coverage, enable_scoreboard, enable_ref_model), UVM_LOW)
    endfunction
endclass

endmodule
