# Regression Test Framework

## 概述

回归测试框架用于批量运行所有章节的测试。

## 使用方法

```bash
# 运行所有测试
./run.py

# 运行特定章节
./run.py --chapter 01-data-types

# 指定仿真器
./run.py --sim vcs

# 只编译
./run.py --compile-only

# 帮助
./run.py --help
```

## 结构

```
regress/
├── run.py           # 主脚本
├── config.py        # 配置
├── chapters.csv     # 章节列表
└── reports/        # 测试报告
```
