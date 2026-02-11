# ⚡ 初级路径（2周）

## 目标

掌握 SystemVerilog 基础和 UVM 组件，能够搭建简单验证平台。

## 预计时间

- **总时长**: 约 20-30 小时
- **每周**: 10-15 小时
- **每日**: 1-2 小时

## 前置要求

| 要求 | 说明 |
|------|------|
| 编程基础 | 了解一种编程语言 |
| 数字电路 | 了解基本概念 |
| 验证概念 | 了解验证重要性 |

## 学习顺序

### Week 1: SystemVerilog 基础 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 1-2 | [01-data-types](../01-sv-fundamentals/01-data-types/) | 3h | 数据类型、枚举、结构体 |
| Day 3-4 | [02-classes-oop](../01-sv-fundamentals/02-classes-oop/) | 4h | 类、对象、继承 |
| Day 5 | [03-interfaces](../01-sv-fundamentals/03-interfaces/) | 2h | 接口、modport |
| Day 6-7 | [04-threads-communication](../01-sv-fundamentals/04-threads-communication/) | 3h | fork/join、事件、邮箱 |

### Week 2: UVM 组件 📅

| 天数 | 章节 | 预计时间 | 内容 |
|------|------|----------|------|
| Day 8-9 | [01-uvm-basics](../02-uvm-basics/01-basics/) | 3h | UVM 架构、宏、工厂 |
| Day 10-11 | [02-uvm-components](../02-uvm-basics/02-components/) | 4h | Agent、Monitor、Driver |
| Day 12-13 | [03-sequences](../03-sequences/01-sequences/) | 3h | Sequence、Sequencer |
| Day 14 | [04-simple-agent](../03-sequences/02-agent/) | 2h | 完整 Agent 示例 |

## 核心知识点

### SystemVerilog

```systemverilog
// 数据类型
bit [31:0] addr;
logic [7:0] data;
enum {IDLE, BUSY} state;

// 类
class transaction;
    rand bit [31:0] addr;
    rand bit [7:0] data;
endclass

// 接口
interface bus_if;
    logic [31:0] addr;
    logic [7:0] data;
endinterface
```

### UVM

```systemverilog
// 组件
class my_driver extends uvm_driver#(trans);
    `uvm_component_utils(my_driver)
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask
endclass

// 序列
class my_sequence extends uvm_sequence#(trans);
    `uvm_object_utils(my_sequence)
    
    virtual task body();
        repeat(10) begin
            trans req;
            `uvm_do(req)
        end
    endtask
endclass
```

## 实践项目

完成一个简单的 Bus Agent：

```
要求:
├── 事务: addr, data, is_read
├── Driver: 驱动事务
├── Monitor: 监测事务
├── Sequencer: 生成事务
└── Agent: 组装组件
```

## 检查清单

- [ ] 理解 SystemVerilog OOP
- [ ] 掌握 UVM 组件层次
- [ ] 能编写简单序列
- [ ] 理解 TLM 通信
- [ ] 完成实践项目

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 宏不工作 | 确保 `include `uvm_macros.svh |
| 工厂未生效 | 检查 type_id::create |
| 序列不运行 | 检查 start() 调用 |

## 下一步

完成初级路径后，进入 [中级路径](intermediate.md)。

## 资源

- [EDA Playground](https://edaplayground.com/)
- [SystemVerilog LRM](https://ieee.org/)
