// ============================================================================
// Base Test
// ============================================================================

`include "uvm_macros.svh"
`include "mini_soc_env.sv"

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    mini_soc_env env;
    mini_soc_env_cfg env_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // 创建配置
        env_cfg = mini_soc_env_cfg::type_id::create("env_cfg");
        uvm_config_db#(mini_soc_env_cfg)::set(this, "*", "cfg", env_cfg);
        
        // 创建 Environment
        env = mini_soc_env::type_id::create("env", this);
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        print();
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #1000;
        phase.drop_objection(this);
    endtask
endclass

endmodule
