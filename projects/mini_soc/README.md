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


---

## Phase 2: Agents & Environment 完善

### 新增组件

| 组件 | 文件 | 说明 |
|------|------|------|
| Sequences | tb/agent/*/bus_seq.sv | Bus/UART/DMA 序列 |
| Enhanced Env | tb/env/mini_soc_env_enh.sv | 完整环境 |
| Coverage | coverage/soc_cov.sv | 覆盖率模型 |
| Tests | tb/test/{random,mem,dma}_test.sv | 高级测试 |
| Regression | regress/{regress.yaml,run_regress.py} | 回归配置 |

### 测试列表

| 测试 | 说明 |
|------|------|
| smoke_test | 冒烟测试 |
| random_test | 随机测试 |
| mem_test | 存储器测试 |
| dma_test | DMA 测试 |
| stress_test | 压力测试 |

### Regression 使用

```bash
# 运行冒烟回归
python3 regress/run_regress.py smoke

# 运行功能回归
python3 regress/run_regress.py functional

# 运行完整回归
python3 regress/run_regress.py full
```

### Coverage 模型

- Transaction Coverage
- Bus Transfer Coverage
- Cross Coverage

