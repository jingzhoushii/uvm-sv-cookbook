// ============================================================================
// Mini SoC Environment Configuration
// ============================================================================

`include "uvm_macros.svh"

class mini_soc_env_cfg extends uvm_object;
    rand bit has_bus_agent;
    rand bit has_uart_agent;
    rand bit has_dma_agent;
    
    int bus_agent_id = 0;
    int uart_agent_id = 1;
    int dma_agent_id = 2;
    
    `uvm_object_utils_begin(mini_soc_env_cfg)
    `uvm_field_int(has_bus_agent, UVM_ALL_ON)
    `uvm_field_int(has_uart_agent, UVM_ALL_ON)
    `uvm_field_int(has_dma_agent, UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new(string name="mini_soc_env_cfg");
        super.new(name);
        has_bus_agent = 1;
        has_uart_agent = 1;
        has_dma_agent = 1;
    endfunction
endclass

endmodule
