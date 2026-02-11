# Mini SoC UVM - 贯穿式主线工程

## 概述

本项目是一条**贯穿所有章节的主线工程**，从零开始构建完整 SoC 验证平台。

## 学习路线

| 章节 | 集成内容 |
|------|----------|
| 01-sv-fundamentals | 数据类型、OOP |
| 02-uvm-phases | 构建/连接环境 |
| 03-uvm-components | Driver/Monitor/Sequencer |
| 04-uvm-transactions | Transaction 定义 |
| 05-tlm-communication | 组件连接 |
| 06-configuration | Config DB |
| 07-sequences-advanced | Sequence |
| 09-register-model-ral | 寄存器模型 |
| 11-low-power-verification | 低功耗 |

## 目录结构

```
mini_soc_uvm/
├── README.md              # 本文档
├── Makefile              # 统一编译
├── top.sv                # 顶层模块
│
├── dut/                  # 被测设计
│   ├── mini_soc.sv       # SoC 顶层
│   ├── ahb_to_ahb_bridge.sv
│   ├── gpio.sv
│   └── timer.sv
│
├── tb/                   # 测试平台
│   ├── top_tb.sv        # testbench 顶层
│   └── tb_env.sv        # 基础环境
│
├── env/                  # UVM 组件
│   ├── mini_env.sv      # 环境容器
│   ├── ahb_agent.sv     # AHB Agent
│   ├── gpio_agent.sv    # GPIO Agent
│   └── scoreboard.sv    # 计分板
│
├── reg/                  # 寄存器模型
│   ├── gpio_reg.sv      # GPIO 寄存器
│   └── timer_reg.sv     # Timer 寄存器
│
├── seq/                  # 序列
│   ├── gpio_seq.sv      # GPIO 序列
│   └── timer_seq.sv     # Timer 序列
│
└── low_power/           # 低功耗
    └── test_power.sv    # 低功耗测试
```

## 快速开始

```bash
cd projects/mini_soc_uvm
make            # 编译并运行
make debug      # 生成波形
make cov        # 覆盖率报告
```

## 各章节集成

### 第 1 章：数据类型
```systemverilog
// mini_soc.sv 中使用 bit, logic, int 等
```

### 第 2-3 章：组件体系
```systemverilog
// env/mini_env.sv 中构建 uvm_agent
```

### 第 6 章：配置管理
```systemverilog
// 使用 uvm_config_db 传递配置
```

### 第 7 章：序列
```systemverilog
// seq/gpio_seq.sv 实现流控序列
```

## 工程化特性

1. **参数化配置**
2. **层次化结构**
3. **可复用 Agent**
4. **完整 Scoreboard**

