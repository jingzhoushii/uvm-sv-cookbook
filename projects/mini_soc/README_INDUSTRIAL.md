# Mini SoC Industrial Verification Platform

## 概述

工业级 SoC 验证平台 - 符合真实芯片项目标准

## 架构升级清单

| Phase | 升级内容 | 状态 |
|-------|----------|------|
| **Phase A** | Platform Configuration (平台结构驱动型配置) | ✅ |
| **Phase B** | Virtual Sequence (场景驱动序列) | ✅ |
| **Phase C** | Reference Model (模块化参考模型) | ✅ |
| **Phase D** | Scoreboard (系统级校验) | ✅ |
| **Phase E** | Coverage (分层覆盖率模型) | ✅ |
| **Phase F** | Regression (工业级回归) | ✅ |

---

## Phase A: Platform Configuration

### 核心特性
- 平台结构驱动型配置
- 动态组件组装
- 子系统/IP/Full-chip 模式

### 配置类
```
mini_soc_platform_cfg
├── SoC 结构控制 (has_uart/dma/timer)
├── 总线参数
├── Agent 配置
└── 验证控制 (coverage/scoreboard/ref_model)
```

---

## Phase B: Virtual Sequence

### 序列分类体系
```
virt_seq/
├── boot/ (上电/复位序列)
│   ├── power_on_vseq
│   └── reset_recovery_vseq
│
├── traffic/ (流量序列)
│   ├── dma_flood_vseq
│   ├── uart_stream_vseq
│   └── mixed_io_vseq
│
├── error/ (错误注入)
│   └── bus_error_vseq
│
└── chaos/ (随机系统)
    └── random_system_vseq
```

---

## Phase C: Reference Model

### 模块化架构
```
ref/
├── soc_ref_model.sv (集成)
├── bus_model/
│   └── bus_ref_model.sv
├── memory_model/
│   └── memory_ref_model.sv
├── uart_model/
│   └── uart_ref_model.sv
└── dma_model/
    └── dma_ref_model.sv
```

---

## Phase D: Scoreboard

### 增强特性
- Queue-based matching
- ID-based matching (out-of-order)
- 自动 Pass/Fail 统计

---

## Phase E: Coverage

### 分层覆盖率
```
Transaction Coverage → Scenario Coverage → System Cross Coverage
```

### 覆盖组
- Address Coverage
- Data Coverage  
- Read/Write Coverage
- Cross Coverage

---

## Phase F: Regression

### 运行模式
```bash
# CI 快速冒烟
python3 regress/run_industrial.py --mode ci

# Daily 基础功能
python3 regress/run_industrial.py --mode daily

# Nightly 完整功能
python3 regress/run_industrial.py --mode nightly

# Weekly 压力测试
python3 regress/run_industrial.py --mode weekly

# Release 全部测试
python3 regress/run_industrial.py --mode release
```

---

## 文件统计

| 类型 | 数量 |
|------|------|
| SV 文件 | 50+ |
| Python 脚本 | 3 |
| YAML 配置 | 3 |
| 文档 | 5 |

---

## 使用方法

```bash
cd projects/mini_soc

# 编译
make

# 运行回归
python3 regress/run_industrial.py --mode nightly
```

---

## 下一步

- 完善 Reference Model 集成
- 添加更多错误注入序列
- 完善覆盖率合并
- 添加寄存器自动检查

