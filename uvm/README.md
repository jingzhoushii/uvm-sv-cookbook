# UVM 1.2 - 集成源码

## 概述

本仓库已集成 **UVM 1.2** 源码，无需单独下载！

只需要准备 **VCS** 仿真器即可开始调试。

## 目录结构

```
uvm/
├── src/                   # UVM 源码
│   ├── base/             # 基础类
│   ├── comps/            # 组件类
│   ├── seq/              # 序列
│   ├── reg/              # 寄存器模型
│   ├── tlm1/             # TLM 1.0
│   ├── tlm2/             # TLM 2.0
│   ├── macros/           # 宏定义
│   └── dpi/              # DPI
│
├── examples/              # UVM 官方示例
│
├── docs/                 # UVM 文档
│
├── filelist.f           # 源码文件列表
│
└── README.md            # 本文档
```

## UVM 组件

| 模块 | 文件数 | 说明 |
|------|--------|------|
| base | 35+ | 基础类 (uvm_object, uvm_phase 等) |
| comps | 15+ | 组件类 (uvm_driver, uvm_monitor 等) |
| seq | 10+ | 序列机制 |
| reg | 25+ | 寄存器抽象层 |
| tlm1 | 5+ | TLM 1.0 |
| tlm2 | 15+ | TLM 2.0 |
| macros | 10+ | 宏定义 |
| **总计** | **100+** | **完整 UVM 1.2** |

## 快速开始

### 方法 1：使用仓库的 Makefile

```bash
# 进入任意章节
cd 01-sv-fundamentals/01-data-types

# 编译运行
make

# 清理
make clean
```

### 方法 2：单独编译 UVM

```bash
cd uvm
vcs -sverilog -f filelist.f -l uvm_comp.log
```

## 环境要求

| 工具 | 版本 | 说明 |
|------|------|------|
| **VCS** | 2023.06+ | 必须 |
| Xcelium | 23.09+ | 可选 |
| Questa | 2023.4+ | 可选 |

## 文件列表

### 核心文件

| 文件 | 说明 |
|------|------|
| `uvm.sv` | UVM 主包 |
| `uvm_macros.svh` | 宏定义 |
| `filelist.f` | 编译文件列表 |

### 关键类

| 类 | 说明 |
|----|------|
| `uvm_object` | 顶层对象类 |
| `uvm_component` | 组件基类 |
| `uvm_driver` | 驱动组件 |
| `uvm_monitor` | 监控组件 |
| `uvm_sequencer` | 序列仲裁器 |
| `uvm_scoreboard` | 计分板 |
| `uvm_env` | 环境容器 |
| `uvm_test` | 测试基类 |

## 编译选项

```bash
# UVM 编译宏
+define+UVM_NO_DPI
+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR

# 编译顺序
-vcs -sverilog -ntb_opts uvm-1.2
```

## 官方文档

- [UVM User Guide 1.2](https://www.accellera.org/images/downloads/standards/uvm/uvm_user_guide_1.2.pdf)
- [UVM Class Reference](https://www.accellera.org/)

## 许可

UVM 源码遵循 Apache 2.0 许可（见 `LICENSE.txt`）

## 版本

- **UVM 版本**: 1.2
- **发布日期**: 2014
- **标准**: IEEE 1800.2

## 注意事项

1. **无需单独下载 UVM** - 源码已集成
2. **只需要 VCS** - 即可编译运行所有示例
3. **跨平台** - UVM 源码与仿真器无关

## 相关链接

- Accellera: https://www.accellera.org/
- UVM 下载: https://www.accellera.org/downloads/standards/uvm
- 本仓库: https://github.com/jingzhoushii/uvm-sv-cookbook

---

**只需 VCS，立即开始 UVM 学习！** 🚀
