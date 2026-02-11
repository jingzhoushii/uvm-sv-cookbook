# 常见错误速查表

## 编译错误

| 错误 | 原因 | 解决 |
|------|------|------|
| super.new() 在类外 | super 只能在类内部 | 移到类内部 |
| 未定义变量 | 拼写错误或未声明 | 检查拼写 |
| 端口不匹配 | 模块端口名不一致 | 核对端口名 |

## 运行时错误

| 错误 | 原因 | 解决 |
|------|------|------|
| Objection not raised | run_phase 未提起 objection | 添加 phase.raise_objection |
| Factory 创建失败 | 未使用 type_id::create | 改用 factory |

## UVM Phase 调试

```systemverilog
// 在 end_of_elaboration_phase 打印组件结构
print_topology();
```

