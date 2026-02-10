// ============================================================================
// @file    : 01_phases.sv
// @author  : jingzhoushii
// @date    : 2026-02-10
// @version : v1.0
// @brief   : UVM Phases 完整演示
// @note    : 展示所有 UVM 阶段的执行顺序和 objection 机制
// ============================================================================
//
// 功能说明：
//   本示例演示 UVM 中所有标准阶段的执行顺序，包括：
//   - build_phase: 构建组件
//   - connect_phase: 连接组件
//   - end_of_elaboration_phase: elaboration 完成前
//   - run_phase: 主运行阶段（含 objection）
//   - report_phase: 报告结果
//   - final_phase: 结束阶段
//
// 关键概念：
//   1. objection 机制：控制 run_phase 何时结束
//   2. 阶段顺序：按 build → connect → run → report → final 执行
//   3. 组件层次：子组件的阶段先于父组件执行
//
// 使用方法：
//   编译：make compile SIM=vcs
//   运行：make run SIM=vcs
//   清理：make clean
//
// Change Log:
//   v1.0 - 初始版本
// ============================================================================

`timescale 1ns/1ps

// ----------------------------------------------------------------------------
// 1. 环境类定义
// ----------------------------------------------------------------------------
class my_env extends uvm_env;
    
    // 注册到 UVM 工厂
    `uvm_component_utils(my_env)
    
    // 子组件
    my_agent    agent;
    my_scoreboard sb;
    
    // 构造函数
    // @param name  : 实例名称
    // @param parent: 父组件（null 表示顶层）
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s new()", $time, name), UVM_LOW)
    endfunction
    
    // ------------------------------------------------------------------------
    // build_phase: 构建组件和子组件
    // ------------------------------------------------------------------------
    // 执行时机：在 connect_phase 之前
    // 主要任务：
    //   - 创建子组件实例
    //   - 从 config_db 获取配置
    //   - 创建 TLM 连接（建议在 connect_phase）
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s build_phase()", $time, get_full_name()), 
            UVM_LOW)
        
        // 创建子组件（通过工厂机制）
        agent = my_agent::type_id::create("agent", this);
        sb = my_scoreboard::type_id::create("sb", this);
    endfunction
    
    // ------------------------------------------------------------------------
    // connect_phase: 连接组件
    // ------------------------------------------------------------------------
    // 执行时机：在 build_phase 之后，run_phase 之前
    // 主要任务：
    //   - 建立 TLM 连接（port-export）
    //   - 连接 analysis port
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s connect_phase()", $time, get_full_name()), 
            UVM_LOW)
        
        // 示例：连接 agent 的 monitor 到 scoreboard
        // agent.mon.ap.connect(sb.analysis_export);
    endfunction
    
    // ------------------------------------------------------------------------
    // end_of_elaboration_phase: Elaboration 完成前
    // ------------------------------------------------------------------------
    // 执行时机：所有 build/connect 完成后
    // 主要任务：
    //   - 打印拓扑结构
    //   - 检查配置
    //   - 修改组件参数
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s end_of_elaboration_phase()", 
            $time, get_full_name()), UVM_LOW)
        
        // 打印组件层次结构
        printTopology();
    endfunction
    
    // ------------------------------------------------------------------------
    // run_phase: 主运行阶段
    // ------------------------------------------------------------------------
    // 执行时机：验证的主要执行阶段
    // 主要任务：
    //   - 启动序列
    //   - 运行测试
    // 注意：
    //   - 必须 raise_objection 防止提前结束
    //   - 完成所有任务后 drop_objection
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase() - Starting", 
            $time, get_full_name()), UVM_LOW)
        
        // 【关键】raise objection - 阻止仿真提前结束
        phase.raise_objection(this);
        
        // 执行主要验证任务
        // 示例：等待 50 个时钟周期
        repeat (10) @(posedge agent.clk);
        
        // 【关键】drop objection - 允许仿真结束
        phase.drop_objectation(this);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase() - Finished", 
            $time, get_full_name()), UVM_LOW)
    endtask
    
    // ------------------------------------------------------------------------
    // report_phase: 报告结果
    // ------------------------------------------------------------------------
    // 执行时机：在 run_phase 完成后
    // 主要任务：
    //   - 打印测试结果
    //   - 生成报告
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s report_phase()", $time, get_full_name()), 
            UVM_LOW)
        
        // 示例：检查测试通过/失败
        // if (sb.get_error_count() == 0) begin
        //     `uvm_info("TEST", "All tests passed!", UVM_LOW)
        // end
    endfunction
    
    // ------------------------------------------------------------------------
    // final_phase: 结束阶段
    // ------------------------------------------------------------------------
    // 执行时机：仿真结束前
    // 主要任务：
    //   - 清理资源
    //   - 关闭文件
    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s final_phase()", $time, get_full_name()), 
            UVM_LOW)
    endfunction
    
endclass : my_env

// ----------------------------------------------------------------------------
// 2. Agent 类（简化版）
// ----------------------------------------------------------------------------
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    reg clk;
    uvm_sequencer#(uvm_sequence_item) sequencer;
    my_driver driver;
    my_monitor monitor;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        clk = 0;
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s build_phase()", $time, get_full_name()), 
            UVM_LOW)
        
        // 创建子组件
        sequencer = uvm_sequencer#(uvm_sequence_item)::type_id::create(
            "sequencer", this);
        driver = my_driver::type_id::create("driver", this);
        monitor = my_monitor::type_id::create("monitor", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s connect_phase()", $time, get_full_name()), 
            UVM_LOW)
        
        // 连接 driver 到 sequencer
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endtask
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase()", $time, get_full_name()), 
            UVM_LOW)
        phase.raise_objection(this);
        
        // 时钟生成
        forever #5 clk = ~clk;
        
        phase.drop_objection(this);
    endtask
    
endclass

// ------------------------------------------------------------------------
// 3. Driver 类
// ------------------------------------------------------------------------
class my_driver extends uvm_driver#(uvm_sequence_item);
    `uvm_component_utils(my_driver)
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase()", $time, get_full_name()), 
            UVM_LOW)
        phase.raise_objection(this);
        
        // 驱动逻辑
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), 
                $sformatf("Driving item: %s", req.sprint()), UVM_LOW)
            seq_item_port.item_done();
        end
        
        phase.drop_objection(this);
    endtask
endclass

// ------------------------------------------------------------------------
// 4. Monitor 类
// ------------------------------------------------------------------------
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)
    
    uvm_analysis_port#(uvm_sequence_item) ap;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase()", $time, get_full_name()), 
            UVM_LOW)
        phase.raise_objection(this);
        
        // 监控逻辑
        forever begin
            // 采样总线数据
            // ap.write(req);
        end
        
        phase.drop_objection(this);
    endtask
endclass

// ------------------------------------------------------------------------
// 5. Scoreboard 类
// ------------------------------------------------------------------------
class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    
    uvm_analysis_export#(uvm_sequence_item) analysis_export;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s build_phase()", $time, get_full_name()), 
            UVM_LOW)
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), 
            $sformatf("[%0t] %s run_phase()", $time, get_full_name()), 
            UVM_LOW)
        phase.raise_objection(this);
        
        // 检查逻辑
        forever begin
            // 从 analysis_export 获取数据
            // compare();
        end
        
        phase.drop_objection(this);
    endtask
endclass

// ----------------------------------------------------------------------------
// 6. Testbench 顶层模块
// ----------------------------------------------------------------------------
module tb_phases;
    
    // 创建环境实例
    my_env env;
    
    initial begin
        $display("========================================");
        $display("  UVM Phases Demo");
        $display("  Simulator: $simulator");
        $display("========================================");
        $display("");
        
        // 创建并运行环境
        env = my_env::type_id::create("env", null);
        
        // 等待仿真完成
        #500;
        
        $display("");
        $display("========================================");
        $display("  Phases Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    // 波形生成
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_phases);
    end
    
endmodule : tb_phases

// ============================================================================
//  vim: set et ts=4 sw=4:
// ============================================================================
