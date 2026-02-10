# 03-uvm_agent - UVM 代理

## 📚 知识点

- **UVM Agent** 的作用和结构
- **Active/Passive** 模式
- **Driver-Monitor-Sequencer** 协作
- **Agent 配置**（is_active）

## 📖 背景知识

### 什么是 Agent？

Agent 是 UVM 验证 IP（VIP）的封装单元：

```
Agent (axi_agent)
├── Sequencer (axi_sequencer)  # 序列仲裁
├── Driver (axi_driver)          # 信号驱动
└── Monitor (axi_monitor)       # 信号采样
```

### Active vs Passive

| 模式 | Driver | Sequencer | Monitor | 用途 |
|------|--------|-----------|---------|------|
| **Active** | ✅ | ✅ | ✅ | 主控验证 |
| **Passive** | ❌ | ❌ | ✅ | 只做监控 |

## 📂 文件结构

```
03-uvm_agent/
├── README.md              # 本文档
├── Makefile              # 完整编译脚本 ✅
├── axi_if.sv            # 接口定义 ✅
├── axi_config.sv        # 配置类 ✅
├── axi_transaction.sv    # 事务项 ✅
├── axi_sequencer.sv     # 仲裁器 ✅
├── axi_driver.sv        # 驱动 ✅
├── axi_monitor.sv        # 监控 ✅
├── axi_agent.sv          # 代理 ✅
├── axi_scoreboard.sv     # 计分板 ✅
├── axi_env.sv           # 环境 ✅
├── axi_base_seq.sv       # 基础序列 ✅
├── axi_write_seq.sv      # 写序列 ✅
└── tests/
    └── base_test.sv     # 测试用例 ✅
```

## 🔍 代码导读

### Agent 结构

```systemverilog
class axi_agent extends uvm_agent;
    axi_config cfg;
    axi_driver    drv;
    axi_sequencer sqr;
    axi_monitor   mon;
    
    virtual function void build_phase(uvm_phase phase);
        // 根据 is_active 创建组件
        if (cfg.is_active == UVM_ACTIVE) begin
            drv = axi_driver::type_id::create("drv", this);
            sqr = axi_sequencer::type_id::create("sqr", this);
        end
        mon = axi_monitor::type_id::create("mon", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        // 连接 Driver 到 Sequencer
        if (cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction
endclass
```

## 🚀 快速开始

```bash
cd 03-uvm-components/03-uvm_agent

# VCS
make SIM=vcs

# Xcelium  
make SIM=xrun

# Questa
make SIM=vsim

# 清理
make clean
```

## 💡 示例说明

### 完整 AXI Agent

包含所有组件的完整实现：
- ✅ AXI4-Lite 协议支持
- ✅ 配置类（is_active, num_transactions）
- ✅ 事务项（AW/AR/W/R/B 通道）
- ✅ Driver（信号驱动）
- ✅ Monitor（事务采样）
- ✅ Sequencer（序列仲裁）
- ✅ Scoreboard（结果比较）
- ✅ Environment（环境组装）
- ✅ 基础序列和写序列

## 📝 练习题

1. **练习 1**：添加 AXI4 Full 支持（burst）
2. **练习 2**：实现 Response 处理
3. **练习 3**：添加 Coverage 模型

## 📚 参考资料

- [UVM Agent Cookbook](https://www.amiq.com/consulting/2014/02/06/the-verification-agent/)
- [Verification Academy - Agent](https://verificationacademy.com/cookbook/agents)
- [AXI Protocol Specification](https://developer.arm.com/documentation/ihi0022/latest/)

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../02-uvm_env) | [下一章节](../04-uvm_driver)
