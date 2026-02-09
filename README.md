<div align="center">

# 🧪 UVM-SV Cookbook

[![UVM Version](https://img.shields.io/badge/UVM-1.2-yellow)](https://www.accellera.org/)
[![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-blue)](https://ieeexplore.ieee.org/document/1800799)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**UVM/SystemVerilog 入门教程 - 通过可运行的代码片段学习**

[English](README.md) | [中文](README_CN.md)

---

## 📚 学习路线图

### 30 天学习计划

| 周 | 内容 | 章节 |
|----|------|------|
| **第1周** | SystemVerilog 基础 | `01-sv-fundamentals/` |
| **第2周** | UVM 基础 | `02-uvm-phases/`, `03-uvm-components/` |
| **第3周** | UVM 进阶 | `04-uvm-transactions/` ~ `08-reporting-messaging/` |
| **第4周** | 高级主题 | `09-register-model-ral/` ~ `11-low-power-verification/` |

---

## 📁 目录结构

```
uvm-sv-cookbook/
├── README.md                    # 本文档
├── README_CN.md                # 中文介绍
├── LICENSE                     # MIT License
│
├── 01-sv-fundamentals/         # SystemVerilog 基础
│   ├── 01-data-types/        ✅ 数据类型
│   ├── 02-procedural-blocks/ ⏳ 过程块
│   ├── 03-interfaces/        ✅ 接口
│   ├── 04-classes-oop/      ⏳ 面向对象
│   ├── 05-randomization/    ⏳ 随机化
│   └── 06-threads-communication/ ⏳ 线程通信
│
├── 02-uvm-phases/            # UVM 阶段机制
│   ├── 01-build-phase/       ⏳ 构建阶段
│   ├── 02-connect-phase/    ⏳ 连接阶段
│   ├── 03-end_of_elaboration/ ⏳ elaboration
│   ├── 04-run-phase/        ✅ 运行阶段
│   ├── 05-report-phase/     ⏳ 报告阶段
│   └── 06-final-phase/      ⏳ 结束阶段
│
├── 03-uvm-components/       # UVM 组件体系
│   ├── 01-uvm_component/    ⏳ 组件基类
│   ├── 02-uvm_env/          ⏳ 环境容器
│   ├── 03-uvm_agent/       ✅ 代理
│   ├── 04-uvm_driver/      ⏳ 驱动
│   ├── 05-uvm_monitor/     ⏳ 监控
│   ├── 06-uvm_sequencer/   ⏳ 仲裁器
│   └── 07-uvm_scoreboard/  ⏳ 计分板
│
├── 04-uvm-transactions/      # 事务处理
│   ├── 01-uvm_sequence_item/ ✅ 事务项
│   ├── 02-uvm_sequence/    ⏳ 序列
│   ├── 03-sequence-lib/     ⏳ 序列库
│   ├── 04-virtual-sequences/ ⏳ 虚拟序列
│   └── 05-sequence-arbitration/ ⏳ 仲裁
│
├── 05-tlm-communication/     # TLM 通信
│   ├── 01-put-get-ports/    ✅ 阻塞传输
│   ├── 02-analysis-ports/  ⏳ 广播
│   ├── 03-exports-imp/      ⏳ 端口实现
│   └── 04-sockets/         ⏳ 双向通信
│
├── 06-configuration/         # 配置机制
│   ├── 01-uvm_config_db/    ✅ 配置数据库
│   ├── 02-uvm_resource_db/ ⏳ 资源数据库
│   ├── 03-factory-override/ ⏳ 工厂机制
│   └── 04-config-object/  ⏳ 配置对象
│
├── 07-sequences-advanced/    # 序列高级特性
│   ├── 01-sequence-hooks/   ✅ 钩子函数
│   ├── 02-response-handling/ ⏳ 响应处理
│   ├── 03-pipelined-sequences/ ⏳ 流水化
│   └── 04-error-injection/ ⏳ 错误注入
│
├── 08-reporting-messaging/   # 报告与调试
│   ├── 01-uvm_report_handler/ ⏳ 消息宏
│   ├── 02-log-files/       ⏳ 日志管理
│   └── 03-coverage-collection/ ⏳ 覆盖率
│
├── 09-register-model-ral/   # 寄存器模型
│   ├── 01-reg-block-basic/ ⏳ RAL 基础
│   ├── 02-reg-access-methods/ ⏳ 访问方法
│   └── 03-reg-sequences/   ⏳ 寄存器序列
│
├── 10-interrupt-verification/ # 中断验证
│   ├── 01-interrupt-basics/ ⏳ 中断基础
│   └── 02-interrupt-agent/  ⏳ 中断代理
│
├── 11-low-power-verification/ # 低功耗验证
│   ├── 01-power-domains-basics/ ⏳ 电源域
│   └── 02-upf-simulation/  ⏳ UPF 仿真
│
├── common/                    # 共享资源
│   ├── dut/                 # 通用 DUT
│   ├── utils/               # 宏和包
│   ├── scripts/             # 运行脚本
│   └── docs/                # 文档
│
└── .scripts/                 # 生成脚本

Legend: ✅ 已完成 | ⏳ 待完善
```

---

## 🚀 快速开始

### 环境要求

```bash
# 商业仿真器 (至少一个)
- Synopsys VCS 2023+
- Cadence Xcelium 2023+
- Siemens Questa 2023+

# 开源替代
- Icarus Verilog (有限支持)
```

### 安装

```bash
# 克隆仓库
git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git
cd uvm-sv-cookbook

# 运行第一个示例
cd 01-sv-fundamentals/01-data-types
make
```

### 支持的仿真器

```bash
# VCS (默认)
make SIM=vcs

# Xcelium
make SIM=xrun

# Questa
make SIM=vsim
```

---

## 📖 每个章节的结构

```
chapter/
├── README.md              # 知识点讲解 + 代码导读
├── Makefile              # 编译运行脚本
├── filelist.f            # 文件列表 (可选)
├── examples/            # 代码片段示例
│   └── *.sv
├── tb/                  # 测试平台
│   └── tb_*.sv
└── dut/                 # 被测设计
    └── *.sv
```

---

## 🎯 查找表

| 问题 | 解决方案 |
|------|----------|
| 如何定义事务? | `04-uvm-transactions/01-uvm_sequence_item/` |
| 如何连接组件? | `02-uvm-phases/02-connect-phase/` |
| 如何配置组件? | `06-configuration/01-uvm_config_db/` |
| 如何发送序列? | `04-uvm-transactions/02-uvm_sequence/` |
| 如何做覆盖率? | `08-reporting-messaging/03-coverage-collection/` |
| 如何创建完整环境? | `03-uvm-components/02-uvm_env/` |

---

## 🤝 贡献

欢迎贡献代码！参考 [CONTRIBUTING.md](CONTRIBUTING.md)

### 贡献步骤

1. Fork 本仓库
2. 创建分支 `git checkout -b feature/xxx`
3. 添加代码
4. 提交 `git commit -m "feat: xxx"`
5. 推送 `git push`
6. 发起 Pull Request

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 👤 作者

**jingzhoushii**

- GitHub: [@jingzhoushii](https://github.com/jingzhoushii)
- Email: jingzhoushii@gmail.com

---

**Happy Learning! 🧪**

_Inspired by Python Cookbook and UVM User Guide_
