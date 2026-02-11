# Industrial Scoreboard - 工业化计分板

## 概述

工业级 Scoreboard 结构，包含多种匹配模式和参考模型。

## Scoreboard 类型

| 类型 | 说明 |
|------|------|
| queue-based | 队列匹配 |
| ID-based | 基于 ID 匹配 |
| out-of-order | 乱序事务匹配 |

## 工业级架构

```
driver → DUT → monitor → scoreboard
              ↑
         ref_model (参考模型)
```

