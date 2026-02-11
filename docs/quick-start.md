# ⚡ 快速开始

## 环境要求

| 工具 | 版本 | 说明 |
|------|------|------|
| VCS / QuestaSim | 2023+ | SystemVerilog 仿真器 |
| Python | 3.8+ | 回归脚本 |
| Git | 2.0+ | 版本控制 |

## 安装步骤

### 1. 克隆项目

```bash
git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git
cd uvm-sv-cookbook
```

### 2. 设置环境

```bash
# 设置 UVM_HOME
export UVM_HOME=$(pwd)/uvm

# 可选: 设置仿真器路径
export VCS_HOME=/path/to/vcs
```

### 3. 运行第一个测试

```bash
cd projects/mini_soc
make          # 编译
make run TEST=smoke_test  # 运行冒烟测试
```

## 📺 在线运行

点击下方按钮在 EDA Playground 中运行：

[![EDA Playground](https://img.shields.io/badge/EDA-Playground-blue)](https://edaplayground.com/)

## 下一步

- [第一个测试](first-test.md)
- [学习路径选择](projects/learning-paths.md)
- [Mini SoC 项目](projects/mini_soc/index.md)

---

**提示**: 遇到问题？请查看 [FAQ](faq.md) 或在 GitHub 提 Issue。
