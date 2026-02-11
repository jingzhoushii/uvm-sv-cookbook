// ============================================================================
// Enhanced Mini SoC Environment Configuration
// ============================================================================

`include "uvm_macros.svh"

class mini_soc_env_cfg_enh extends uvm_object;
    rand bit has_bus_agent;
    rand bit has_uart_agent;
    rand bit has_dma_agent;
    
    // Agent IDs
    int bus_agent_id = 0;
    int uart_agent_id = 1;
    int dma_agent_id = 2;
    
    // Timeouts
    int run_timeout = 100000;  // 100ms
    int idle_timeout = 1000;
    
    // Scoreboard 配置
    bit enable_scoreboard = 1;
    bit enable_coverage = 1;
    
    // Virtual Interface 配置
    virtual bus_if  bus_vif;
    virtual uart_if uart_vif;
    virtual dma_if  dma_vif;
    
    `uvm_object_utils_begin(mini_soc_env_cfg_enh)
    `uvm_field_int(has_bus_agent, UVM_ALL_ON)
    `uvm_field_int(has_uart_agent, UVM_ALL_ON)
    `uvm_field_int(has_dma_agent, UVM_ALL_ON)
    `uvm_field_int(run_timeout, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name="cfg");
        super.new(name);
        has_bus_agent = 1;
        has_uart_agent = 1;
        has_dma_agent = 1;
        run_timeout = 100000;
    endfunction
endclass

endmodule
