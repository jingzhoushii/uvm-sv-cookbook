<div align="center">

# 🧪 UVM-SV Cookbook

![UVM Version](https://img.shields.io/badge/UVM-1.2-yellow)
![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-blue)
![License](https://img.shields.io/badge/License-MIT-green)

**UVM/SystemVerilog 入门教程 - 通过可运行的代码片段学习**

[English](README.md) | [中文](README_CN.md)

---

## 📚 学习路线图

```
新手推荐学习路径 (30天):

第1周: SV基础
├── Day 1-2:   01-sv-fundamentals/01-data-types/
├── Day 3:     01-sv-fundamentals/03-interfaces/
├── Day 4-5:   01-sv-fundamentals/04-classes-oop/
└── Day 6-7:   01-sv-fundamentals/05-randomization/

第2周: UVM基础
├── Day 8-9:   02-uvm-phases/
├── Day 10-12: 03-uvm-components/
└── Day 13-14: 04-uvm-transactions/

第3周: UVM进阶
├── Day 15-17: 05-tlm-communication/
├── Day 18-20: 06-configuration/
└── Day 21-22: 07-sequences-advanced/

第4周: 实战+方法学
├── Day 23-26: 09-integrated-examples/
└── Day 27-30: 10-methodology/
```

## 📁 目录结构

### 01-sv-fundamentals - SystemVerilog 基础

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-data-types/` | 数据类型 | logic, bit, struct, enum |
| `02-procedural-blocks/` | 过程块 | always_ff, always_comb, initial |
| `03-interfaces/` | 接口 | interface, modport, clocking |
| `04-classes-oop/` | 面向对象 | 类, 继承, 虚方法 |
| `05-randomization/` | 随机化 | constraint, rand |
| `06-threads-communication/` | 线程通信 | fork-join, mailbox |

### 02-uvm-phases - UVM 阶段机制

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-build-phase/` | 构建阶段 | 组件创建 |
| `02-connect-phase/` | 连接阶段 | TLM端口连接 |
| `03-end_of_elaboration/` |  elaboration | 配置检查 |
| `04-run-phase/` | 运行阶段 | raise/drop objection |
| `05-report-phase/` | 报告阶段 | 结果收集 |
| `06-final-phase/` | 结束阶段 | 仿真终止 |

### 03-uvm-components - UVM 组件体系

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-uvm_component/` | 组件基类 | 层次结构 |
| `02-uvm_env/` | 环境容器 | 组件组织 |
| `03-uvm_agent/` | 代理 | sequencer/driver/monitor |
| `04-uvm_driver/` | 驱动 | 激励生成 |
| `05-uvm_monitor/` | 监控 | 信号采样 |
| `06-uvm_sequencer/` | 仲裁器 | 序列调度 |
| `07-uvm_scoreboard/` | 计分板 | 数据比对 |

### 04-uvm-transactions - 事务处理

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-uvm_sequence_item/` | 事务项 | field_automation |
| `02-uvm_sequence/` | 序列 | body(), pre_body() |
| `03-sequence-lib/` | 序列库 | 嵌套序列 |
| `04-virtual-sequences/` | 虚拟序列 | 跨agent协调 |
| `05-sequence-arbitration/` | 仲裁 | 优先级 |

### 05-tlm-communication - TLM通信

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-put-get-ports/` | 阻塞传输 | put, get |
| `02-analysis-ports/` | 广播 | monitor→scoreboard |
| `03-exports-imp/` | 端口实现 | export, imp |
| `04-sockets/` | 双向通信 | socket |

### 06-configuration - 配置机制

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-uvm_config_db/` | 配置数据库 | set/get |
| `02-uvm_resource_db/` | 资源数据库 | 全局共享 |
| `03-factory-override/` | 工厂机制 | 类型替换 |
| `04-config-object/` | 配置对象 | 推荐做法 |

### 07-sequences-advanced - 序列高级

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-sequence-hooks/` | 钩子函数 | pre/post_body |
| `02-response-handling/` | 响应处理 | get_response |
| `03-pipelined-sequences/` | 流水化 | 并发事务 |
| `04-error-injection/` | 错误注入 | 边界测试 |

### 08-reporting-messaging - 报告机制

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-uvm_report_handler/` | 消息宏 | 严重性分级 |
| `02-log-files/` | 日志管理 | 文件重定向 |
| `03-coverage-collection/` | 覆盖率 | covergroup |

### 09-integrated-examples - 综合实战

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-ader-full-env/` | 加法器 | 完整UVM环境 |
| `02-ahb-lite-svtb/` | AHB-Lite | 总线协议验证 |
| `03-fifo-verification/` | FIFO | 边界条件测试 |
| `04-uart-controller/` | UART | 寄存器+中断 |

### 10-methodology - 方法学最佳实践

| 目录 | 主题 | 描述 |
|------|------|------|
| `01-testbench-architecture/` | 架构设计 | 可重用性 |
| `02-regression-scripts/` | 回归脚本 | Makefile |
| `03-coverage-driven/` | CDV流程 | 覆盖率驱动 |
| `04-uvm-ieee-compliance/` | 标准合规 | 1800.2 |

### common/ - 共享资源

```
common/
├── dut/              # 通用DUT (ALU, FIFO, RAM)
├── utils/            # 宏定义、包文件
└── scripts/          # 编译脚本
    ├── run_vcs.sh    # VCS
    ├── run_xrun.sh   # Xcelium
    └── run_questa.sh # Questa
```

## 🚀 快速开始

### 环境要求

```bash
# 必需工具
- VCS 2023+ | Xcelium | Questa
- UVM 1.2 (IEEE 1800.2-2021)
- GNU Make 4.0+
```

### 运行第一个示例

```bash
# 进入第一个示例
cd 01-sv-fundamentals/01-data-types

# 编译并运行
make

# 查看波形
make waves
```

### 添加新示例

参考 [CONTRIBUTING.md](CONTRIBUTING.md)

## 🎯 查找表

| 问题 | 解决方案 |
|------|----------|
| 如何定义事务? | `04-uvm-transactions/01-uvm_sequence_item/` |
| 如何连接组件? | `02-uvm-phases/02-connect-phase/` |
| 如何配置组件? | `06-configuration/01-uvm_config_db/` |
| 如何发送序列? | `04-uvm-transactions/02-uvm_sequence/` |
| 如何做覆盖率? | `08-reporting-messaging/03-coverage-collection/` |
| 如何创建完整环境? | `09-integrated-examples/01-ader-full-env/` |

## 🤝 贡献指南

欢迎贡献新示例! 参考 [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 许可证

MIT License

## 👤 作者

GitHub: [@jingzhoushii](https://github.com/jingzhoushii)

---

**Happy Learning! 🧪**

</div>
