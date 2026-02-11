# Factory 基础

## 核心概念

UVM Factory 是对象创建系统，允许运行时替换类型。

## create vs new

```systemverilog
// ❌ 错误：直接使用 new
my_driver d = new();

// ✅ 正确：使用 factory
my_driver d = my_driver::type_id::create("d", this);
```

## 优势

1. 类型替换（无需修改代码）
2. 组件注册
3. 调试跟踪
