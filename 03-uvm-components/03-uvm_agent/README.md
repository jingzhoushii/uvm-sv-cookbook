# 03-uvm_agent - UVM 代理

## 📚 知识点

- **UVM Agent** 的作用和结构
- **Active/ Passive** 模式
- **Driver-Monitor-Sequencer** 协作
- **Agent 配置**（is_active）

## 📖 背景知识

### 什么是 Agent？

Agent 是 UVM 验证 IP（VIP）的封装单元，包含：

```
Agent
├── Sequencer    # 序列仲裁和发送
├── Driver       # 将事务转换为信号
└── Monitor      # 监测信号转换为事务
```

### Active vs Passive

| 模式 | Driver | Sequencer | Monitor | 用途 |
|------|--------|-----------|---------|------|
| **Active** | ✅ | ✅ | ✅ | 主控验证 |
| **Passive** | ❌ | ❌ | ✅ | 只做监控 |

```systemverilog
class my_agent extends uvm_agent;
    uvm_active_passive_enum is_active;
    
    virtual function void build_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            driver = my_driver::type_id::create("driver", this);
            sequencer = my_sequencer::type_id::create("sequencer", this);
        end
        monitor = my_monitor::type_id::create("monitor", this);
    endfunction
endclass
```

## 📂 文件结构

```
03-uvm_agent/
├── README.md
├── Makefile
└── examples/
    └── 01_simple_agent.sv    # 完整 Agent 示例
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
        // 获取配置
        if (!uvm_config_db#(axi_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("NO_CFG", "Cannot get config")
        end
        
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
make
```

## 💡 示例说明

### 01_simple_agent.sv

完整的 Agent 实现，包含：

1. **配置类** (`axi_config`)
2. **Driver** - `drive_txn()` 任务
3. **Monitor** - `sample_bus()` 任务
4. **Sequencer** - 标准仲裁
5. **Agent** - 组装所有组件

## 📝 练习题

1. **练习 1**：添加 `is_active` 配置控制
2. **练习 2**：添加多个 Agent 的互联
3. **练习 3**：实现 Agent 的自定义配置

## 📚 参考资料

- [UVM Agent Cookbook](https://www.amiq.com/consulting/2014/02/06/the-verification-agent/)
- [Verification Academy - Agent](https://verificationacademy.com/cookbook/agents)

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../02-uvm_env) | [下一章节](../04-uvm_driver)
