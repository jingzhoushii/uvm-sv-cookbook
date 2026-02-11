# 🛤️ 学习路径

## 概述

本项目提供完整的学习路径，从 SystemVerilog 基础到 UVM 专家级别。

```mermaid
graph LR
    A[初级 2周] --> B[中级 4周]
    B --> C[高级 6周]
    C --> D[专家 8周]
```

## 路径对比

| 路径 | 周期 | 难度 | 目标 |
|------|------|------|------|
| ⚡ 初级 | 2 周 | ⭐ | 掌握基础 |
| 🛠️ 中级 | 4 周 | ⭐⭐ | 独立开发 |
| 🏗️ 高级 | 6 周 | ⭐⭐⭐ | 复杂验证 |
| 🎓 专家 | 8 周 | ⭐⭐⭐⭐ | 架构设计 |

## 推荐路径

### 初级路径（2周）

**目标**: 掌握 SystemVerilog 和 UVM 基础

```
Week 1: SystemVerilog 基础
├── 01-data-types/
├── 02-classes-oop/
├── 03-interfaces/
└── 04-threads-communication/

Week 2: UVM 组件
├── 01-uvm-basics/
├── 02-uvm-components/
├── 03-sequences/
└── 04-simple-agent/
```

[开始初级路径 →](primary.md){ .md-button }

### 中级路径（4周）

**目标**: 掌握寄存器模型、序列、TLM、覆盖率

```
Week 1: 寄存器模型
├── 09-register-model-ral/
└── 10-reg-sequence/

Week 2: 高级序列
├── 03-sequences/
└── 04-virtual-sequences/

Week 3: TLM 通信
├── 05-tlm-communication/
└── 06-tlm-fifos/

Week 4: 覆盖率
└── 08-coverage/
```

[开始中级路径 →](intermediate.md){ .md-button }

### 高级路径（6周）

**目标**: 掌握低功耗、中断、形式验证、性能优化

```
Week 1-2: 低功耗验证
└── 11-low-power/

Week 3-4: 中断验证
└── 12-interrupt/

Week 5: 形式验证
└── 13-formal-verification/

Week 6: 性能优化
└── 14-performance/
```

[开始高级路径 →](advanced.md){ .md-button }

### 专家路径（8周）

**目标**: UVM 源码分析、自定义库开发

```
Week 1-2: UVM 源码分析
└── 15-uvm-source/

Week 3-4: 自定义库开发
└── 16-uvm-extensions/

Week 5-6: UVM 1800.2
└── 16-uvm-1800-2-changes/

Week 7-8: 项目重构
└── Mini SoC 项目实战
```

[开始专家路径 →](expert.md){ .md-button }

## 学习建议

| 建议 | 说明 |
|------|------|
| 按顺序学习 | 每个路径有前置依赖 |
| 动手实践 | 每章都有示例代码 |
| 项目驱动 | 最后做 Mini SoC |
| 持续迭代 | 多次复习 |

## 项目实战

完成学习后，建议实战：

- [Mini SoC 项目](../projects/mini_soc/)
- [UVM 源码分析](15-uvm-source/)
- [自定义验证库](16-uvm-extensions/)

## FAQ

**Q: 我应该从哪个路径开始？**
A: 如果你是初学者，从初级路径开始。如果有经验，评估后选择合适的路径。

**Q: 每个路径需要多少时间？**
A: 每周约 10-15 小时，取决于个人基础。

**Q: 可以跳过某些章节吗？**
A: 可以，但建议按顺序学习以建立完整知识体系。

**Q: 如何验证学习效果？**
A: 完成 Mini SoC 项目并通过回归测试。

## 相关资源

- [GitHub](https://github.com/jingzhoushii/uvm-sv-cookbook)
- [EDA Playground](https://edaplayground.com/)
- [Verification Academy](https://verificationacademy.com/)
