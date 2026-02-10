# 01-uvm_sequence_item - UVM 事务项

## 📚 知识点

- **uvm_sequence_item** 定义和使用
- **`uvm_object_utils** 注册宏
- **`uvm_field_***` 字段宏
- **约束**（constraint）
- **Copy/Compare/Print**

## 📖 背景知识

### 什么是事务项？

事务项是 UVM 中的最小数据单元：

```
Transaction (事务)
├── Address (地址)
├── Data (数据)
├── Control (控制信号)
└── ... (协议相关字段)
```

### 与 uvm_transaction 的区别

| 特性 | uvm_transaction | uvm_sequence_item |
|------|-----------------|-------------------|
| 基类 | 是 | 是 |
| 序列支持 | ❌ | ✅ |
| 字段宏 | ❌ | ✅ |
| 推荐使用 | 不推荐 | **推荐** |

## 📂 文件结构

```
01-uvm_sequence_item/
├── README.md
├── Makefile
└── examples/
    └── 01_sequence_item.sv    # 完整示例
```

## 🔍 代码导读

### 基础事务项

```systemverilog
class bus_txn extends uvm_sequence_item;
    // 随机字段
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        rw;        // 0=read, 1=write
    
    // 约束
    constraint addr_range {
        addr inside {[32'h0000_0000 : 32'h0FFF_FFFF]};
    }
    
    // 工厂注册
    `uvm_object_utils_begin(bus_txn)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw, UVM_ALL_ON)
    `uvm_object_utils_end
    
    // 构造函数
    function new(string name = "bus_txn");
        super.new(name);
    endfunction
endclass
```

### 使用事务项

```systemverilog
// 创建
bus_txn txn;
txn = bus_txn::type_id::create("txn");

// 随机化
void'(txn.randomize());

// 复制
bus_txn copy;
copy = txn.copy();

// 比较
if (txn.compare(copy)) begin
    `uvm_info("COMPARE", "Match!", UVM_LOW)
end

// 打印
txn.print();
```

## 🚀 快速开始

```bash
cd 04-uvm-transactions/01-uvm_sequence_item
make
```

## 💡 示例说明

### 01_sequence_item.sv

1. **basic_transaction** - 基础事务项
2. **constrained_transaction** - 带约束的事务项
3. **burst_transaction** - BURST 事务项
4. **测试** - Copy/Compare/Print 演示

## 📝 练习题

1. **练习 1**：添加字节使能（byte enable）字段
2. **练习 2**：实现原子操作事务（read-modify-write）
3. **练习 3**：添加事务延迟控制

## 📚 参考资料

- [UVM User Guide - Sequence Items](https://www.accellera.org/)
- [ChipVerify - Sequence Item](https://www.chipverify.com/uvm/uvm-sequence-item)

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../README) | [下一章节](../02-uvm_sequence)
