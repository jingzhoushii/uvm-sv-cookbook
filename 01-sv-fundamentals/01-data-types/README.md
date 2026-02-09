# 01-data-types - SystemVerilog 数据类型

## 知识点

本章节介绍 SystemVerilog 的基本数据类型：

| 类型 | 说明 | 状态 |
|------|------|------|
| `logic` | 4态逻辑 (0/1/X/Z) | ✅ |
| `bit` | 2态整数 | ✅ |
| `int` | 32位有符号整数 | ✅ |
| `struct` | 结构体 | ✅ |
| `enum` | 枚举类型 | ✅ |
| `string` | 字符串 | ✅ |

## 关键概念

### 2态 vs 4态

```systemverilog
// 4态: 可以是 0, 1, X, Z
logic [7:0] data;  // 初始值: X

// 2态: 只能是 0, 1
bit [7:0] counter; // 初始值: 0
```

### 类型转换

```systemverilog
logic [7:0] l;
bit [7:0] b;

// 隐式转换
b = l;  // X/Z 变为 0

// 显式转换
b = bit'(l);
```

## 运行示例

```bash
make
```

## 文件结构

```
01-data-types/
├── README.md
├── Makefile
├── tb/
│   └── tb_data_types.sv
└── dut/
    └── alu.sv
```

## 思考题

1. 为什么 `logic` 初始值是 X，而 `bit` 初始值是 0？
2. 什么时候应该使用 `logic` 而不是 `bit`？
3. 如何在仿真中检测 X/Z 状态？
