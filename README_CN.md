# UVM-SV Cookbook (中文)

## 介绍

UVM-SV Cookbook 是一个通过可运行代码片段学习 SystemVerilog 和 UVM 的教程仓库。

## 为什么叫 Cookbook?

就像《Python Cookbook》一样，这是一个"按图索骥、即查即用"的参考手册。

每个章节都包含：
- ✅ 可运行的代码
- ✅ 详细的中文注释
- ✅ 关键概念讲解
- ✅ 思考题

## 学习路径

### 第1周: SystemVerilog 基础

| 天数 | 内容 | 示例 |
|------|------|------|
| Day 1-2 | 数据类型 | `01-data-types/` |
| Day 3 | 过程块 | `02-procedural-blocks/` |
| Day 4-5 | 接口 | `03-interfaces/` |
| Day 6-7 | 面向对象 | `04-classes-oop/` |

### 第2周: UVM 基础

| 天数 | 内容 | 示例 |
|------|------|------|
| Day 8-9 | 阶段机制 | `02-uvm-phases/` |
| Day 10-12 | 组件体系 | `03-uvm-components/` |
| Day 13-14 | 事务处理 | `04-uvm-transactions/` |

### 第3周: UVM 进阶

| 天数 | 内容 | 示例 |
|------|------|------|
| Day 15-17 | TLM通信 | `05-tlm-communication/` |
| Day 18-20 | 配置机制 | `06-configuration/` |
| Day 21-22 | 序列高级 | `07-sequences-advanced/` |

### 第4周: 实战

| 天数 | 内容 | 示例 |
|------|------|------|
| Day 23-26 | 综合实战 | `09-integrated-examples/` |
| Day 27-30 | 方法学 | `10-methodology/` |

## 快速开始

```bash
# 克隆仓库
git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git
cd uvm-sv-cookbook

# 运行第一个示例
cd 01-sv-fundamentals/01-data-types
make

# 查看波形
make waves
```

## 环境要求

- VCS 2023+ / Xcelium / Questa
- UVM 1.2 (IEEE 1800.2-2021)

## 贡献

欢迎提交 Pull Request! 参考 [CONTRIBUTING.md](CONTRIBUTING.md)

## 许可证

MIT License

## 作者

GitHub: [@jingzhoushii](https://github.com/jingzhoushii)

---

**Happy Learning! 🧪**
