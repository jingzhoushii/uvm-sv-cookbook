# Phase 4 + 5: Scoreboard + Coverage + Regression 闭环

## Phase 4: Scoreboard & Reference Model

### 完整 Scoreboard
| 组件 | 文件 | 说明 |
|------|------|------|
| soc_scoreboard | tb/env/soc_scoreboard.sv | 完整计分板 |

### Scoreboard 功能
- Bus 事务对比
- Queue-based 匹配
- 统计报告
- 自动 Pass/Fail

### 覆盖率模型
| 组件 | 文件 | 说明 |
|------|------|------|
| soc_coverage_model | coverage/soc_coverage_model.sv | 完整覆盖率 |

### Coverage Groups
- Address Coverage (按地址范围分组)
- Data Coverage (zero/max/random)
- Read/Write Coverage
- Cross Coverage

---

## Phase 5: Regression 闭环

### 回归配置
| 文件 | 说明 |
|------|------|
| regress_full.yaml | 完整回归配置 |
| run_regress_full.py | 完整回归脚本 |

### 测试套件
| 套件 | 测试 | 说明 |
|------|------|------|
| smoke | 1 | 冒烟 |
| basic | 3 | 基础功能 |
| peripheral | 2 | 外设 |
| stress | 2 | 压力 |
| system | 2 | 系统 |
| full | 9 | 完整 |

### 运行回归
```bash
# CI 模式 (smoke)
python3 regress/run_regress_full.py ci

# Daily 模式
python3 regress/run_regress_full.py daily

# Nightly 模式
python3 regress/run_regress_full.py nightly

# Weekly 模式
python3 regress/run_regress_full.py weekly

# Full 回归
python3 regress/run_regress_full.py release
```

### 报告示例
```
Report: logs_20260211_214500/report.html
Total: 9, Passed: 9, Failed: 0
Pass Rate: 100.0%
```

---

## 完整测试列表

| # | 测试 | 说明 | 状态 |
|---|------|------|-------|
| 1 | smoke_test | 冒烟测试 | ✅ |
| 2 | random_test | 随机测试 | ✅ |
| 3 | mem_test | 存储器测试 | ✅ |
| 4 | dma_test | DMA 测试 | ✅ |
| 5 | uart_test | UART 测试 | ✅ |
| 6 | stress_test | 压力测试 | ✅ |
| 7 | concurrent_test | 并发测试 | ✅ |
| 8 | system_test | 系统测试 | ✅ |
| 9 | boot_enh_test | 引导测试 | ✅ |

---

## 覆盖率目标

| 覆盖率类型 | 目标 |
|------------|------|
| Address | 80% |
| Data | 60% |
| Read/Write | 90% |
| Overall | 75% |

