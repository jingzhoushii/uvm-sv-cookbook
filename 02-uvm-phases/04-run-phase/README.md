# 04-run-phase - UVM 运行阶段

## 📚 知识点

- `run_phase` 任务型阶段
- `objection` 机制（raise/drop）
- `phase_started` / `phase_ended` 回调
- 主从相（master/slave phases）
- 超时控制

## 📖 背景知识

### 什么是 run_phase？

`run_phase` 是 UVM 中最重要的阶段之一，用于执行验证的主要任务：

1. **任务型阶段（task-based）**：不像函数型阶段，run_phase 是一个任务，可以消耗时间
2. **主从机制**：所有组件的 `run_phase` 会自动并行执行
3. **objection 控制**：通过 `raise_objection` / `drop_objection` 控制何时结束

### objection 机制

```systemverilog
// 组件 A raise objection
phase.raise_objection(this);
// ... 执行任务 ...
phase.drop_objection(this);
```

- **所有组件的 objection 都 drop 后**，run_phase 才会结束
- **任意组件 raise 但未 drop**，仿真不会结束

## 📂 文件结构

```
04-run-phase/
├── README.md              # 本文档
├── Makefile              # 编译脚本
└── examples/
    └── 01_phases.sv      # 完整示例
```

## 🔍 代码导读

### 核心代码解析

#### 1. 定义 run_phase

```systemverilog
virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "run_phase starting", UVM_LOW)
    
    // 关键：raise objection 防止提前结束
    phase.raise_objection(this);
    
    // 执行验证任务
    #100;
    
    // 完成任务后 drop objection
    phase.drop_objection(this);
    
    `uvm_info(get_type_name(), "run_phase ended", UVM_LOW)
endtask
```

#### 2. 主从相并行

```
run_phase (全局)
├── env.run_phase
│   ├── agent.run_phase
│   │   ├── driver.run_phase
│   │   ├── monitor.run_phase
│   │   └── sequencer.run_phase
│   ├── scoreboard.run_phase
│   └── coverage.run_phase
```

## 🚀 快速开始

### 环境要求

```bash
# 至少安装一个仿真器
- VCS 2023+
- Xcelium 2023+
- Questa 2023+
```

### 运行示例

```bash
cd 02-uvm-phases/04-run-phase

# VCS (默认)
make

# Xcelium
make SIM=xrun

# Questa
make SIM=vsim

# 清理
make clean
```

## 💡 示例说明

### 01_phases.sv

演示 UVM 所有阶段（build/connect/end_of_elaboration/run/report/final）的执行顺序：

```systemverilog
class my_env extends uvm_env;
    // build_phase
    // connect_phase
    // end_of_elaboration_phase
    // run_phase (包含 objection)
    // report_phase
    // final_phase
endclass
```

**输出示例：**

```
[0] my_env new()
[0] my_env build_phase()
[0] my_env connect_phase()
[0] my_env end_of_elaboration_phase()
[0] my_env run_phase() - Starting
[50] my_env run_phase() - Finished
[50] my_env report_phase()
[50] my_env final_phase()
```

## 📝 练习题

### 练习 1：添加超时控制

```systemverilog
virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    // 设置 1us 超时
    if (!uvm_config_db#(time)::get(this, "", "timeout", timeout)) begin
        timeout = 1us;
    end
    
    fork
        begin
            #(timeout * 2);
            `uvm_error("TIMEOUT", "Run phase exceeded timeout")
        end
        begin
            // 正常任务
            #100;
        end
    join_any
    
    phase.drop_objection(this);
endtask
```

### 练习 2：多线程并行

```systemverilog
virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    fork
        // 线程 1: Driver
        drive_loop();
        // 线程 2: Monitor
        monitor_loop();
        // 线程 3: Checker
        check_loop();
    join
    
    phase.drop_objection(this);
endtask
```

## ⚠️ 常见问题

### Q1: 为什么仿真不结束？

**A**: 检查是否有组件 `raise_objection` 后忘记 `drop_objection`

### Q2: run_phase 和 post_reset_phase 区别？

**A**: `run_phase` 贯穿整个运行期；`post_reset_phase` 等是子相，控制更精细

### Q3: objection count 不为零？

**A**: 确保所有组件都正确 drop 了 objection

## 📚 参考资料

- [UVM User Guide - Phases](https://www.accellera.org/images/downloads/standards/uvm/uvm_user_guide_1.2.pdf)
- [ChipVerify - UVM Phases](https://www.chipverify.com/uvm/uvm-phases)
- [AMIQ - UVM Phases](https://www.amiq.com/consulting/2018/11/09/uvm-phases/)

---

## 👤 作者

**GitHub**: [@jingzhoushii](https://github.com/jingzhoushii)

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../03-end_of_elaboration) | [下一章节](../05-report-phase)
