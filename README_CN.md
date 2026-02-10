<div align="center">

# 🧪 UVM-SV Cookbook

[![UVM 版本](https://img.shields.io/badge/UVM-1.2-yellow)](https://www.accellera.org/)
[![SystemVerilog](https://img.shields.io/badge/SystemVerilog-2017-blue)](https://ieeexplore.ieee.org/document/1800799)
[![许可证](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**SystemVerilog/UVM 验证入门教程 - 通过可运行的代码片段学习**

---

## 📖 项目简介

UVM-SV Cookbook 是一个系统化的 SystemVerilog/UVM 验证学习仓库，包含 **11 个主章节**、**48 个子章节**，覆盖从基础到高级的芯片验证知识。

### 主要特点

- ✅ 每个章节都有**可运行的示例代码**
- ✅ 详细的**中文文档**（知识点、背景知识、代码导读）
- ✅ 支持多种仿真器（VCS / Xcelium / Questa）
- ✅ 完整的 Makefile 编译脚本
- ✅ 遵循 GitHub 最佳实践

---

## 📚 学习路线图

### 30 天学习计划

| 周 | 内容 | 章节 |
|----|------|------|
| **第1周** | SystemVerilog 基础 | `01-sv-fundamentals/` |
| **第2周** | UVM 核心机制 | `02-uvm-phases/` - `06-configuration/` |
| **第3周** | UVM 高级特性 | `07-sequences-advanced/` - `08-reporting-messaging/` |
| **第4周** | 垂直领域 | `09-register-model-ral/` - `11-low-power-verification/` |

---

## 🚀 快速开始

### 环境要求

```bash
# 至少安装一个仿真器
- Synopsys VCS 2023+
- Cadence Xcelium 2023+
- Siemens Questa 2023+
```

### 克隆仓库

```bash
git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git
cd uvm-sv-cookbook
```

### 运行示例

```bash
# 进入章节目录
cd 01-sv-fundamentals/01-data-types

# 编译并运行
make

# 查看波形
make wave

# 清理
make clean
```

---

## 📁 目录结构概览

```
uvm-sv-cookbook/
├── 01-sv-fundamentals/         # SystemVerilog 基础
│   ├── 01-data-types/        ✅ 数据类型
│   ├── 02-procedural-blocks/ ✅ 过程块
│   ├── 03-interfaces/        ✅ 接口
│   ├── 04-classes-oop/       ✅ 面向对象
│   ├── 05-randomization/     ✅ 随机化
│   └── 06-threads-communication/ ✅ 线程通信
│
├── 02-uvm-phases/            # UVM 阶段机制
│   ├── 01-build-phase/       ✅ 构建阶段
│   ├── 02-connect-phase/    ✅ 连接阶段
│   ├── 03-end_of_elaboration/ ✅ elaboration
│   ├── 04-run-phase/         ✅ 运行阶段
│   ├── 05-report-phase/      ✅ 报告阶段
│   └── 06-final-phase/       ✅ 结束阶段
│
├── 03-uvm-components/        # UVM 组件体系
│   ├── 01-uvm_component/     ✅ 组件基类
│   ├── 02-uvm_env/           ✅ 环境容器
│   ├── 03-uvm_agent/         ✅ 代理
│   ├── 04-uvm_driver/        ✅ 驱动
│   ├── 05-uvm_monitor/       ✅ 监控
│   ├── 06-uvm_sequencer/     ✅ 仲裁器
│   └── 07-uvm_scoreboard/    ✅ 计分板
│
├── 04-uvm-transactions/       # 事务处理
│   ├── 01-uvm_sequence_item/ ✅ 事务项
│   ├── 02-uvm_sequence/      ✅ 序列
│   ├── 03-sequence-lib/      ✅ 序列库
│   ├── 04-virtual-sequences/ ✅ 虚拟序列
│   └── 05-sequence-arbitration/ ✅ 仲裁
│
├── 05-tlm-communication/      # TLM 通信
│   ├── 01-put-get-ports/     ✅ 阻塞传输
│   ├── 02-analysis-ports/    ✅ 广播
│   ├── 03-exports-imp/       ✅ 端口实现
│   └── 04-sockets/           ✅ 双向通信
│
├── 06-configuration/         # 配置机制
│   ├── 01-uvm_config_db/     ✅ 配置数据库
│   ├── 02-uvm_resource_db/   ✅ 资源数据库
│   ├── 03-factory-override/   ✅ 工厂机制
│   └── 04-config-object/     ✅ 配置对象
│
├── 07-sequences-advanced/     # 序列高级特性
│   ├── 01-sequence-hooks/    ✅ 钩子函数
│   ├── 02-response-handling/ ✅ 响应处理
│   ├── 03-pipelined-sequences/ ✅ 流水化
│   └── 04-error-injection/   ✅ 错误注入
│
├── 08-reporting-messaging/    # 报告与调试
│   ├── 01-uvm_report_handler/ ✅ 消息宏
│   ├── 02-log-files/         ✅ 日志管理
│   └── 03-coverage-collection/ ✅ 覆盖率
│
├── 09-register-model-ral/    # 寄存器模型
│   ├── 01-reg-block-basic/   ✅ RAL 基础
│   ├── 02-reg-access-methods/ ✅ 访问方法
│   ├── 03-reg-sequences/     ✅ 寄存器序列
│   ├── 04-reg-coverage/      ✅ 覆盖率
│   ├── 05-reg-irq-integration/ ✅ 中断集成
│   ├── 06-reg-reset/         ✅ 复位处理
│   ├── 07-reg-backdoor-access/ ✅ 后门访问
│   └── 08-reg-adapter-advanced/ ✅ 适配器
│
├── 10-interrupt-verification/ # 中断验证
│   ├── 01-interrupt-basics/  ✅ 中断基础
│   ├── 02-interrupt-agent/   ✅ 中断代理
│   ├── 03-interrupt-sequences/ ✅ 中断序列
│   ├── 04-interrupt-scoreboard/ ✅ 计分板
│   ├── 05-interrupt-priority/ ✅ 优先级
│   ├── 06-interrupt-regression/ ✅ 回归测试
│   └── 07-interrupt-to-ral/  ✅ RAL 集成
│
└── 11-low-power-verification/ # 低功耗验证
    ├── 01-power-domains-basics/ ✅ 电源域
    ├── 02-upf-simulation/    ✅ UPF 仿真
    ├── 03-power-controller-vip/ ✅ 电源控制
    ├── 04-power-state-transitions/ ✅ 状态转换
    ├── 05-isolation-check/  ✅ 隔离检查
    ├── 06-retention-registers/ ✅ 保持寄存器
    └── 07-power-aware-sequences/ ✅ 功耗序列

Legend: ✅ 已完成 (100%)
```

---

## 📊 项目统计

| 指标 | 数值 |
|------|------|
| 主章节 | 11 个 |
| 子章节 | 48 个 |
| 示例文件 | 50+ |
| 代码行数 | 10,000+ |
| 文档行数 | 5,000+ |

---

## 🎯 常见问题速查

| 问题 | 解决方案 |
|------|----------|
| 如何定义事务? | `04-uvm-transactions/01-uvm_sequence_item/` |
| 如何连接组件? | `02-uvm-phases/02-connect-phase/` |
| 如何配置组件? | `06-configuration/01-uvm_config_db/` |
| 如何发送序列? | `04-uvm-transactions/02-uvm_sequence/` |
| 如何做覆盖率? | `08-reporting-messaging/03-coverage-collection/` |
| 如何创建完整环境? | `03-uvm-components/02-uvm_env/` |
| 如何验证寄存器? | `09-register-model-ral/01-reg-block-basic/` |
| 如何处理中断? | `10-interrupt-verification/01-interrupt-basics/` |
| 如何做低功耗验证? | `11-low-power-verification/01-power-domains-basics/` |

---

## 🤝 贡献指南

欢迎贡献代码！

### 贡献步骤

1. Fork 本仓库
2. 创建分支 `git checkout -b feature/xxx`
3. 添加代码
4. 提交 `git commit -m "feat: xxx"`
5. 推送 `git push`
6. 发起 Pull Request

### 代码规范

- 使用 `.templates/SV_HEADER.txt` 作为文件头
- 使用 `.templates/Makefile_TEMPLATE` 作为 Makefile
- 使用 2 空格缩进
- 添加详细注释

参考 [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📚 参考资源

### 官方文档

- [UVM User Guide](https://www.accellera.org/images/downloads/standards/uvm/uvm_user_guide_1.2.pdf)
- [SystemVerilog LRM](https://ieeexplore.ieee.org/document/1800799)

### 在线教程

- [ChipVerify UVM](https://www.chipverify.com/)
- [Verification Academy](https://verificationacademy.com/)
- [AMIQ UVM Cookbook](https://www.amiq.com/)

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 👤 作者

**jingzhoushii**

- GitHub: [@jingzhoushii](https://github.com/jingzhoushii)
- Email: jingzhoushii@gmail.com

---

**快乐学习！🧪**

*灵感和 Python Cookbook 与 UVM User Guide*
