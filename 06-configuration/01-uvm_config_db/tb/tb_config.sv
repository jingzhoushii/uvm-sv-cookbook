// ============================================================================
// Testbench: tb_config_db
// 功能: 验证 uvm_config_db 配置数据库的使用方法
// 知识点:
//   - uvm_config_db#(T)::set() - 设置配置
//   - uvm_config_db#(T)::get() - 获取配置
//   - 跨层次传递配置信息
// ============================================================================
`timescale 1ns/1ps

module tb_config_db;
    // ------------------------------------------------------------------------
    // 配置对象类
    // ------------------------------------------------------------------------
    class my_config extends uvm_object;
        rand int           addr_width;
        rand int           data_width;
        rand bit           has_error_injection;
        string             test_name;
        
        `uvm_object_utils_begin(my_config)
        `uvm_field_int(addr_width, UVM_ALL_ON)
        `uvm_field_int(data_width, UVM_ALL_ON)
        `uvm_field_int(has_error_injection, UVM_ALL_ON)
        `uvm_field_string(test_name, UVM_ALL_ON)
        `uvm_object_utils_end
        
        function new(string name = "my_config");
            super.new(name);
            addr_width = 32;
            data_width = 64;
            has_error_injection = 0;
            test_name = "default_test";
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 组件：从 config_db 获取配置
    // ------------------------------------------------------------------------
    class my_driver extends uvm_driver;
        `uvm_component_utils(my_driver)
        
        my_config cfg;
        virtual dut_if vif;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // 从 config_db 获取配置对象
            if (!uvm_config_db#(my_config)::get(this, "", "config", cfg)) begin
                `uvm_error("DRV", "Failed to get config from DB")
            end
            `uvm_info("DRV", $sformatf("Config: addr_w=%0d data_w=%0d",
                                       cfg.addr_width, cfg.data_width), UVM_LOW)
        endfunction
        
        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            
            `uvm_info("DRV", "Starting test with config from DB", UVM_LOW)
            
            // 使用配置进行测试
            repeat (5) begin
                #10;
                `uvm_info("DRV", "Driving transaction...", UVM_LOW)
            end
            
            phase.drop_objection(this);
        endtask
    endclass
    
    // ------------------------------------------------------------------------
    // 环境：设置配置到 config_db
    // ------------------------------------------------------------------------
    class my_env extends uvm_env;
        `uvm_component_utils(my_env)
        
        my_driver drv;
        my_config cfg;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            // 创建配置对象
            cfg = my_config::type_id::create("cfg");
            cfg.addr_width = 64;
            cfg.data_width = 128;
            cfg.has_error_injection = 1;
            cfg.test_name = "config_db_demo";
            
            // 将配置设置到 config_db
            uvm_config_db#(my_config)::set(this, "*", "config", cfg);
            `uvm_info("ENV", "Config set to DB", UVM_LOW)
            
            // 创建 driver
            drv = my_driver::type_id::create("drv", this);
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 测试程序
    // ------------------------------------------------------------------------
    initial begin
        my_env env;
        
        $display("========================================");
        $display("  UVM Config DB Demo");
        $display("========================================");
        
        env = my_env::type_id::create("env", null);
        env.build();
        
        run_test();
        
        $display("\nConfig DB testbench Complete!");
    end
    
    // ------------------------------------------------------------------------
    // 波形记录
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_config_db);
    end
    
endmodule
