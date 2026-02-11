# Mini SoC Verification Platform

## 概述

工业级 SoC 验证平台 - 教学与实战结合。

## 目录结构

```
mini_soc/
├── rtl/                    # RTL 设计
│   ├── top.sv            # 顶层
│   ├── bus/              # 系统总线
│   ├── cpu_stub/         # CPU Stub
│   ├── dma/              # DMA 控制器
│   ├── uart/             # UART
│   └── timer/            # 定时器
│
├── tb/                    # 验证平台
│   ├── agent/            # Agents
│   │   ├── bus_agent/
│   │   ├── uart_agent/
│   │   └── dma_agent/
│   ├── env/             # Environment
│   ├── virt_seq/       # Virtual Sequences
│   └── test/           # Tests
│
├── regress/             # 回归测试
├── coverage/            # 覆盖率
└── Makefile            # 编译脚本
```

## 快速开始

```bash
cd mini_soc
make              # 编译并运行
make smoke        # 冒烟测试
make stress       # 压力测试
make clean        # 清理
```

## 测试

| 测试 | 说明 |
|------|------|
| smoke_test | 冒烟测试 |
| stress_test | 压力测试 |

## 特性

- ✅ AHB 总线
- ✅ 多 Agent
- ✅ Virtual Sequencer
- ✅ Scoreboard

## 作者

jingzhoushii

