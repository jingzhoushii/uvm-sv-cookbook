# 01-data-types - SystemVerilog 数据类型

[![SV Version](https://img.shields.io/badge/SystemVerilog-2017-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

## 📚 知识点

本章节介绍 SystemVerilog 的核心数据类型，包括 2 态与 4 态类型的区别、数组、结构体、枚举等。

### 核心概念

| 类型 | 状态 | 初始值 | 典型用途 |
|------|------|--------|----------|
| `logic` | 4 态 (0/1/X/Z) | X | RTL 信号、总线 |
| `bit` | 2 态 (0/1) | 0 | 建模、计数器 |
| `int` | 2 态有符号 | 0 | 循环变量、计数 |
| `integer` | 4 态有符号 | X | 兼容 Verilog |
| `byte` | 2 态有符号 | 0 | 8 位整数 |

### 关键代码片段

#### 2 态 vs 4 态

```systemverilog
// 4态: 可以检测 X/Z 状态
logic [7:0] data_bus;  // 初始值: X
assign data_bus = 8'hZZ;  // 高阻态

// 2态: 更高效，不能表示 X/Z
bit [7:0] counter;  // 初始值: 0
```

#### 类型转换

```systemverilog
logic [7:0] l;
bit [7:0] b;

// 隐式转换 (值截断)
b = l;  // X/Z → 0

// 显式转换 (保持位宽)
b = bit'(l);
l = logic'(b);
```

#### 数组类型

```systemverilog
// 静态数组
bit [7:0] mem [0:255];  // 256 × 8-bit

// 多维数组
bit [3:0] matrix [4][4];  // 4×4 × 4-bit

// 动态数组
int dyn_arr[];  // 运行时分配大小
dyn_arr = new[10];  // 分配 10 个元素

// 关联数组
int assoc_arr[string];  // 字符串索引
assoc_arr["key"] = 42;
```

#### 结构体与枚举

```systemverilog
// 结构体: 组合相关数据
typedef struct packed {
    bit [7:0] opcode;
    bit [23:0] operand;
    bit [3:0]  func;
} instruction_t;

// 枚举: 命名常量
typedef enum logic [1:0] {
    IDLE  = 2'b00,
    READ  = 2'b01,
    WRITE = 2'b10
} state_t;
```

## 📂 文件结构

```
01-data-types/
├── README.md              # 本文档
├── Makefile              # 编译运行脚本
├── examples/            # 代码片段示例
│   ├── 01_basic_types.sv
│   ├── 02_arrays.sv
│   ├── 03_struct_enum.sv
│   └── 04_type_casting.sv
├── tb/                  # 测试平台
│   └── tb_data_types.sv
└── dut/                 # 被测设计
    └── simple_alu.sv    # 简单 ALU
```

## 🚀 快速开始

```bash
# 编译并运行
make

# 仅编译
make compile

# 查看波形
make waves

# 清理
make clean
```

### 仿真器支持

```bash
# VCS
make SIM=vcs

# Xcelium
make SIM=xrun

# Questa
make SIM=vsim
```

## ✅ 验证清单

- [ ] 理解 2 态 vs 4 态的区别
- [ ] 掌握各种数组类型的使用场景
- [ ] 熟悉 `typedef` 定义自定义类型
- [ ] 理解枚举的状态机应用

## 📖 参考资料

- [IEEE 1800-2017 SystemVerilog LRM](https://ieeexplore.ieee.org/document/1800799)
- [ChipVerify: SystemVerilog Data Types](https://www.chipverify.com/systemverilog/systemverilog-data-types)

## ❓ 思考题

1. 为什么 `logic` 初始值是 X，而 `bit` 初始值是 0？
2. 在什么情况下应该使用动态数组而不是静态数组？
3. 如何检测一个 `logic` 变量是否处于 X/Z 状态？
4. 结构体的 `packed` 和 `unpacked` 属性有什么区别？

## 👥 贡献者

[@jingzhoushii](https://github.com/jingzhoushii)

---

**Happy Learning! 🧪**
