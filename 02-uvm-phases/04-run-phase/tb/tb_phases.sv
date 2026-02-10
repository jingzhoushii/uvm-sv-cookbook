// ============================================================================
// Testbench: tb_phases
// 功能: 验证 UVM 各阶段（Phase）的执行顺序和特性
// 知识点:
//   - build_phase: 构建组件层次结构
//   - connect_phase: 建立 TLM 连接
//   - run_phase: 执行测试激励
//   - report_phase: 报告测试结果
//   - final_phase: 清理资源
// ============================================================================
`timescale 1ns/1ps

module tb_phases;
    // ------------------------------------------------------------------------
    // UVM 组件示例
    // ------------------------------------------------------------------------
    class my_driver extends uvm_driver;
        `uvm_component_utils(my_driver)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        // build_phase: 创建子组件，配置属性
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            `uvm_info("DRV", "build_phase", UVM_LOW)
        endfunction
        
        // connect_phase: 建立连接（如 TLM 端口）
        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            `uvm_info("DRV", "connect_phase", UVM_LOW)
        endfunction
        
        // run_phase: 主要工作阶段，产生激励
        virtual task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            `uvm_info("DRV", "run_phase started", UVM_LOW)
            
            #100;
            
            `uvm_info("DRV", "run_phase finished", UVM_LOW)
            phase.drop_objection(this);
        endtask
        
        // report_phase: 报告测试结果
        virtual function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("DRV", "report_phase", UVM_LOW)
        endfunction
        
        // final_phase: 清理
        virtual function void final_phase(uvm_phase phase);
            super.final_phase(phase);
            `uvm_info("DRV", "final_phase", UVM_LOW)
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // UVM 环境
    // ------------------------------------------------------------------------
    class my_env extends uvm_env;
        `uvm_component_utils(my_env)
        
        my_driver drv;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            drv = my_driver::type_id::create("drv", this);
            `uvm_info("ENV", "Created driver", UVM_LOW)
        endfunction
        
        virtual function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("ENV", "Test completed successfully!", UVM_LOW)
        endfunction
    endclass
    
    // ------------------------------------------------------------------------
    // 测试程序
    // ------------------------------------------------------------------------
    initial begin
        my_env env;
        
        $display("========================================");
        $display("  UVM Phases Demo");
        $display("========================================");
        
        // 创建并运行 UVM 环境
        env = my_env::type_id::create("env", null);
        env.build();
        
        // 运行测试
        run_test();
        
        $display("\nPhases testbench Complete!");
    end
    
    // ------------------------------------------------------------------------
    // 波形记录
    // ------------------------------------------------------------------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_phases);
    end
    
endmodule
