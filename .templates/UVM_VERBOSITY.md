# UVM Verbosity 级别规范

## 统一标准

| 级别 | 常量 | 用法 |
|------|------|------|
| 调试 | `UVM_DEBUG` | 详细 trace |
| 高 | `UVM_HIGH` | 重要操作步骤 |
| 中 | `UVM_MEDIUM` | 常规信息 |
| 低 | `UVM_LOW` | 关键状态 |
| 禁用 | `UVM_NONE` | 静默 |

## 使用规范

```systemverilog
// ✅ 教学演示用 LOW
`uvm_info("DEMO", "关键信息", UVM_LOW)

// ✅ 调试信息用 MEDIUM
`uvm_info("DEBUG", "步骤1...", UVM_MEDIUM)

// ✅ 详细 trace 用 HIGH
`uvm_info("TRACE", "addr=0x%0h", UVM_HIGH)
```

## 错误级别

```systemverilog
// ✅ 警告
`uvm_warning("TAG", "message")

// ✅ 错误
`uvm_error("TAG", "message")

// ✅ 致命
`uvm_fatal("TAG", "message")
```

