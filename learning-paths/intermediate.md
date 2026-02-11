# 🛠️ 中级路径（4周）

## 目标

掌握寄存器模型、TLM 通信、覆盖率收集，能独立开发验证平台。

## 预计时间

- **总时长**: 约 40-60 小时
- **每周**: 10-15 小时
- **每日**: 1-2 小时

## 前置要求

| 要求 | 说明 |
|------|------|
| 初级路径完成 | SystemVerilog + UVM 基础 |
| 理解事务 | 了解验证平台结构 |
| 英语阅读 | 能读技术文档 |

## 学习顺序

### Week 1: 寄存器模型 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 1-2 | [09-register-model-ral/01-reg-block](../09-register-model-ral/01-reg-block/) | 4h | 寄存器块、域 |
| Day 3-4 | [09-register-model-ral/02-reg-adapter](../09-register-model-ral/02-reg-adapter/) | 4h | 适配器、前门/后门访问 |
| Day 5-7 | [09-register-model-ral/03-reg-sequence](../09-register-model-ral/03-reg-sequence/) | 6h | 寄存器序列、预测 |

### Week 2: 高级序列 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 8-9 | [03-sequences/02-virtual-sequences](../03-sequences/02-virtual-sequences/) | 4h | Virtual Sequence |
| Day 10-11 | [04-configuration/01-config-db](../04-configuration/01-uvm_config_db/) | 4h | 配置数据库 |
| Day 12-14 | [05-tlm-communication/01-tlm-basics](../05-tlm-communication/01-tlm-basics/) | 6h | TLM 端口、传输 |

### Week 3: TLM 高级 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 15-17 | [05-tlm-communication/02-analysis-ports](../05-tlm-communication/02-analysis-ports/) | 5h | Analysis Port |
| Day 18-19 | [05-tlm-communication/03-tlm-fifos](../05-tlm-communication/03-tlm-fifos/) | 4h | TLM FIFO |
| Day 20-21 | [06-tlm-2-standard/01-introduction](../06-tlm-2-standard/01-introduction/) | 4h | TLM 2.0 基础 |

### Week 4: 覆盖率 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 22-24 | [08-coverage/01-basic-coverage](../08-coverage/01-basic-coverage/) | 5h | Coverage 基础 |
| Day 25-27 | [08-coverage/02-cross-coverage](../08-coverage/02-cross-coverage/) | 5h | 交叉覆盖率 |
| Day 28 | [Mini SoC 项目](../projects/mini_soc/) | 4h | 综合应用 |

## 核心知识点

### 寄存器模型

```systemverilog
class my_reg_block extends uvm_reg_block;
    rand uvm_reg_field ctrl;
    rand uvm_reg_field data;
    
    function void build();
        ctrl = uvm_reg_field::type_id::create("ctrl");
        ctrl.configure(this, 8, 0, "RW", 0, 'h00, 1, 0);
        
        data = uvm_reg_field::type_id::create("data");
        data.configure(this, 8, 8, "RO", 0, 'h00, 1, 0);
        
        add_reg("ctrl", ctrl, "h00");
        add_reg("data", data, "h04");
        
        lock_model();
    endfunction
endclass
```

### Virtual Sequence

```systemverilog
class sys_vseq extends uvm_virtual_sequence;
    `uvm_object_utils(sys_vseq)
    
    bus_seq bus_s;
    uart_seq uart_s;
    dma_seq dma_s;
    
    virtual task body();
        fork
            bus_s.start(p_sequencer.bus_sqr);
            uart_s.start(p_sequencer.uart_sqr);
            dma_s.start(p_sequencer.dma_sqr);
        join
    endtask
endclass
```

### 覆盖率

```systemverilog
class bus_cov extends uvm_subscriber#(bus_trans);
    covergroup cg;
        ADDR: coverpoint tr.addr {
            bins KB[] = {[0:'h1000]};
            bins MB[] = {['h1001:$]};
        }
        RW: coverpoint tr.is_read;
        ADDR_RW: cross ADDR, RW;
    endgroup
    
    virtual function void write(T t);
        void'(cg.sample());
    endfunction
endclass
```

## 实践项目

增强 Mini SoC Agent：

```
要求:
├── 完善寄存器模型
├── 实现 Virtual Sequence
├── 添加覆盖率收集
├── 编写回归测试
└── 生成覆盖率报告
```

## 检查清单

- [ ] 掌握寄存器模型
- [ ] 理解 TLM 通信
- [ ] 能编写 Virtual Sequence
- [ ] 能收集功能覆盖率
- [ ] 完成实践项目

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 寄存器访问失败 | 检查适配器 |
| 覆盖率不涨 | 检查 write() 调用 |
| 序列不同步 | 使用 fork/join |

## 下一步

完成中级路径后，进入 [高级路径](advanced.md)。

## 资源

- [UVM 官方文档](https://verificationacademy.com/)
- [寄存器验证指南](https://verificationacademy.com/uvm/reg/)
