# SVA 基础

## 断言类型

### 立即断言
```systemverilog
assert (a < b) else $error("a >= b");
```

### 并行断言
```systemverilog
assert property (@(posedge clk) a |-> b);
```

## 常用操作符

| 操作符 | 含义 |
|--------|------|
| `|->` | 蕴含（Implication） |
| `|=>` | 延迟蕴含 |
| `##n` | 延迟 n 个周期 |
| `[*n]` | 重复 n 次 |
| `[=n]` | 至少 n 次 |

