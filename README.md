<div align="center">

# 🧪 UVM-SV Cookbook

[![UVM Version](https://img.shields.io/badge/UVM-1.2-yellow)](https://www.accellera.org/)
[![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-blue)](https://ieeexplore.ieee.org/document/1800799)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Stars](https://img.shields.io/github/stars/jingzhoushii/uvm-sv-cookbook)]()

**SystemVerilog/UVM 验证教程 - 通过可运行的代码片段学习**

[English](README.md) | [中文](README_CN.md)

---

## 📚 项目概述

UVM-SV Cookbook 是一个系统化的 SystemVerilog/UVM 学习仓库，包含 **17 个主章节、60+ 个子章节**，覆盖从基础到高级的验证知识。

### 特点

- ✅ 每个章节都有**可运行的示例代码**
- ✅ 详细的**中文文档**（知识点、背景知识、代码导读）
- ✅ 支持多种仿真器（VCS / Xcelium / Questa）
- ✅ 完整的 Makefile 编译脚本
- ✅ 遵循 GitHub 最佳实践
- ✅ 难度分级标记（🟢基础 / 🟡进阶 / 🔴高级）

---

## 📚 学习路线图

### 30 天学习计划

| 周 | 内容 | 章节 |
|----|------|------|
| **第1周** | SystemVerilog 基础 | `01-sv-fundamentals/` |
| **第2周** | UVM 核心机制 | `02-uvm-phases/` - `06-configuration/` |
| **第3周** | UVM 高级特性 | `07-sequences-advanced/` - `08-reporting-messaging/` |
| **第4周** | 垂直领域 | `09-register-model-ral/` - `16-uvm-1800-2/` |

---

## 📁 目录结构

```
uvm-sv-cookbook/
├── README.md                    # 本文档
├── README_CN.md                # 中文介绍
├── LICENSE                     # MIT License
├── PLAN.md                     # 项目计划
├── .templates/                 # 模板文件
│   ├── README_TEMPLATE.md
│   ├── Makefile_TEMPLATE
│   ├── SV_HEADER.txt
│   ├── SV_LINT_RULES.md       # 编码规范
│   ├── UVM_VERBOSITY.md       # verbosity 级别
│   └── SIMULATOR_VERSIONS.md # 仿真器版本
│
├── 01-sv-fundamentals/         # 🟢 SystemVerilog 基础
│   ├── 01-data-types/         ✅ 数据类型
│   ├── 02-procedural-blocks/  ✅ 过程块
│   ├── 03-interfaces/         ✅ 接口
│   ├── 04-classes-oop/        ✅ 面向对象 [新增 static vs instance]
│   ├── 05-randomization/      ✅ 随机化
│   └── 06-threads-communication/ ✅ 线程通信
│
├── 02-uvm-phases/              # 🟢 UVM 阶段机制
│   ├── 01-build-phase/        ✅ 构建阶段
│   ├── 02-connect-phase/     ✅ 连接阶段
│   ├── 03-end_of_elaboration/  ✅ elaboration
│   ├── 04-run-phase/         ✅ 运行阶段
│   ├── 05-report-phase/       ✅ 报告阶段
│   └── 06-final-phase/        ✅ 结束阶段
│
├── 03-uvm-components/         # 🟢 UVM 组件体系
│   ├── 01-uvm_component/     ✅ 组件基类
│   ├── 02-uvm_env/           ✅ 环境容器
│   ├── 03-uvm_agent/         ✅ 代理
│   ├── 04-uvm_driver/        ✅ 驱动
│   ├── 05-uvm_monitor/        ✅ 监控
│   ├── 06-uvm_sequencer/     ✅ 仲裁器
│   └── 07-uvm_scoreboard/     ✅ 计分板
│
├── 04-uvm-transactions/        # 🟡 事务处理
│   ├── 01-uvm_sequence_item/ ✅ 事务项
│   ├── 02-uvm_sequence/      ✅ 序列 [新增 uvm_do vs start_item]
│   ├── 03-sequence-lib/       ✅ 序列库
│   ├── 04-virtual-sequences/  ✅ 虚拟序列
│   └── 05-sequence-arbitration/ ✅ 仲裁
│
├── 05-tlm-communication/       # 🟡 TLM 通信
│   ├── 01-put-get-ports/     ✅ 阻塞传输
│   ├── 02-analysis-ports/     ✅ 广播 [新增 copy 警告]
│   ├── 03-exports-imp/        ✅ 端口实现
│   └── 04-sockets/            ✅ 双向通信
│
├── 06-configuration/           # 🟢 配置机制
│   ├── 01-uvm_config_db/     ✅ 配置数据库
│   ├── 02-uvm_resource_db/  ✅ 资源数据库
│   ├── 03-factory-override/   ✅ 工厂机制
│   └── 04-config-object/      ✅ 配置对象
│
├── 07-sequences-advanced/     # 🔴 序列高级特性
│   ├── 01-sequence-hooks/     ✅ 钩子函数
│   ├── 02-response-handling/  ✅ 响应处理
│   ├── 03-pipelined-sequences/ ✅ 流水化
│   └── 04-error-injection/    ✅ 错误注入
│
├── 08-reporting-messaging/     # 🟡 报告与调试
│   ├── 01-uvm_report_handler/ ✅ 消息宏
│   ├── 02-log-files/          ✅ 日志管理
│   └── 03-coverage-collection/ ✅ 覆盖率
│
├── 09-register-model-ral/     # 🔴 寄存器模型
│   ├── 01-reg-block-basic/    ✅ RAL 基础
│   ├── 02-reg-access-methods/  ✅ 访问方法
│   ├── 03-reg-sequences/      ✅ 寄存器序列
│   ├── 04-reg-coverage/       ✅ 覆盖率
│   ├── 05-reg-irq-integration/ ✅ 中断集成
│   ├── 06-reg-reset/          ✅ 复位处理
│   ├── 07-reg-backdoor-access/ ✅ 后门访问
│   └── 08-reg-adapter-advanced/ ✅ 适配器
│
├── 10-interrupt-verification/  # 🔴 中断验证
│   ├── 01-interrupt-basics/   ✅ 中断基础
│   ├── 02-interrupt-agent/    ✅ 中断代理
│   ├── 03-interrupt-sequences/ ✅ 中断序列
│   ├── 04-interrupt-scoreboard/ ✅ 计分板
│   ├── 05-interrupt-priority/  ✅ 优先级
│   ├── 06-interrupt-regression/ ✅ 回归测试
│   └── 07-interrupt-to-ral/    ✅ RAL 集成
│
├── 11-low-power-verification/  # 🔴 低功耗验证
│   ├── 01-power-domains-basics/ ✅ 电源域
│   ├── 02-upf-simulation/      ✅ UPF 仿真
│   ├── 03-power-controller-vip/ ✅ 电源控制
│   ├── 04-power-state-transitions/ ✅ 状态转换
│   ├── 05-isolation-check/     ✅ 隔离检查
│   ├── 06-retention-registers/ ✅ 保持寄存器
│   └── 07-power-aware-sequences/ ✅ 功耗序列
│
├── 12-uvm-factory-debug/        # 🔴 [新增] 工厂调试
│   ├── 01-factory-basics/     ✅ create vs new
│   ├── 02-type-override/      ✅ set_type_override
│   ├── 03-factory-override/   ✅ $cast 验证
│   └── 04-debug-techniques/  ✅ print_override_info
│
├── 13-performance-optimization/ # 🔴 [新增] 性能优化
│   ├── 01-zero-copy/          ⚠️ 数据竞争警告
│   ├── 02-transaction-pooling/ ✅ 对象池
│   ├── 03-object-reuse/       ✅ 对象复用
│   └── 04-benchmark/           ✅ 性能测试
│
├── 14-formal-verification/     # 🟡 [新增] 形式验证
│   ├── 01-sva-basics/          ✅ 断言基础
│   └── 02-assertion-examples/  ✅ 握手协议
│
├── 15-real-chip-examples/      # 🔴 [新增] 真实案例
│   └── 01-axi-interconnect/   ✅ AXI 验证框架
│
├── 16-uvm-1800-2-changes/      # 🟡 [新增] UVM 1.2
│   ├── 01-virtual-class/      ✅ 虚类应用
│   └── 02-new-features/        ✅ 新特性
│
├── appendix/                    # 📎 [新增] 附录
│   ├── common-errors.md        # 常见错误速查
│   ├── QUICKREF_ERRORS.md      # 错误诊断
│   ├── LEARNING_FEEDBACK.md    # 学习反馈
│   └── MERMAID_CHARTS.md       # UVM 图表
│
├── common/                       # 共享资源
│   ├── dut/                    # 通用 DUT
│   ├── utils/                  # 宏和包
│   ├── scripts/                 # 运行脚本
│   └── docs/                   # 文档
│
└── .scripts/                    # 生成脚本

Legend: ✅ 已完成 | ⚠️ 需注意 | 🔴 高级 | 🟡 进阶 | 🟢 基础
```

---

## 🚀 快速开始

### 环境要求

```bash
# 至少安装一个仿真器
- Synopsys VCS 2023.06-SP2+ ✅ 已测试
- Cadence Xcelium 23.09+ ✅ 已测试
- Siemens Questa 2023.4+ ✅ 已测试
```

### 克隆仓库

```bash
git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git
cd uvm-sv-cookbook
```

### 运行示例

```bash
cd 01-sv-fundamentals/01-data-types

# VCS (默认)
make

# 清理
make clean
```

---

## 📖 每个章节的结构

```
chapter/
├── README.md              # 知识点讲解 + 代码导读
├── Makefile              # 编译运行脚本
├── examples/            # 代码片段示例
│   └── *.sv
└── tb/                  # 测试平台
    └── *.sv
```

---

## 🎯 查找表

| 问题 | 解决方案 |
|------|----------|
| 如何定义事务? | `04-uvm-transactions/01-uvm_sequence_item/` |
| 如何调试 factory? | `12-uvm-factory-debug/03-factory-override/` |
| 如何优化性能? | `13-performance-optimization/01-zero-copy/` |
| 如何验证断言? | `14-formal-verification/01-sva-basics/` |
| 常见编译错误? | `appendix/QUICKREF_ERRORS.md` |
| 如何处理中断? | `10-interrupt-verification/01-interrupt-basics/` |
| 如何做低功耗验证? | `11-low-power-verification/01-power-domains-basics/` |

---

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| 主章节 | **17** 个 (+6) |
| 子章节 | **60+** 个 (+12) |
| SV 文件 | **176** 个 |
| 代码行数 | **9,724** 行 |
| 文档行数 | **5,000+** 行 |

---

## 🔧 Makefile 目标

```bash
make          # 编译并运行
make compile  # 仅编译
make run      # 仅运行
make clean    # 清理

# 新增目标
make lint     # 静态检查 (verilator)
make coverage # 生成覆盖率报告
make regression  # 回归测试
make clean_all  # 清理所有生成文件
```

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

### 代码规范

- 使用 `.templates/SV_HEADER.txt` 作为文件头
- 使用 `.templates/SV_LINT_RULES.md` 作为编码规范
- 统一 verbosity 级别（UVM_LOW 用于教学）
- 添加详细注释（30%+ 密度）

---

## 📚 参考资源

### 官方文档

- [UVM User Guide 1.2](https://www.accellera.org/images/downloads/standards/uvm/uvm_user_guide_1.2.pdf)
- [IEEE 1800.2-2020](https://ieeexplore.ieee.org/document/1800799)

### 在线教程

- [ChipVerify UVM](https://www.chipverify.com/)
- [Verification Academy](https://verificationacademy.com/)

### 工具链

- [VCS Documentation](https://www.synopsys.com/verification/simulation-verification.html)
- [Xcelium Documentation](https://www.cadence.com/en_US/DevTools/Incisive-Enterprise-Simulator.html)

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 👤 作者

**jingzhoushii** - jingzhoushii@gmail.com

---

## 🙏 致谢

- 感谢所有贡献者
- 感谢 [Kimi AI](https://kimi.ai) 提供优化建议
- 感谢 UVM 社区
- 感谢 ChipVerify、AMIQ 等优秀教程

---

**Happy Learning! 🧪**

*Inspired by Python Cookbook and UVM User Guide*

---

## 📋 关键代码检查清单

### ✅ Factory Override 验证
```systemverilog
// 在 end_of_elaboration_phase 中验证
virtual function void end_of_elaboration_phase(uvm_phase phase);
    my_override_type casted_comp;
    if (!$cast(casted_comp, comp))
        `uvm_fatal("FCT_CHK", "Factory override failed!")
    else
        `uvm_info("FCT_OK", $sformatf("Override: %s", comp.get_type_name()), UVM_LOW)
endfunction
```

### ✅ Analysis Port 安全
```systemverilog
class safe_subscriber extends uvm_subscriber #(trans);
    virtual function void write(trans t);
        trans local_t = trans::type_id::create("local_t");
        local_t.copy(t);  // Must copy before modify!
    endfunction
endclass
```

### ✅ Zero-Copy 警告
```systemverilog
// ⚠️ WARNING: Zero-copy performance optimization
// Risk: Data race if sequence modifies transaction after get_next_item()
// Mitigation: Ensure blocking drive() or use copy()
```

