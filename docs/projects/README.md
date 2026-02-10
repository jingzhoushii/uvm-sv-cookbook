# 📋 项目作业

## 概述

本目录包含 3 个综合项目，用于第 4 周实战演练。

---

## 项目 1：AXI4-Lite Agent（⭐⭐）

### 要求
- 实现完整的 AXI4-Lite Agent
- 支持 Active/Passive 模式
- 包含 Driver、Monitor、Sequencer
- 实现 Scoreboard

### 文件结构
```
project1_axi_agent/
├── Makefile
├── axi_agent.sv
├── axi_driver.sv
├── axi_monitor.sv
├── axi_sequencer.sv
├── axi_scoreboard.sv
└── tests/
    ├── test_write.sv
    └── test_read.sv
```

### 评分标准
- [ ] 代码完整 (40%)
- [ ] 功能正确 (30%)
- [ ] 文档 (20%)
- [ ] 可运行 (10%)

---

## 项目 2：Memory Controller Verification（⭐⭐⭐）

### 要求
- 实现完整的验证平台
- 包含 AXI 和 APB Agent
- 实现 RAL 模型
- 编写测试计划
- 完成回归测试

### 文件结构
```
project2_mem_ctrl/
├── Makefile
├── agents/
│   ├── axi_agent.sv
│   └── apb_agent.sv
├── env/
│   ├── mem_env.sv
│   └── mem_scoreboard.sv
├── ral/
│   └── mem_regmodel.sv
├── tests/
│   ├── test_basic.sv
│   ├── test_burst.sv
│   └── test_error.sv
└── testplan.md
```

### 评分标准
- [ ] Agent 完整 (30%)
- [ ] RAL 正确 (20%)
- [ ] 测试覆盖 (20%)
- [ ] 文档 (20%)
- [ ] 回归测试 (10%)

---

## 项目 3：SOC Verification Platform（⭐⭐⭐⭐⭐）

### 要求
- 完整的 SOC 验证平台
- 多个 Agent（AXI、APB、中断）
- RAL 模型
- UPF 低功耗验证
- 完整文档

### 文件结构
```
project3_soc_vp/
├── Makefile
├── agents/
│   ├── axi_agent.sv
│   ├── apb_agent.sv
│   └── irq_agent.sv
├── env/
│   ├── soc_env.sv
│   ├── soc_scoreboard.sv
│   └── coverage.sv
├── ral/
│   └── soc_regmodel.sv
├── tests/
│   ├── test_sanity.sv
│   ├── test_memory.sv
│   ├── test_interrupt.sv
│   └── test_power.sv
├── upf/
│   └── soc.upf
└── docs/
    ├── testplan.md
    ├── architecture.md
    └── coverage_report.md
```

### 评分标准
- [ ] Agent 完整 (20%)
- [ ] RAL 模型 (15%)
- [ ] 低功耗验证 (15%)
- [ ] 测试覆盖 (20%)
- [ ] 文档 (20%)
- [ ] 回归测试 (10%)

---

## 提交要求

### 提交格式
```
姓名_项目_日期.zip
├── 源代码/
├── 文档/
└── 报告.pdf
```

### 时间限制
- 项目 1：3 天
- 项目 2：5 天
- 项目 3：7 天

