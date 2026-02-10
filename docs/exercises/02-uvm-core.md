# 📝 UVM 核心练习题

## Level 1：UVM 基础（10 题）

### 练习 1：创建组件
创建包含 build/connect/run/report 阶段的组件。

### 练习 2：配置传递
使用 uvm_config_db 传递配置到组件。

### 练习 3：Objection
实现 raise_objection 和 drop_objection。

### 练习 4：Sequence Item
定义带约束的 Transaction。

### 练习 5：Sequence
创建发送 10 个 Transaction 的序列。

### 练习 6：Driver
实现从 Sequence 获取并驱动 Transaction。

### 练习 7：Monitor
实现采样总线并生成 Transaction。

### 练习 8：Agent
组装 Driver+Monitor+Sequencer。

### 练习 9：Analysis Port
实现 Monitor 到 Scoreboard 的连接。

### 练习 10：Environment
组装 Agent+Scoreboard+Agent。

---

## Level 2：UVM 进阶（5 题）

### 练习 11：Virtual Sequence
实现控制多个 Sequencer 的虚拟序列。

### 练习 12：Factory Override
实现 Transaction 类型的运行时替换。

### 练习 13：Register Model
实现简单的 RAL 模型（控制/状态寄存器）。

### 练习 14：Coverage Model
实现功能覆盖率组。

### 练习 15：Config Object
使用对象封装复杂配置。

---

## Level 3：综合（3 题）

### 练习 16：完整 AXI Agent
实现完整的 AXI4-Lite Agent。

### 练习 17：Scoreboard 系统
实现期望值 vs 实际值比较。

### 练习 18：回归测试
编写多个测试用例的回归脚本。

