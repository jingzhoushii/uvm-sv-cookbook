# 🎓 专家路径（8周）

## 目标

深入理解 UVM 源码，能开发自定义验证库，具备架构设计能力。

## 预计时间

- **总时长**: 约 80-120 小时
- **每周**: 10-15 小时
- **每日**: 1-2 小时

## 前置要求

| 要求 | 说明 |
|------|------|
| 高级路径完成 | 完整验证知识体系 |
| 多年经验 | 至少 2-3 年验证经验 |
| 英语流利 | 能阅读源码 |

## 学习顺序

### Week 1-2: UVM 源码分析 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 1-3 | [15-uvm-source/01-factory](../15-uvm-source/01-factory/) | 8h | 工厂机制源码 |
| Day 4-6 | [15-uvm-source/02-phases](../15-uvm-source/02-phases/) | 8h | 相位机制源码 |
| Day 7-10 | [15-uvm-source/03-tlm](../15-uvm-source/03-tlm/) | 8h | TLM 实现源码 |
| Day 11-14 | [15-uvm-source/04-uvm-1800-2](../15-uvm-source/04-uvm-1800-2/) | 8h | 1800.2 变更分析 |

### Week 3-4: 自定义库开发 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 15-17 | [16-uvm-extensions/01-custom-components](../16-uvm-extensions/01-custom-components/) | 8h | 自定义组件基类 |
| Day 18-20 | [16-uvm-extensions/02-custom-sequences](../16-uvm-extensions/02-custom-sequences/) | 8h | 自定义序列库 |
| Day 21-24 | [16-uvm-extensions/03-custom-report](../16-uvm-extensions/03-custom-report/) | 8h | 自定义报告系统 |
| Day 25-28 | [16-uvm-extensions/04-custom-config](../16-uvm-extensions/04-custom-config/) | 8h | 自定义配置 |

### Week 5-6: UVM 1800.2 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 29-31 | [16-uvm-1800-2-changes/01-virtual-class](../16-uvm-1800-2-changes/01-virtual-class/) | 6h | 虚拟类层次 |
| Day 32-34 | [16-uvm-1800-2-changes/02-new-features](../16-uvm-1800-2-changes/02-new-features/) | 6h | 新特性详解 |
| Day 35-37 | [16-uvm-1800-2-changes/03-migration-guide](../16-uvm-1800-2-changes/03-migration-guide/) | 6h | 迁移指南 |
| Day 38-42 | [16-uvm-1800-2-changes/04-version-comparison](../16-uvm-1800-2-changes/04-version-comparison/) | 8h | 版本对比 |

### Week 7-8: 项目重构 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 43-46 | [Mini SoC 重构](../projects/mini_soc/refactor/) | 16h | 重构 Mini SoC |
| Day 47-50 | [架构设计文档](../projects/mini_soc/architecture.md) | 8h | 编写架构文档 |
| Day 51-56 | [技术分享准备](../docs/architecture/) | 12h | 准备技术分享 |

## 核心知识点

### UVM 源码分析

```systemverilog
// 工厂源码关键点
// uvm_factory.sv
class uvm_factory;
    // 注册表
    protected uvm_registry_table m_table;
    
    // 创建对象
    function uvm_object create_object_by_type(...);
        // 查找并创建
    endfunction
    
    // 覆盖
    function void set_inst_override(...);
        // 添加覆盖规则
    endfunction
endclass
```

### 自定义库开发

```systemverilog
// 自定义组件基类
class my_base_component extends uvm_component;
    `uvm_component_utils(my_base_component)
    
    // 通用功能
    protected int m_log_level = UVM_LOW;
    
    // 日志增强
    virtual function void log(string msg);
        `uvm_info(get_name(), msg, m_log_level)
    endfunction
    
    // 统计
    protected int m_transaction_count = 0;
endclass
```

### 架构设计

```systemverilog
// 平台架构模式
class soc_platform_env extends uvm_env;
    // 分层架构
    agent_layer agents;
    checker_layer checkers;
    coverage_layer coverage;
    
    // 动态配置
    virtual function void configure();
        // 根据配置动态组装
    endfunction
endclass
```

## 实践项目

1. **UVM 源码笔记**: 整理 UVM 核心源码笔记
2. **自定义验证库**: 开发公司内部验证库
3. **Mini SoC 重构**: 完全重构 Mini SoC
4. **技术分享**: 准备 1 小时技术分享

## 检查清单

- [ ] 理解 UVM 核心机制
- [ ] 能开发自定义库
- [ ] 掌握 UVM 1800.2
- [ ] 具备架构设计能力
- [ ] 能进行技术分享

## 认证建议

完成专家路径后，可考虑：

- [ ] Accellera UVM 认证
- [ ] VCS 认证工程师
- [ ] Formal 认证

## 职业发展

| 方向 | 说明 |
|------|------|
| 验证架构师 | 设计验证平台 |
| 验证专家 | 解决复杂问题 |
| 技术经理 | 团队技术领导 |
| 培训师 | UVM 培训 |

## 资源

- [UVM 源码](https://github.com/accellera-official/uvm)
- [IEEE 1800.2](https://ieeexplore.ieee.org/)
- [Verification Academy](https://verificationacademy.com/)
